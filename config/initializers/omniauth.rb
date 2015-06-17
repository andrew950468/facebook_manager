OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1598207427104826', 'b054b0a1a9a3056fe8b28060013cbe25' ,{:scope => "manage_pages, publish_pages"}
end