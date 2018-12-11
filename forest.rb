require "./settings.rb"
require "./tree.rb"

class Forest
	attr_accessor :trees
	
	def initialize( init_array )
		@year = 0
		@trees = Array.new
		init_array.each do | buf |
		@trees.push(  Tree.new( buf[0], buf[1], buf[2], buf[3], buf[4], buf[5],0 ) )#Treeクラスはtree.rbで定義
		@settings = Settings.new
		end
		
	end


	def yearly_activities#成長量･新規･枯死計算
		crdcal
		trees_grow#下で定義されてる
#		@trees.concat( newborn )#配列treesの末尾に引数の配列newbornを結合
		trees_newborn
		tree_death#下で定義されてる
		@year += 1
	end
	


	def records
		buf = Array.new
		@trees.each do | tree |
			buf.push( [ @year ]+tree.record )
		end
		return buf
	end

	################
	# Internal routine

	def trees_grow
		@trees.each do | tree |
			
			tree.grow
			
		end
	end
	def trees_count
		spcount=[]

#		for sp in 1..@settings.num_sp do
#			spcount[sp-1]=0
#		end

#		@trees.each do |tree|
#			spcount[tree.sp-1]+=1
#		end
		p spcount
	end
	def trees_newborn
		oyagi=Array.new
		for spp in 1..@settings.num_sp do
			oyagi=@trees.select{
				|tree| tree.sp==spp
			}
			oyakazu=oyagi.count
			num_newborn=oyakazu*@settings.spdata(spp,"kanyu1")
			for i in 1..num_newborn.to_i do
				for j in 1..1000 do
					oya=rand(oyakazu)-1
					#親木を選ぶ
					kyori=rand(0.0..1.0)
					kaku=rand(0.0..2.0*Math::PI)
					kouhochi=Tree.new(
						oyagi[oya].x + kyori*Math.sin(kaku),#@x
						oyagi[oya].y + kyori*Math.cos(kaku),#@y
						spp,
						0,#age
						0.1,#size
						0,#@tag.にしておくと割り振られる
						oyagi[oya].tag#mother木のタグ
						)
					ds=0.0

					@trees.each do |obj|
						_dist =dist(kouhochi, obj)
						if _dist<@settings.spdata(spp,"kanyu4")&&obj.sp!=spp
							if _dist==0.0
								ds+=obj.mysize/0.01
							else
								ds+=obj.mysize/_dist
							end
						end
					end

					kanyu=rand(0.0..1.0)
					kanyuritu=1.0/(1.0+Math::exp(-ds*@settings.spdata(spp,"kanyu3")-@settings.spdata(spp,"kanyu2")))

					if kanyu<kanyuritu
						@trees.push(kouhochi)
						break
					end
				end

				
				
			end
			
			
		end
		


#		for sp in 0..@settings.num_sp-1 do
#			new=spcount[sp-1]*spdata(sp,"kanyu1").to_i
			#新個体の数を決定
#		end
		
	end


	def newborn
		juvs = Array.new
		@trees.each do | tree |
			juvs.concat( tree.reproduction )
		end
		crdcal(juvs)
		p 'juvs='+juvs.to_s
		juvs.delete_if{|x| x.seed_dead}
		p 'ikinokori='+juvs.to_s
		return juvs
	end

	def tree_death
		@trees.delete_if{|x| x.is_dead }#死んだらその木を消す
	end
	
	#crd,距離ごとにもう少し細かく分けないと加入率計算ができない.
	
def crdcal
		@trees.each do |tar|
			tar.crd=0.0
			tar.kabu=0.0
			@trees.each do | obj |#treesのデータがobjに格納された上で以下の処理を繰り返す
				if obj.tag != tar.tag then#obj.num≠target.numberならば･･･
					_dist =dist(tar, obj)#targetとobjの距離を_distで返す
					if _dist<9.0
						if obj.sp==tar.sp&&_dist<1.0
							if _dist==0.0
								tar.kabu+=obj.mysize/0.01
							else
								tar.kabu+=obj.mysize/_dist
							end
						else
							if _dist==0.0
								tar.crd+=obj.mysize/0.01
							else
								tar.crd+=obj.mysize/_dist
								
							end
							
						end
					end
				end
			end
			
		end
	end
	def dist( tree_a, tree_b )
		return Math::sqrt(sq(tree_a.x - tree_b.x) + sq(tree_a.y - tree_b.y))#木aと木bの距離。sqは上で定義されている
	end
	def sq (_flt)
		return _flt * _flt
	end
	

end