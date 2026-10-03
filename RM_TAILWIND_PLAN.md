# Migrating Seasoning off Tailwind to vanilla CSS

This is a working plan. It is not a spec for one big change: the migration is
broken into small units, and each unit is a separate jj change so the whole
stack can be reviewed bit by bit at the end.

## Goal

Replace Tailwind utility classes in ERB with semantic vanilla CSS, then remove
the Tailwind toolchain (npm dependencies, the CSS build step, the forms plugin,
and the Prettier Tailwind plugin).

Tailwind and vanilla CSS coexist during the migration. The app must render
correctly and the test suite must pass after every unit, so we can stop at any
point.

## Why this is tractable

- The app is small: 47 ERB files, ~1,900 lines, 327 `class=` attributes,
  roughly 166 distinct utility tokens.
- The compiled stylesheet is only ~40 KB.
- Utility usage is shallow. Variants are almost entirely `hover:` and `focus:`,
  plus 27 responsive classes across `sm`/`md`/`lg`/`xl`. There is no `dark:`,
  no `group:`/`peer:`, and exactly one arbitrary value (`[2.5rem]`).
- No JavaScript reads or writes class names (`classList`/`className` are
  unused), and no helper builds class strings.
- Tests do not assert on class names. They use `data-test-id`, visible text,
  labels, and links.
- Component classes already exist in `application.css` (`.rounded-button`,
  `.text-field`, `.select-field`, `.flash`, `.collapsible-note*`,
  `.rendered-markdown`), so some styles can be reused as-is.

## Working agreement: one unit per jj change

We use `jj`, and every unit of work gets its own change. Do not stop between
units for review; keep going until the migration is done, then the whole stack
can be reviewed bit by bit.

- Before starting a unit, run `jj new` (or `jj new -m "..."`). This freezes the
  previous unit as its own change and starts a fresh working copy on top.
- Keep a unit small: one page, or one shared component. If a unit starts to
  touch unrelated views, split it.
- Do not remove Tailwind until the final teardown unit. Intermediate units only
  add CSS and swap classes in the views they own.
- After finishing a unit, describe it (`jj describe -m "..."`) and immediately
  start the next unit with `jj new`.

Typical loop for one unit:

```sh
jj new -m "Convert <unit> to vanilla CSS"

# edit the view(s) and the stylesheet

npm run build:css
PARALLEL_WORKERS=1 HEADLESS=1 bin/rails test test/system/<relevant>_test.rb
bin/lint

# optional but encouraged: bin/dev and eyeball the page
jj describe -m "Convert <unit> to vanilla CSS"
```

`PARALLEL_WORKERS=1` matters on macOS: parallel system tests are flaky and can
hang, which looks like a broken change when it is not.

## Per-unit checklist

1. Read the view or partial and every partial it renders.
2. Inventory the utilities it uses and map them to semantic classes.
3. Add the CSS to the appropriate stylesheet.
4. Build CSS (`npm run build:css`).
5. Run the relevant system tests with `PARALLEL_WORKERS=1 HEADLESS=1`.
6. Run `bin/lint`.
7. Visually check the page with `bin/dev`.
8. `jj describe` and continue with the next unit.

## CSS conventions

- Keep design tokens in one shared file (`app/assets/stylesheets/tokens.css`),
  imported from `application.css`. Use semantic names (`--ink`, `--line`,
  `--accent`, `--surface`, `--shadow-card`) rather than Tailwind's
  `--color-gray-900`.
- Copy token values verbatim from Tailwind v4's emitted CSS so the page looks
  unchanged. The pilot's `shows.css` has the palette and shadow already.
- Prefer one stylesheet per page or area, named after the view. Import each
  from `application.css` with a relative `@import`.
- Use BEM-ish names (`.show-card`, `.show-card__title`, `.panel--roomy`).
- Reuse the existing component classes before writing new ones.
- Breakpoints map to `640px` (`sm`) and `1024px` (`lg`). Tailwind breakpoints
  are viewport-based, not container-based, so keep them as media queries.
- `space-y-*` becomes `> :not(:last-child) { margin-block-end: ... }`.

## Units of work

### Phase 0 - groundwork

