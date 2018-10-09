OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.application.credentials.dig(:client_id), Rails.application.credentials.dig(:client_secret), { client_options: { ssl: { ca_file: Rails.root.join("cacert.pem").to_s } } }
end
