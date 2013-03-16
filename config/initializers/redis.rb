uri = URI.parse(ENV['REDISCLOUD_URL'] || 'redis://localhost:6379')
REDIS_OPTIONS = {:host => uri.host, :port => uri.port, :password => uri.password}
$redis = Redis.new(REDIS_OPTIONS)
