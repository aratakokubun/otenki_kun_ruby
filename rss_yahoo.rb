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
require_relative "./pref_code.rb"

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

	@@base_url = "http://rss.weather.yahoo.co.jp/rss/days/" #[code].xm;"

	def checkKeymap(key)
		return KEYMAPS.include?(key)
	end

	def initialize(url)
		super(url)
		@pcode = prefcode()
	end

	# 県コードからurlを生成
	def make_code_url(code)
		return @@base_url + code + ".xml"
	end

	# 文字列からRSS取得用のurlリストを作成
	def make_urllist(str)
		urls = Hash.new([])
		# 文字列からxml用のコードを検索
		prefcodes = @pcode.search_code(str)
		# 含まれる県・地域ごとにurlリストを生成
		prefcodes.each{|pref, code|
			# urlを生成して追加
			url = make_code_url(code)
			urls[pref] = url
		}
		#取得したリストを返す
		return urls
	end

	# urlからrssを取得
	def get_rss_result(url)
		result = Hash.new([])
		# 生成されたurlからrssを取得
		rss = get_rss(url)
		rss.entries.each {|item|
			# 含まれる都道府県とその天気予報をhashとして返す
			title = item.title
			link = item.link
			result[title] = link
		}
		return result
	end

	# urのlistからrssを取得し，hashmaoを生成
	def get_rss_result_list(str)
		result = Hash.new([])
		urls = make_urllist(str)
		urls.each {|key, link|
			list = get_rss_result(link)
			titles = Array.new
			list.each {|item|
				titles.append(item)
			}
			result[key] = titles
		}
	end

end
