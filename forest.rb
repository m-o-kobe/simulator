require "./settings.rb"
require "./tree.rb"


class Forest
	@settings = Settings.new
	def initialize( init_array )
		@year = 0
		@trees = Array.new
		init_array.each do | buf |
		@trees.push(  Tree.new( buf[0], buf[1], buf[2], buf[3], buf[4], buf[5],0 ) )#Treeクラスはtree.rbで定義
		
		end
		
	end


	def yearly_activities#成長量･新規･枯死計算
		crdcal
		trees_grow#下で定義されてる
		@trees.concat( newborn )#配列treesの末尾に引数の配列newbornを結合
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

		def newborn
		juvs = Array.new
		@trees.each do | tree |
			juvs.concat( tree.reproduction )
		end
		return juvs.delete_if{|x| x == [] }
	end

	def tree_death
		@trees.delete_if{|x| x.is_dead }#死んだらその木を消す
	end
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