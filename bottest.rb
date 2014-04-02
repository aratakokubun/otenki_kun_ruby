=begin
ツイッター投稿テスト
=end

require "rubygems"
require "twitter"
require "pp"

=begin
old version under api 5
Twitter.configure do |cnf|
	cnf.consumer_key = "ykTzqBElyOkFlkLBHON3Q"
	cnf.consumer_secret = "v8LluZfl3KFVP6PaZmDgMcdbRhQjbqjGhfvRWvwbnsk"
	cnf.oauth_token = "1495797276-Ls85snLVubu2NTikMJrqkMsQ7Q29YhB5XsYlY0a"
	cnf.oauth_token_secret = "cQpLVlVQzNN08nur903WxcTspjn0ILDDuN6UdShkT4JE8"
end
Twitter.update("hello! world! from ruby!");
=end

client = Twitter::REST::Client.new do |config|
	config.consumer_key = "ykTzqBElyOkFlkLBHON3Q"
	config.consumer_secret = "v8LluZfl3KFVP6PaZmDgMcdbRhQjbqjGhfvRWvwbnsk"
	config.access_token = "1495797276-Ls85snLVubu2NTikMJrqkMsQ7Q29YhB5XsYlY0a"
	config.access_token_secret = "cQpLVlVQzNN08nur903WxcTspjn0ILDDuN6UdShkT4JE8"
end

# ツイートを行う
client.update("Hello!World! From ruby!")

# ハッシュタグstrを検索
str = "ruby"
client.search("#" + str + "-rt", :count => 10, :result_type => "recent").collect do |tweet|
	puts "#{tweet.user.screen_name}: #{tweet.text}"
end
