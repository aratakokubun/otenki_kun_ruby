# encoding: utf-8

=begin
FeedParserのテスト
=end

=begin
require "open-uri"
require "rss"
require "net/http"
require "kconv"

# URLへアクセスしページを取得
uri = URI.parse('http://www.orsx.net/blog/feed')
# RSSとして読み込み
rss = RSS::Parser.parse(uri.read)

rss.items.each_with_index do |item, i|
	str = item.title
	puts str.gsub(/\\u([\da-fA-F]{4})/){
		[$1].pack('H*').unpack('n*').pack('U*')
	}
end
=end


require "rubygems"
require "feedjira"

feed = Feedjira::Feed.fetch_and_parse("http://rss.weather.yahoo.co.jp/rss/days/2.xml")

feed.entries.each {|item|
	puts item.title
	puts item.title.force_encoding("UTF-8")
	puts item.title.gsub(/\\u([\da-fA-F]{4})/){
		[$1].pack('H*').unpack('n*').pack('U*')
	}
	puts item.url
}
