Rails.application.configure do
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp.mailtrap.io',
    port: 2525,
    user_name: '30de83b6645417',
    password: '492b7aa9256637',
    authentication: :cram_md5
  }
end
