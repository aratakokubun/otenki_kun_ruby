=begin
iniテスト用
=end


require 'rubygems'
require 'inifile'
require_relative 'ini_config.rb'

class TestIni
	
	@@file = "otenki_kun.cfg"

	def initialize
	 @ini = IniFile.load(@@file)
	end
		
		
	def display(section, name)
		val = @ini[section][name]
		puts "[#{section}] #{name} = #{val}"
	end
end
								
ini = TestIni.new
ini.display('Otenki_kun', 'access_key')
