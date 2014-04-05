=begin
天気botクラス
@tweetを取得し，そこに含まれ:る都道府県名をリスト化
そのリストに対してyahooのRSSを取得し，replyする
=end

$LOAD_PATH.push('$HOME/rubyProject/twibot')

require "rubygems"
require "twitter"
require_relative "rss_yahoo.rb"
require_relative "ini_config.rb"
require_relative "twitter_handler.rb"

class WeatherBot
	
	@@otenki_config_file = "otenki_kun.cfg"
	@@otenki_section = "Otenki_kun"
	@@otenki_since_id = "since_id"
	@@otenki_consumer_key = "consumer_key"
	@@otenki_consumer_secret = "consumer_secret"
	@@otenki_access_key = "access_key"
	@@otenki_access_secret = "access_secret"

	def initialize()
		set_config()
		do_oauth()
		@rss_yahoo = RssYahoo.new
	end

	# configファイルを読み込み，必要な情報をセット
	def set_config()
		@cfg_otenki = IniConfig.new(@@otenki_config_file)
		begin
			@since_id = @cfg_otenki.get_token(@@otenki_section, @@otenki_since_id)
			@consumer_key = @cfg_otenki.get_token(@@otenki_section, @@otenki_consumer_key)
			@consumer_secret = @cfg_otenki.get_token(@@otenki_section, @@otenki_consumer_secret)
			@access_key = @cfg_otenki.get_token(@@otenki_section, @@otenki_access_key)
			@access_secret = @cfg_otenki.get_token(@@otenki_section, @@otenki_access_secret)
		rescue
			puts "Could no read config file #{@@otenki_config_file}"
		end
	end

	def do_oauth()
		# Oauth認証を行う
		@twitter_handler = TwitterHandler.new(@consumer_key, @consumer_secret, @access_key, @access_secret)
	end

	# リツイートを取得
	def show_retweets_to_me()
		@twitter_handler.get_retweets_to_me(@since_id).each do |tweet|
			puts "@#{tweet.get_name()} said:"
			puts tweet.get_text()
			@since_id = tweet.get_id()
		end
	end

	# 自分のメンションが含まれるツイートを取得
	def show_mentions_to_me()
		@twitter_handler.get_mentions_to_me(@since_id).each do |tweet|
			puts "@#{tweet.get_name()} said:"
			puts tweet.get_text()
			@since_id = tweet.get_id()
		end
	end

	# configファイルのsince_idを更新
	def update_cfg()
		begin
			@cfg_otenki.update(@@otenki_section, @@otenki_since_id, @since_id)
		rescue
			puts "file:#{@@otenki_config_file} could not be over wirtten."
		end
	end

	# main(sub)から構成される場所情報からmainのみを抽出
	def extract_place(place)
		list = place.split(' (')
		# 0:main 1;sub
		return list[0]
	end

	# yahooRSSのtitleから天気と地名を抽出
	def extract_from_title(title)
		# spaceで区切られているので分割
		list = title.split(' ')
		# 分割したリストは以下の様になる
		# 0: 【
		# 1: 14日
		# 2: 伊豆諸島南部(八丈島)
		# 3: 】
		# 4: 雨
		# 5: -
		# 6: 13℃/9℃
		# 7: -
		# 8: Yahoo!天気・災害

		# 2,4,6を連結して，出力結果とする
		# encodeをutf-8に変更
		list.collect! do |item|
			item.gsub(/\\u([\da-fA-F]{4})/){
				[$1].pack('H*').unpack('n*').pack('U*')
			}
		end
		info = "[#{list[2].force_encoding('utf-8')}:#{list[4].force_encoding('utf-8')},#{list[6].force_encoding('utf-8')}]"
		return info
	end

	def make_posts_from_tweets(tweets)
		posts = Array.new

		tweets.each do |tweet|
			id = tweet.get_id()
			name = tweet.get_name()
			text = tweet.get_text()

			# since_idを更新
			@since_id = id

			# tweetの文字列ないから地名を抜き出し，そのRSSのurlを取得
			result = @rss_yahoo.get_rss_list(text)
			# resultが空なら処理を行わない
			if !result.nil?
				# 配列に格納して最後に連結
				message = Array.new
				result.each do |place, titles|
					message.push("#{place}の天気")
					titles.each do |title|
						area_weather = extract_from_title(title.to_s().force_encoding("utf-8"))
						# 最後の要素でなければ，','を連結
						if title != titles.last
							area_weather << ', '
						end
						message.push(area_weather)
					end
					message.push('\n')
				end
				message.push('です!')

				# ツイート用のフォームを作成
				post = "@#{name}#{message.join('')}"
				# debug用の表示
				# puts post
				# 結果格納用の配列に追加
				posts.push(post)
			end
		end
		# 結果を出力
		return posts
	end

	# リストを全てツイート
	def tweet_posts(posts)
		posts.each do |post|
			len = post.length
			# ツイッターの文字制限140文字を超える場合は140字まででカット
			if len > 140
				@twitter_handler.update(post.slice(0,140))
			else 
				@twitter_handler.update(post)
			end
		end
	end

	# twitter投稿用テスト
	def do_test()
		# メンションのリストを取得
		mentions = @twitter_handler.get_mentions_to_me(@since_id)
		# 各メンションのリストから地名を検索し，そのRSSを取得
		posts = make_posts_from_tweets(mentions)
		# ツイート(予定)を表示
		posts.each do |post|
			puts post
		end
	end


	# 全体の処理
	def do_post()
		# メンションのリストを取得
		mentions = @twitter_handler.get_mentions_to_me(@since_id)
		# 各メンションのリストから地名を検索し，そのRSSを取得
		posts = make_posts_from_tweets(mentions)
		# 取得したリストを元にリプライを返す
		tweet_posts(posts)
		# configファイルのsince_idを更新
		update_cfg()
	end
end
