=begin
getRssFeedを継承し，実際の処理を行う具象クラス
yahoo天気のRSSフィードから取得可能なキーマップの定義
# 1   modified_parsed
# 2   description
# 3   copyright
# 4   date_parsed
# 5   url
# 6   items
# 7   tagline
# 8   modified
# 9   copyright_detail
# 10   issued_parsed
# 11   description_detail
# 12   issued
# 13   date
# 14   tagline_detail
# 15   guid
# 16   channel
=end

require_relative "rss_feed.rb"
require_relative "pref_code.rb"

class RssYahoo < RssFeed
	@@KEYMAPS = [
	"modified_parsed",
	"description",
	"copyright",
	"date_parsed",
	"url",
	"items",
	"tagline",
	"modified",
	"copyright_detail",
	"issued_parsed",
	"description_detial",
	"issued",
	"date",
	"tagline_detail",
	"guid",
	"channel"]

	@@base_url = "http://rss.weather.yahoo.co.jp/rss/days/" #[code].xml"

	def checkKeymap(key)
		return KEYMAPS.include?(key)
	end

	def initialize()
		super(@@base_url)
		# @pcode = PrefCode()
	end

	# 県コードからurlを生成
	def make_code_url(code)
		return "#{@@base_url}#{code}.xml"
	end

	# 文字列からRSS取得用のurlリストを作成
	def make_urllist(str)
		urls = Hash.new([])
		# 文字列からxml用のコードを検索
		prefcodes = PrefCode.search_code(str)
		# 含まれる県・地域ごとにurlリストを生成
		prefcodes.each do |pref, code|
			# urlを生成して追加
			url = make_code_url(code)
			urls[pref] = url
		end

		#取得したリストを返す
		return urls
	end

	# urlからrssを取得
	def get_rss_result(url)
		result = Hash.new([])
		# 生成されたurlからrssを取得
		rss = get_rss(url)
		rss.entries.each do|item|
			# 含まれる都道府県とその天気予報をhashとして返す
			title = item.title
			url = item.url
			result[title] = url
		end
		return result
	end

	# urのlistからrssを取得し，hashmapを生成
	def get_rss_list(str)
		result = Hash.new([])
		urls = make_urllist(str)
		urls.each do |pref, url|
			list = get_rss_result(url)
			titles = Array.new
			list.each do|item|
				titles.push(item)
			end
			result[pref] = titles
		end
		return result
	end

end
