# frozen_string_literal: true

[
  "https://en.wikipedia.org/wiki/Zoey%27s_Extraordinary_Playlist",
  "https://en.wikipedia.org/wiki/The_Sopranos",
  "https://en.wikipedia.org/wiki/Halt_and_Catch_Fire_(TV_series)",
  "https://en.wikipedia.org/wiki/Mad_Men",
  "https://en.wikipedia.org/wiki/It%27s_Always_Sunny_in_Philadelphia",
  "https://en.wikipedia.org/wiki/What_We_Do_in_the_Shadows_(TV_series)",
  "https://en.wikipedia.org/wiki/The_Magicians_(American_TV_series)"
].each do |wikipedia_url|
  wikipedia_page = Wikipedia::TVShowPage.new(wikipedia_url)
  next if Show.find_by(title: wikipedia_page.title).present?

  Show.create!(
    title: wikipedia_page.title,
    wikipedia_page_id: wikipedia_page.page_id,
    number_of_seasons: wikipedia_page.number_of_seasons
  )
end
