if ENV["REDISCLOUD_URL"]
  uri = URI.parse(ENV["REDISCLOUD_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  $redis = REDIS
  Resque.redis = REDIS
end
