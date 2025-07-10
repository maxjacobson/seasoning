# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Seasoning is a Ruby on Rails application for tracking TV show viewing progress.

**Tech Stack:**

- Backend: Ruby on Rails 8 with PostgreSQL
- Frontend: ERB templates with Tailwind CSS 4, Turbo Rails for SPA-like navigation
- JavaScript: jsbundling-rails with esbuild for bundling
- Testing: Minitest (Rails), Capybara with Playwright for system tests
- API: The Movie Database (TMDB) for show data
- Deployment: Heroku with Heroku Scheduler for background tasks

## Development Commands

### Setup

```bash
# IMPORTANT: Initialize rbenv for correct Ruby version
eval "$(rbenv init -)"

# Initial setup
bin/setup

# Start development server
rails server
```

### Frontend Development

```bash
# Build JavaScript and CSS
bin/rails javascript:build
bin/rails css:build

# Or use npm scripts
npm run build:css
npm run build
```

### Testing

```bash
# Full test suite (requires JS/CSS build first)
bin/rails javascript:build
bin/rails css:build
bin/rails test:all

# Individual test types
bin/rails test
bin/rails test:system

# Run a single test file
bin/rails test test/path/to/test_file.rb

# Run a specific test method
bin/rails test test/path/to/test_file.rb:line_number
```

### Code Quality

```bash
# IMPORTANT: Ensure rbenv is initialized first
eval "$(rbenv init -)"

# Ruby linting
bin/rubocop

# Code formatting
node_modules/.bin/prettier --write .
```

## Architecture

### Rails Backend

- **Models**: Core entities include Human, Show, Season, Episode, SeasonReview, Follow
- **Controllers**: Split between traditional Rails controllers and API controllers under `/api`
- **Services**: Business logic in `app/services/` (e.g., `RefreshShow`, `FindOrCreateShow`)
- **Jobs**: Background processing with SuckerPunch (`RefreshShowJob`, `BoomJob`)
- **Serializers**: JSON API responses using OJ serializers

### Architecture Notes

- Rails handles all routes with server-side rendering using ERB templates

### Database

- PostgreSQL with standard Rails migrations
- Key relationships: Human → MyShow → MySeason → Episode tracking
- Session management with database-backed sessions

## Code Style

**Comments**: Avoid comments unless absolutely necessary. Code should be self-explanatory.

**Terminology**: Use "human" not "user" - the core model is `Human`, not `User`. This is deliberate terminology throughout the codebase.

## UI/UX Style Guide

- Prefer sentence case for buttons and labels (not title case)
- Brand color is orange

## Migrations

- Always make migrations reversible
- Test rollback functionality before committing
- Use `change` method instead of separate `up` and `down` methods when possible
- Add thoughtful `down` methods for complex schema changes

## Key Files

- `config/routes.rb` - Defines Rails routes
- `app/models/` - Rails models with business logic
- `app/controllers/` - Rails controllers for web requests
- `app/assets/stylesheets/application.css` - Main CSS file with Tailwind imports and custom styles
- `app/javascript/application.js` - Main JavaScript file with Turbo Rails import
- `run-pty.json` - Development server configuration for running Rails, CSS, and JS watchers

## Scheduled Tasks (Heroku Scheduler)

- `prune:all` - Daily cleanup of expired MagicLink records
- `db:sessions:trim` - Daily cleanup of Rails sessions (midnight UTC, 180-day threshold)
- `tmdb:refresh_config` - Daily TMDB API configuration refresh
- `tmdb:refresh_shows` - Daily show data refresh

## Testing Notes

- System tests use Capybara with Playwright driver
- **JS/CSS must be built before running tests** - System tests rely on properly styled elements being visible and interactive
- Test fixtures and WebMock stubs for TMDB API in `test/webmock/`
- Never add `sleep` statements to system tests to help them pass reliably - use proper Capybara waiting methods instead
- When running tests you might encounter a segfault when the tests run in parallel which you can always retry with PARALLEL_WORKERS=1 set to make it run non-parallel
- **Do not use controller tests. Use system tests**
- In system tests, act as a user, so prefer clicking around instead of directly navigating to pages
- In system tests, do not use fixtures. just create the records right in the system test
- **System test authentication pattern**: Create a Human, then create a MagicLink for their email, then visit `redeem_magic_link_path(@magic_link.token)` to authenticate

## Git Workflow

- Never use --no-verify when committing

## Development Best Practices

- It's important to prefix bash commands with rbenv's init thing so that the proper ruby version is activated

## Test Data Generation

- When creating test data, prefer Halt and Catch Fire as the example show, and prefer to name humans after characters in the show (Donna Clark, Gordon Clark, Cameron Howe, Joe MacMillan, John Bosworth, Joanie Clark, or Haley Clark)

## Code Linting Tips

- You can fix rubocop long line offenses by using heredocs, which it will ignore
- When there are erb lint issues, you can often fix them with bin/erb_lint --lint-all --autocorrect

## Meaningful Changes Tips

- When making meaningful Rails changes, make sure to run bin/ruby-lint to make sure that rubocop and erb lint are satisfied with the changes too

## Development Practices

- Don't reference strftime formats in views or helpers, instead define them in @config/locales/en.yml and reference them by name

## Changelog Practices

- When checking what the current date is while updating the changelog, shell out to date to double check the date in local time
