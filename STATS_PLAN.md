# Stats Page Implementation Plan

## Overview

Create a Letterboxd-style stats page showing a user's season review statistics for a given year.

## URL Structure

- `/max/stats` - redirects to current year
- `/max/stats/2025` - shows stats for 2025

## ✅ PHASE 1 - COMPLETED: "Reviewed During Year" Stats

### ✅ Hero Section

- Display: "max reviewed X seasons in 2025" with clickable name linking to profile

### ✅ Top 10 Favorites Grid

- Show user's 10 highest-rated seasons reviewed during that year
- Display season poster (clickable to review), show + season name, and star ratings
- Ordered by rating (highest first)
- Grid layout for multiple items per line

### ✅ Navigation

- Year pagination (previous/next year links) at bottom of page
- Link from profile page (only visible to own profile)

### ✅ Authorization

- Only visible to the user themselves
- Use `authorize! { current_human&.handle == params[:handle] }`
- Filter reviews using `viewable_by` scope for future extensibility

### ✅ Zero State

- Handle case when no reviews exist for the year

### ✅ Future Year Handling

- Return 404 for future years (e.g., `/max/stats/3000`)
- Pagination buttons do not link to future years

### ✅ Technical Implementation

- `SeasonReview.written_in(year)` scope added
- TDD approach with comprehensive system tests
- Clean, professional design

## 🚧 PHASE 2 - REMAINING WORK: "Aired During Year" Stats

### Air Date Implementation

- **Database Changes**: Add `air_date` column to `seasons` table
- **Data Population**: Persist TMDB season `air_date` when refreshing shows
- **Migration Strategy**: Update existing seasons with air dates from TMDB

### Additional Stats Sections

- **"Aired During Year" Section**: Show favorite seasons that originally aired in the year
- **Comparison View**: Toggle between "reviewed in X" vs "aired in X"
- **Mixed Stats**: Potentially show both on same page with clear sections

### Future Enhancements

- **Public Sharing**: Add user setting to control whether stats are publicly shareable
- **More Stats**: Additional metrics like average rating, genre breakdowns, etc.
- **Year Range Views**: Show stats across multiple years
- **Export Features**: Allow users to export their stats

## Technical Notes

- TMDB provides season `air_date` in `TMDB::TVDetails` model (line 12)
- Alternative approach: derive air dates from episodes table (more complex)
- Current approach focuses on season-level air dates for simplicity

## Implementation Approach

- **Test-Driven Development**: Write system tests first to describe user experience
- **Incremental Delivery**: Phase 1 focuses on core "reviewed during year" functionality
- **Future-Proof Design**: Architecture supports adding "aired during year" stats later
