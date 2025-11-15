# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Seasoning is a Ruby on Rails application for tracking TV show viewing progress.

**Tech Stack:**

- Backend: Ruby on Rails 8.1.0.beta1 with PostgreSQL
- Frontend: ERB templates with Tailwind CSS 4, Turbo Rails for SPA-like navigation
- JavaScript: jsbundling-rails with esbuild for bundling
- Testing: Minitest (Rails), Capybara with Playwright for system tests
- API: The Movie Database (TMDB) for show data
- Deployment: Heroku with Heroku Scheduler for background tasks

## Development Commands

### Setup

```bash
# Initial setup
bin/setup

# Start development server with all watchers (Rails + CSS + JS)
bin/dev

# Or start individual components
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
# All linting (includes Ruby, ERB, and JS)
bin/lint

# Ruby only linting
bin/ruby-lint

# Ruby linting only
bin/rubocop

# ERB linting only
bin/erb_lint --lint-all

# Code formatting
node_modules/.bin/prettier --write .
```

## Architecture

### Rails Backend

- **Models**: Core entities include Human, Show, Season, Episode, SeasonReview, Follow, MySeason, MyShow, ReturningShowNotification, MagicLink
- **Controllers**: Traditional Rails controllers (no API controllers currently)
- **Services**: Business logic in `app/services/` (e.g., `RefreshShow`, `FindOrCreateShow`, `RefreshEpisodes`, `RemoveMyShow`)
- **Jobs**: Background processing with SuckerPunch (`RefreshShowJob`, `BoomJob`)

### Architecture Notes

- Rails handles all routes with server-side rendering using ERB templates

### Database

- PostgreSQL with standard Rails migrations
- Key relationships: Human → MyShow → MySeason → Episode tracking
- Session management with database-backed sessions

## Code Style

**Comments**: Avoid comments unless absolutely necessary. Code should be self-explanatory.

**Terminology**: Use "human" not "user" - the core model is `Human`, not `User`. This is deliberate terminology throughout the codebase.

**SQL Writing**:

- Prefer lowercase keywords
- When writing complex sql queries, and creating aliases for tables, prefer long descriptive names (e.g. humans_seasons) over short, non-obvious aliases like s2

## UI/UX Style Guide

- Prefer sentence case for buttons and labels (not title case)
- Brand color is orange
- Available episodes badge: Shows on each show card in the shows list, displays the count of available unwatched episodes. If count > 9, shows "•" instead of the number. If count is 0, no badge is shown.

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

- Claude Code properly inherits rbenv configuration from the parent shell, so no special Ruby version initialization is needed

## Test Data Generation

- When creating test data, prefer Halt and Catch Fire as the example show, and prefer to name humans after characters in the show (Donna Clark, Gordon Clark, Cameron Howe, Joe MacMillan, John Bosworth, Joanie Clark, or Haley Clark)

## Code Linting Tips

- **Prefer using `bin/fix-lints` to automatically fix linting issues** instead of manually fixing indentation and formatting problems. This is much faster and more reliable than manual fixes.
- You can fix rubocop long line offenses by using heredocs, which it will ignore
- When there are erb lint issues, you can often fix them with bin/erb_lint --lint-all --autocorrect
- **Formatting tools by file type:**
  - **Prettier** is used for: yml, json, css, js, md files
  - **Herb tools** (@herb-tools/linter and @herb-tools/formatter) are used for: html.erb files (NOT Prettier)
  - **Note**: You rarely need to run herb-format or herb-lint directly since `bin/fix-lints` runs them for you
  - If you do need to run herb-format directly, use `herb-format .` (formats by default, no --write flag needed)
  - Claude Code inherits node_modules/.bin in PATH, so no need to prefix commands with `node_modules/.bin/`

## Meaningful Changes Tips

- When making meaningful Rails changes, make sure to run bin/lint to make sure that all linting (Ruby, ERB, and JS) passes

## Development Practices

- Don't reference strftime formats in views or helpers, instead define them in @config/locales/en.yml and reference them by name

## Changelog Practices

- When checking what the current date is while updating the changelog, shell out to date to double check the date in local time

## File References

- Reference @db/schema.rb to see the database schema
