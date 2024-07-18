Cloudinary.config do |config|
    config.cloud_name = ENV['CLOUDINARY_URL'].split('@').last
    config.api_key = ENV['CLOUDINARY_URL'].split('://').last.split(':').first
    config.api_secret = ENV['CLOUDINARY_URL'].split(':').last.split('@').first
    config.secure = true
    config.cdn_subdomain = true
  end
