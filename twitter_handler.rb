=begin
twitterのOauth認証を行い，各種操作を行う
わざわざ一回Tweetクオブジェクトを噛ませるのは無駄なので，必要ない．
直接weatherbotに記述すればいい
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
		return @client.search("#" + tag + "-rt", :count=>10, :result_type=>"recent").collect do |tweet|
			Tweet.new(tweet.user.screen_name, tweet.text)
		end
	end
	
	# timelineの取得
	def get_public_timeline(since = 1)
		return @client.home_timeline({:since_id=>since}).collect do |tweet|
			Tweet.new(tweet.user.screen_name, tweet.text)
		end
	end

	# リツイートを取得
	def get_retweets_to_me(since = 1)
		return @client.retweeted_to_me({:since_id=>since}).collect do |tweet|
			Tweet.new(tweet.user.screen_name, tweet.text, tweet.id)
		end

	end

	def get_mentions_to_me(since = 1)
		return @client.mentions(:since_id => since).collect do |tweet|
			Tweet.new(tweet.user.screen_name, tweet.text, tweet.id)
		end
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
		return @id
	end
end
