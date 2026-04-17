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

# Nightly task logs (all services)
journalctl -u "seasoning-*" --since today

# Individual nightly task logs
journalctl -u seasoning-backup-db -f
journalctl -u seasoning-prune -f
journalctl -u seasoning-tmdb-refresh-config -f
journalctl -u seasoning-tmdb-refresh-shows -f
journalctl -u seasoning-new-season-checker -f
journalctl -u seasoning-trim-sessions -f

# nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

## Scheduled Tasks

A systemd timer fires nightly at midnight. Each task runs as its own independent service so a failure in one doesn't affect the others.

- `seasoning-prune` — removes expired magic links (`prune:all`)
- `seasoning-tmdb-refresh-config` — refreshes TMDB API configuration (`tmdb:refresh_config`)
- `seasoning-tmdb-refresh-shows` — refreshes show data from TMDB (`tmdb:refresh_shows`)
- `seasoning-new-season-checker` — checks for new seasons (`new_season_checker:toggle`)
- `seasoning-trim-sessions` — cleans up old sessions (`db:sessions:trim`)
- `seasoning-backup-db` — dumps the database and uploads to S3 (`bin/backup-db`)

```sh
# Check when timer last ran and next fires
systemctl list-timers seasoning-nightly.timer

# Run all nightly tasks manually right now
sudo systemctl start seasoning-nightly.target

# Run a single task manually
sudo systemctl start seasoning-backup-db
```

### Systemd unit files

These live in `/etc/systemd/system/`. After changing any of them, run `sudo systemctl daemon-reload`.

**`/etc/systemd/system/seasoning-nightly.target`**

```ini
[Unit]
Description=Seasoning Nightly Tasks
Wants=seasoning-prune.service seasoning-tmdb-refresh-config.service seasoning-tmdb-refresh-shows.service seasoning-new-season-checker.service seasoning-trim-sessions.service seasoning-backup-db.service
```

**`/etc/systemd/system/seasoning-nightly.timer`**

```ini
[Unit]
Description=Run Seasoning Nightly Tasks

[Timer]
OnCalendar=*-*-* 00:00:00
Persistent=true
Unit=seasoning-nightly.target

[Install]
WantedBy=timers.target
```

**Shared service template** (each service below follows this pattern):

```ini
[Unit]
Description=Seasoning: <task description>
After=network.target postgresql.service
Requires=postgresql.service

[Service]
Type=oneshot
User=maxwell
WorkingDirectory=/home/maxwell/Documents/seasoning
Environment=PATH=/home/maxwell/.rbenv/shims:/home/maxwell/.rbenv/bin:/usr/local/bin:/usr/bin:/bin
Environment=RAILS_ENV=production
ExecStart=<command>
```

**Individual services:**

| File                                    | ExecStart                                                                |
| --------------------------------------- | ------------------------------------------------------------------------ |
| `seasoning-prune.service`               | `/home/maxwell/.rbenv/shims/bundle exec rails prune:all`                 |
| `seasoning-tmdb-refresh-config.service` | `/home/maxwell/.rbenv/shims/bundle exec rails tmdb:refresh_config`       |
| `seasoning-tmdb-refresh-shows.service`  | `/home/maxwell/.rbenv/shims/bundle exec rails tmdb:refresh_shows`        |
| `seasoning-new-season-checker.service`  | `/home/maxwell/.rbenv/shims/bundle exec rails new_season_checker:toggle` |
| `seasoning-trim-sessions.service`       | `/home/maxwell/.rbenv/shims/bundle exec rails db:sessions:trim`          |
| `seasoning-backup-db.service`           | `/home/maxwell/Documents/seasoning/bin/backup-db`                        |

To set up from scratch:

```sh
# Write all unit files to /etc/systemd/system/, then:
sudo systemctl daemon-reload
sudo systemctl disable seasoning-nightly.service  # remove old combined service
sudo systemctl enable seasoning-nightly.timer
sudo systemctl start seasoning-nightly.timer
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
