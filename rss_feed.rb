=begin
RSSFeedを取得するクラス
=end

require "rubygems"
require "feedjira"

class RssFeed
	def initialize(url)
		@url = url
	end

	def get_url()
		return @url
	end

	def set_url(url)
		@url = Url
	end

	# 実際にRSSを取得する
	def get_rss(url = @url)
		# feed_urls = Feedbag.find(@url)
		return Feedjira::Feed.fetch_and_parse(url)
	end

end
