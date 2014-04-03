=begin
twitterのOauth認証を行い，各種操作を行う
=end

require "rubygems"
require "twitter"

class TwitterHandler

	def initialize(consumer_key, consumer_secret, access_key, access_secret)
		@client = Twitter::REST::Client.new do |config|
			config.consumer_key = consumer_key
			config.consumer_secret = consumer_secret
			config.access_token = access_key
			config.access_token_secret = access_secret
		end
	end

	# msgのtweetを行う
	def update(msg)
		@client.update(msg)
	end

	# ハッシュタグ#tagで検索
	def search_tag(tag)
		results = Array.new
		@client.search("#" + tag + "-rt", :count=>10, :result_type=>"recent").collect do |tweet|
			results << Tweet.new(tweet.user.screen_name, tweet.text)
		end
		return results
	end
	
	# timelineの取得
	def get_public_timeline()
		results = Array.new
		@client.home_timeline().collect do |tweet|
			results << Tweet.new(tweet.user.screen_name, tweet.text)
		end
		return results
	end

	# @ツイートを取得
	def get_retweet_to_me()
		results = Array.new
		@client.retweeted_to_me().collect do |tweet|
			results << Tweet.new(tweet.user.screen_name, tweet.text, tweet.id)
		end
		return results
	end

end


# Tweetの中身を扱うクラス
class Tweet
	
	# デフォルト値としてnilを設定し，省略可能にしておく
	def initialize(name=nil, text=nil, id=nil)
		@name = name
		@text = text
		@id = id
	end

	def get_name()
		return @name
	end

	def get_text()
		return @text
	end

	def get_id()
		return id
	end
end
