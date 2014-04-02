=begin
天気botクラス
@tweetを取得し，そこに含まれる都道府県名をリスト化
そのリストに対してyahooのRSSを取得し，replyする
=end

$LOAD_PATH.push('$HOME/rubyProject/twibot')

require "rubygems"
require "twitter"
require "./rss_yahoo.rb"
require "./iniConfig.rb" # ここはアプリケーションによってファイルを修正\別ファイルを用意

class WeatherBot
	
	@@otenki_config_file = 'otenki_kun.cfg'
	@@otenki_section = 'Otenki_kun'
	@@otenki_since_id = 'since_id'
	@@otenki_consumer_key = 'consumer_key'
	@@otenki_consumer_secret = 'consumer_secret'
	@@otenki_access_key = 'access_key'
	@@otenki_access_secret = 'access_secret'

	def initialize()
		set_config()
		do_oauth()
		@rss_yahoo = RssYahoo.new
	end

	def set_config()
		@cfg_otenki = IniConfig.new(@@otenki_config_file)
		begin
			@since_id = @cfg_otenki[@@otenki_section][@@otenki_since_id]
			@consumer_key = @cfg_otenki[@@otenki_section][@@otenki_consumer_key]
			@consumer_secret = @cfg_otenki[@@otenki_section][@@otenki_consumer_secret]
			@access_key = @cfg_otenki[@@otenki_section][@@otenki_access_key]
			@access_secret = @cfg_otenki[@@otenki_section][@@otenki_access_secret]
		rescue
			puts "Could no read config file #{@@otenki_config_file}"
		end
	end
end
