=begin
iniテスト用
=end

require 'rubygems'
require 'inifile'

class TestIni

	def initialize
		@ini = IniFile.load("otenki_kun.cfg")
	end

	def display(section, name)
		val = @ini[section][name]
		puts "[#{section}] #{name} = #{val}"
	end
end

ini = TestIni.new
ini.display('DEFAULT', 'access_key')
ini.display('Otenki_kun', 'access_key')
