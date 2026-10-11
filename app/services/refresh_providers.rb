RefreshProviders = lambda { |show|
  region = ShowProvider::WATCH_REGION
  tmdb_region = TMDB::Client.new.watch_providers(show.tmdb_tv_id, region: region)

  Show.transaction do
    desired = []

    ShowProvider::CATEGORIES.each do |category|
      tmdb_region.public_send(category).each do |tmdb_provider|
        provider = Provider.create_or_find_by!(tmdb_provider_id: tmdb_provider.provider_id) do |new_provider|
          new_provider.name = tmdb_provider.provider_name
          new_provider.tmdb_logo_path = tmdb_provider.logo_path
        end
        provider.update!(name: tmdb_provider.provider_name, tmdb_logo_path: tmdb_provider.logo_path)
        desired << { provider: provider, category: category, display_priority: tmdb_provider.display_priority }
      end
    end

    existing = show.show_providers.index_by { |show_provider| [show_provider.provider_id, show_provider.category] }

    desired.each do |entry|
      show_provider = existing.delete([entry[:provider].id, entry[:category]])
      if show_provider.present?
        show_provider.update!(display_priority: entry[:display_priority])
      else
        show.show_providers.create!(
          provider: entry[:provider],
          category: entry[:category],
          display_priority: entry[:display_priority]
        )
      end
    end

    existing.each_value(&:destroy!)
  end
}
