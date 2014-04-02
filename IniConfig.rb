=begin
configファイル読み込み用のクラス
=end

require 'rubygems'
require 'inifile'

class IniConfig
	
	def initialize(file)
		@ini = IniFile.load(file)
	end

	def get_token(section, name)
		return @ini[section][name]
	end
end
