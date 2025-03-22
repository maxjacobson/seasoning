# Seasoning Codebase Guidelines

## Build & Development Commands

- Run server: `bin/dev` (Rails server, Vite, CSS watcher)
- Build CSS: `npm run build:css`

## Test Commands

- Run non-system tests: `bin/rails test`
- Run all tests (including system tests): `bin/rails test:all`
- Run single test file: `bin/rails test path/to/test_file.rb`
- Run specific test: `bin/rails test path/to/test_file.rb:LINE_NUMBER`

## Linting Commands

- All linters: `bin/lint`
- TypeScript/JS linters: `bin/node-lint` (tsc, prettier, eslint)
- Ruby linters: `bin/ruby-lint` (rubocop, erb_lint)
- Fix lints: `bin/fix-lints`

## Code Style Guidelines

- **Ruby**: Double quotes, Rails conventions
- **Frozen String Literals**: Enabled globally via RUBYOPT
- **Testing**: Uses Rails system tests with Selenium/Chrome
- **New Code**: Avoid using React (see REMOVE_REACT_PLAN.md)
- **Existing TypeScript**: Strong typing, sorted imports
- **Error Handling**: Promise errors must be handled explicitly
- **CSS**: Tailwind for styling
- **Routes**: Prefer route helpers in views instead of hardcoded paths
- **Controllers**: One authorize! call per controller action
