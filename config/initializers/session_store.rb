Rails.app.config.session_store(
  :active_record_store,
  key: "_seasoning_session",
  expire_after: 3.months
)
