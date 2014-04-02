=begin
configファイルの読み込み用module
http://qiita.com/foostan/items/6619624d30b5820d93e4
より参照
=end

require "rubygems"
require "hashie"

module AppConfig
	extend self

	AppConfig.load(File.read(File.expand_path('./otenki_kun.cfg')))

	def load(file)
		# default
		config = Hashie::Mash.new
		config.oauth = {
				since_id: 0,
				access_key: "null",
				access_secret: "null",
				consumer_key: "null",
				consumer_secret: "null"
		}

		#overwrite
		instance_eval(file)

		config.each do |key, value|
			attr_accessor key
			send("#{key}=", value)
		end
	end
end

