########## 種の持つパラメータ
def params
	return [
		"growth1",#定数
		"growth2",#dbhに比例
		"growth3",#kabuに比例
		"growth4",#crdに比例
		"death1",#定数
		"death2",#dbhに比例
		"death3",#kabuに比例
		"death4",#crdに比例
		"kanyu1",#1個体あたりの加入数
		"kanyu2",#加入率定数
		"kanyu3",#加入率dsに比例
		"kanyu4",#dsを計算する距離限界
		"rep",#いらない？
		"disp", #いらない？
		"juvdeath"#いらない？
		]
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
			@@plot_x = _setdata[ "plot_x" ]
		end

		if _setdata[ "plot_y" ] != nil
			@@plot_y = _setdata[ "plot_y" ]
		end


		for i in 1..@@num_sp do#種数だけ実行
		#種ごとにsp_i_targetができて値が格納される（iは数字、targetはgrowth", "death", "rep", "disp", "juvdeath）
			@@spdata[i] = Hash.new
			params.each do | _target |
				keyword = "sp_" + i.to_s + "_" + _target
				if _setdata[ keyword ] != nil
						@@spdata[i][_target] = _setdata[ keyword ]
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
