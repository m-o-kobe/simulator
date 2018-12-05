########## 全種共通
RES_CONST = 1.0

########## 種の持つパラメータ
def params
	return ["growth1","growth2","growth3","growth4","death1","death2","death3","death4","kanyu1","kanyu2","kanyu3","kanyu4", "rep", "disp", "juvdeath"]
end



class Settings
	@@duration = 0
	@@num_sp = 0
	@@plot_x = 0
	@@plot_y = 0
	@@spdata = Hash.new#hash:配列に追加


	def load_file( setting_array )
		_setdata = Hash.new#ハッシュ(連想配列)_setdataを作成
		setting_array.each do | _buf |#setting_arrayを_bufという変数に入れて1行ずつ実行
			_setdata[ _buf[0] ] = _buf[1].to_f#_setdata[引数]=1行目の内容になる。例_setdata[plot_x]=10000
			#ここで作られた配列は種ごとのgrowth", "death", "rep", "disp", "juvdeathとplotの広さ、
		end

		if _setdata[ "duration" ] != nil
			@@duration = _setdata[ "duration" ].to_i
		end

		if _setdata[ "num_sp" ] != nil
			@@num_sp = _setdata[ "num_sp" ].to_i
		end

		if _setdata[ "plot_x" ] != nil
			@@plot_x = _setdata[ "plot_x" ].to_i
		end

		if _setdata[ "plot_y" ] != nil
			@@plot_y = _setdata[ "plot_y" ].to_i
		end


		for i in 1..@@num_sp do#種数だけ実行
		#種ごとにsp_i_targetができて値が格納される（iは数字、targetはgrowth", "death", "rep", "disp", "juvdeath）
			@@spdata[i] = Hash.new
			params.each do | _target |
				keyword = "sp_" + i.to_s + "_" + _target
				if _setdata[ keyword ] != nil
					if _target.include?("growth")||_target.include?("death")
						@@spdata[i][_target] = _setdata[ keyword ]#@@spdata[i][_target]にそれぞれ値を格納
						
					else
						@@spdata[i][_target] = _setdata[ keyword ].to_i
					end
				end
			end
		end

	end

	def duration
		return @@duration
	end

	def num_sp
		return @@num_sp
	end

	def plot_x
		return @@plot_x
	end

	def plot_y
		return @@plot_y
	end

	def spdata( i, key )
		return @@spdata[i][ key ]
	end
end
