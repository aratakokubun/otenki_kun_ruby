class PrefCode
	@@pref = Hash[
		# "該当なし"=>"0",
		"北海道"=>"1",
		"青森"=>"2",
		"岩手"=>"3",
		"宮城"=>"4",
		"秋田"=>"5",
		"山形"=>"6",
		"福島"=>"7",
		"茨城"=>"8",
		"栃木"=>"9",
		"群馬"=>"10",
		"埼玉"=>"11",
		"千葉"=>"12",
		"東京"=>"13",
		"神奈川"=>"14",
		"新潟"=>"15",
		"富山"=>"16",
		"石川"=>"17",
		"福井"=>"18",
		"山梨"=>"19",
		"長野"=>"20",
		"岐阜"=>"21",
		"静岡"=>"22",
		"愛知"=>"23",
		"三重"=>"24",
		"滋賀"=>"25",
		"京都"=>"26",
		"大阪"=>"27",
		"兵庫"=>"28",
		"奈良"=>"29",
		"和歌山"=>"30",
		"鳥取"=>"31",
		"島根"=>"32",
		"岡山"=>"33",
		"広島"=>"34",
		"山口"=>"35",
		"徳島"=>"36",
		"香川"=>"37",
		"愛媛"=>"38",
		"高知"=>"39",
		"福岡"=>"40",
		"佐賀"=>"41",
		"長崎"=>"42",
		"熊本"=>"43",
		"大分"=>"44",
		"宮崎"=>"45",
		"鹿児島"=>"46",
		"沖縄"=>"47",
		]
	@@pref.fetch("該当なし", "0")

	@@hokkaido = Hash[
		# "該当なし"=>"0",
		"道北"=>"1",
		"道東"=>"2",
		"道南"=>"3",
		]
	@@hokkaido.fetch("該当なし", "0")

	def self.get_prefcode(key)
		return @@pref[key]
	end

	# 都道府県名を文字列内から探す
	def search_pref(str)
		result = Hash.new()
		@@pref.each{|key, val|
			if str.include?(key) then
				result[key] = val
			end
		}
		return result
	end

	# 北海道の地域名を文字列ないから探す
	def search_hokkaido(str)
		result = Hash.new()
		@@hokkaido.each{|key, val|
			if str.include?(key) then
				result[key] = val
			end
		}
		return result
	end

	# 文字列から都道府県名と北海道地域名を検索
	def search_code(str)
		result = Hash.new()
		# 47都道府県から検索
		@@pref.each{|key, val|
			if str.include?(key) then
				# 県コード
				if val == "1" then
					# 地域の参照が見つかった回数
					count = 0
					@@hokkaido.each{|hkey, hval|
						if str.include?(hkey) then
							count += 1
							# 重複しない場合のみ追加
							if result.key?(hkey) then
								result[hkey] = hval
							end
						end
					}
					# 北海道かつ地域参照0の場合は道央を適用
					if count == 0 then
						if !result.key?("道央") then
								result["道央"] = @@hokkaido["道央"]
						end
					end
				# 北海道以外なら重複以外追加
				elsif !result.key?(key) then
					result[key] = val
				end
			end
		}
		# 完成したhashmapを返す
		return result
	end

end
