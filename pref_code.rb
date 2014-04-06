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
		"道央"=>"1a",
		"道北"=>"1b",
		"道東"=>"1c",
		"道南"=>"1d",
		]
	@@hokkaido.fetch("該当なし", "0")

	def self.get_prefcode(key)
		return @@pref[key]
	end

	# 都道府県名を文字列内から探す
	def self.search_pref(str)
		result = Hash.new()
		@@pref.each do |key, val|
			if str.include?(key)
				result[key] = val
			end
		end
		return result
	end

	# 北海道の地域名を文字列ないから探す
	def self.search_hokkaido(str)
		result = Hash.new()
		@@hokkaido.each do |key, val|
			if str.include?(key)
				result[key] = val
			end
		end
		return result
	end

	# 文字列から都道府県名と北海道地域名を検索
	def self.search_code(str)
		result = Hash.new()
		# 47都道府県から検索
		@@pref.each do |key, val|
			if str.include?(key)
				# 県コード
				if val == "1"
					# 地域の参照が見つかった回数
					count = 0
					@@hokkaido.each do |hkey, hval|
						if str.include?(hkey)
							count += 1
							# 重複しない場合のみ追加
							if result.key?(hkey)
								result[hkey] = hval
							end
						end
					end
					# 北海道かつ地域参照0の場合は道央を適用
					if count == 0
						if !result.key?("道央")
								result["道央"] = @@hokkaido["道央"]
						end
					end
				# 北海道以外なら重複以外追加
				elsif !result.key?(key)
					result[key] = val
				end
			end
		end
		# 完成したhashmapを返す
		return result
	end

end
