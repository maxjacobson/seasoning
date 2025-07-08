# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Seasoning is a Ruby on Rails application for tracking TV show viewing progress. The app is currently in migration from React to vanilla Rails with ERB templates.

**IMPORTANT: New features should be built with Rails ERB, not React. The React components are legacy and being phased out.**

**Tech Stack:**

- Backend: Ruby on Rails 8 with PostgreSQL
- Frontend: ERB templates with Tailwind CSS 4 (migrating away from React)
- Legacy: React 19 with TypeScript, Vite for bundling (being phased out)
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

# Start development servers (run in separate terminals)
rails server
bin/vite dev  # Optional but enables hot reloading
```

### Frontend Development

```bash
# Build frontend assets
bin/vite build

# Dev server with hot reloading
bin/vite dev

# Dev server for testing
bin/vite dev --mode=test

# Build CSS
npm run build:css
```

### Testing

```bash
# Full test suite (requires frontend build first)
bin/vite build
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

# JavaScript/TypeScript linting
node_modules/.bin/eslint app/javascript

# Type checking
node_modules/.bin/tsc --noEmit

# Code formatting
node_modules/.bin/prettier --write app/javascript
```

## Architecture

### Rails Backend

- **Models**: Core entities include Human, Show, Season, Episode, SeasonReview, Follow
- **Controllers**: Split between traditional Rails controllers and API controllers under `/api`
- **Services**: Business logic in `app/services/` (e.g., `RefreshShow`, `FindOrCreateShow`)
- **Jobs**: Background processing with SuckerPunch (`RefreshShowJob`, `BoomJob`)
- **Serializers**: JSON API responses using OJ serializers

### React Frontend

- **Entry Points**: `app/javascript/entrypoints/application.ts` for Rails integration
- **Components**: Reusable UI components in `app/javascript/components/`
- **Pages**: Route-specific components in `app/javascript/pages/`
- **Routing**: React Router 7 for SPA routes, falls back to Rails for unmatched routes
- **Context**: Guest authentication and loading state management
- **Types**: TypeScript definitions in `app/javascript/types.ts`

### Architecture Notes

- Rails handles most routes with server-side rendering using ERB templates
- Legacy React SPA handles specific routes: `/shows/:showSlug/:seasonSlug/*` (being migrated)
- API endpoints under `/api` serve JSON for React components (will be deprecated as React is removed)
- Fallback route `/*anything` in Rails catches unmatched React routes

### Database

- PostgreSQL with standard Rails migrations
- Key relationships: Human → MyShow → MySeason → Episode tracking
- Session management with database-backed sessions

## Code Style

**Comments**: Avoid comments unless absolutely necessary. Code should be self-explanatory.

**Terminology**: Use "human" not "user" - the core model is `Human`, not `User`. This is deliberate terminology throughout the codebase.

## Migrations

- Always make migrations reversible
- Test rollback functionality before committing
- Use `change` method instead of separate `up` and `down` methods when possible
- Add thoughtful `down` methods for complex schema changes

## Key Files

- `config/routes.rb` - Defines both Rails and API routes
- `app/javascript/App.tsx` - Main React application component
- `app/models/` - Rails models with business logic
- `app/controllers/api/` - JSON API controllers for React frontend
- `vite.config.mts` - Vite configuration with Ruby plugin
- `eslint.config.mjs` - ESLint configuration with TypeScript and React rules

## Scheduled Tasks (Heroku Scheduler)

- `prune:all` - Daily cleanup of expired MagicLink records
- `db:sessions:trim` - Daily cleanup of Rails sessions (midnight UTC, 180-day threshold)
- `tmdb:refresh_config` - Daily TMDB API configuration refresh
- `tmdb:refresh_shows` - Daily show data refresh

## Testing Notes

- System tests use Capybara with Playwright driver
- Frontend must be built before running tests
- Test fixtures and WebMock stubs for TMDB API in `test/webmock/`
- Run `bin/vite dev --mode=test` when iterating on frontend tests to avoid rebuilding
- Never add `sleep` statements to system tests to help them pass reliably - use proper Capybara waiting methods instead

## Git Workflow

- Never use --no-verify when committing

## Development Best Practices

- It's important to prefix bash commands with rbenv's init thing so that the proper ruby version is activated

## Test Data Generation

- When creating test data, prefer Halt and Catch Fire as the example show, and prefer to name humans after characters in the show (Donna Clark, Gordon Clark, Cameron Howe, Joe MacMillan, John Bosworth, Joanie Clark, or Haley Clark)

## Code Linting Tips

- You can fix rubocop long line offenses by using heredocs, which it will ignore
- When there are erb lint issues, you can often fix them with bin/erb_lint --lint-all --autocorrect

## SPA Development Tips

- When making meaningful changes to the SPA, make sure to run bin/node-lint to confirm that typescript, eslint, and prettier are all satisfied

## Meaningful Changes Tips

- When making meaningful Rails changes, make sure to run bin/ruby-lint to make sure that rubocop and erb lint are satisfied with the changes too
