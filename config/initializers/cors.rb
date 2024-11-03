Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV["API_DOMAIN"] || ""

    resource "*",
      headers: :any,
      methods: %i[get post put patch delete options head]
  end
end