1. **(done)** Pilot: `shows/index.html.erb` and `shows/_activity_feed.html.erb`
   converted, with `app/assets/stylesheets/shows.css`.
2. Extract the tokens from `shows.css` into `app/assets/stylesheets/tokens.css`
   and import it from `application.css`. Update `shows.css` to rely on it.

### Phase 1 - global shell

3. `layouts/application.html.erb` (sticky nav, flash, notifications, footer).
4. Clean up the base styles already in `application.css`: replace the remaining
   `@apply` usages and the `var(--color-*)` references with tokens.

### Phase 2 - shared partials

Each of these is reused across pages, so a change here affects several pages at
once. Review them with that in mind.

5. `application/_poster.html.erb` (the `size`-based width classes).
6. `application/_episode_badge.html.erb`.
7. `application/_star.html.erb` and `application/_star_rating.html.erb`.
8. `application/_air_date.html.erb` and `application/_more_info.html.erb`.
9. `application/_show_search_bar.html.erb`.

### Phase 3 - pages (one unit each)

- `shows/show.html.erb` plus `_seasons_list`, `_show_metadata`,
  `_note_to_self`, `_available_same_day`, `_choose_show_status_button`,
  `_add_or_remove_show`
- `seasons/show.html.erb` plus `_season_metadata`
- `episodes/show.html.erb` plus `_episode_metadata`
- `season_reviews/new.html.erb`, `edit.html.erb`, `show.html.erb`, `_form`
- `reviews/index.html.erb`
- `searches/show.html.erb`, `_tmdb_show_result`, `_database_show_result`
- `stats/show.html.erb` (the heaviest responsive layout)
- `human_profiles/show.html.erb`
- `settings/show.html.erb`
- `admins/show.html.erb`
- `credits/show.html.erb`
- `changelogs/show.html.erb` and `roadmaps/show.html.erb`
- `notes_to_self/edit.html.erb`
- `magic_links/new.html.erb`, `magic_links/show.html.erb`,
  `passwords/edit.html.erb`, `password_sessions/show.html.erb`,
  `signups/show.html.erb`, `check_your_email/show.html.erb`
- `offline/show.html.erb`

Mailer templates (`*.text.erb`) carry no CSS and can be skipped.

### Phase 4 - teardown (one unit)

- Remove `@import "tailwindcss"` and `@plugin "@tailwindcss/forms"`.
- Remove the last `@apply` usages.
- Remove `tailwindcss`, `@tailwindcss/cli`, and `@tailwindcss/forms` from
  `package.json`, and `prettier-plugin-tailwindcss` plus its `.prettierrc.toml`
  entry.
- Replace the CSS build step. Today `build:css` runs the Tailwind CLI; once
  Tailwind is gone we need another way to concatenate/minify (for example
  esbuild, which is already a dependency, or a plain `@import` served by
  Propshaft). See open questions.
- Update `AGENTS.md`, `bin/build-and-test`, `bin/lint`, and CI references.

## Gotchas

- `application.css` still references Tailwind theme variables
  (`var(--color-gray-200)`, `var(--color-yellow-600)`,
  `var(--color-orange-600)`). These break the moment Tailwind is removed, so
  Phase 1 must replace them with our own tokens.
- `@tailwindcss/forms` normalizes form controls. Before removing it, make sure
  every input, select, and textarea has explicit styling (the app already uses
  `.text-field` and `.select-field` in most places).
- `prettier-plugin-tailwindcss` sorts class order in ERB. Dropping it will
  reshuffle class strings, so expect a noisy diff in the teardown unit.
- Shared partials (Phase 2) change many pages at once. Run a broad slice of
  system tests for those units, not just one page's tests.
- The `lg:` variants in `shows/index` are viewport-based even though the layout
  caps content at `max-w-3xl`; keep media queries viewport-based to match.
- CSS must be built before tests (`npm run build:css`).

## Open questions

- What replaces the Tailwind CLI for CSS bundling/minification in Phase 4?
  esbuild is already present and can bundle CSS; Propshaft alone would ship
  multiple files or require manual `@import`.
- Do we want the tokens file to be the single source of truth for colors and
  spacing, or keep values inline per stylesheet?
