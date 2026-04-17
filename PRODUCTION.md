# Production

Seasoning runs on a Raspberry Pi 5 on Maxwell's home network, exposed publicly at https://www.seasoning.tv via a Cloudflare tunnel.

## Stack

- **Ruby**: 4.0.2 (via rbenv)
- **Web server**: Puma, listening on a Unix socket at `/run/seasoning/puma.sock`
- **Reverse proxy**: nginx on port 80, proxying to Puma
- **Database**: PostgreSQL 17
- **App directory**: `/home/maxwell/Documents/seasoning`
- **Environment**: `/home/maxwell/Documents/seasoning/.env.production.local` (loaded automatically by dotenv-rails)

## Services

All services start automatically on boot.

```sh
# App
sudo systemctl status seasoning
sudo systemctl restart seasoning
sudo systemctl stop seasoning

# nginx
sudo systemctl status nginx
sudo systemctl restart nginx

# Cloudflare tunnel
sudo systemctl status cloudflared
sudo systemctl restart cloudflared
```

## Logs

```sh
# App logs (Puma + Rails)
journalctl -u seasoning -f

# Nightly task logs
journalctl -u seasoning-nightly.service -f

# nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

## Scheduled Tasks

A systemd timer fires nightly at midnight and runs these tasks in sequence:

- `prune:all` — removes expired magic links
- `tmdb:refresh_config` — refreshes TMDB API configuration
- `tmdb:refresh_shows` — refreshes show data from TMDB
- `new_season_checker:toggle` — checks for new seasons
- `db:sessions:trim` — cleans up old sessions

```sh
# Check when timer last ran and next fires
systemctl list-timers seasoning-nightly.timer

# Run tasks manually right now
sudo systemctl start seasoning-nightly.service
```

## Database

```sh
# Connect to the production database
psql seasoning_production -h /var/run/postgresql

# Restore from a Heroku dump (drop first to avoid schema conflicts)
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=production bin/rails db:drop db:create
pg_restore --no-owner --no-privileges -d seasoning_production ~/latest.dump
sudo systemctl restart seasoning
```

## Deploying Updates

```sh
cd /home/maxwell/Documents/seasoning
git pull
bundle install
npm install
RAILS_ENV=production bin/rails assets:precompile
RAILS_ENV=production bin/rails db:migrate
sudo systemctl restart seasoning
```

## nginx Config

Site config lives at `/etc/nginx/sites-available/seasoning` (symlinked into `sites-enabled`).

```sh
# Test config before reloading
sudo nginx -t
sudo systemctl reload nginx
```

## Cloudflare Tunnel

Traffic flows: Cloudflare → cloudflared → nginx (port 80) → Puma (Unix socket).

SSL is terminated by Cloudflare. The tunnel config lives at `/etc/cloudflared/config.yml`. nginx hardcodes `X-Forwarded-Proto: https` so Rails generates correct URLs despite receiving plain HTTP from cloudflared.

`config.force_ssl` is intentionally disabled in `config/environments/production.rb` — SSL enforcement is handled by Cloudflare.

```sh
# View tunnel logs
journalctl -u cloudflared -f
```
