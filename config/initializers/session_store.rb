Rails.application.config.session_store(
  :cookie_store,
  key: "_seasoning_session",
  expires_after: 3.months
)
