require "./settings.rb"
require "./tree.rb"

class Forest
	attr_accessor :trees
	@@num_count=Hash.new
	@@death_count=Hash.new
	@@recruit_count=Hash.new
	
	def initialize( init_array )
		@year = 0
		@settings = Settings.new
		@trees = Array.new
		init_array.each do | buf |
			@trees.push(  Tree.new( 
				buf[0],
				buf[1],
				buf[2],
				buf[3],
				buf[4],
				buf[5],
				0,
				buf[6]
				) )#Treeクラスはtree.rbで定義
		end
	end
	def yearly_activities#成長量･新規･枯死計算
		@year += 1
		reset_counter
		crdcal
		if @year%@settings.firefreq==0 then
			trees_newborn("fire")
			tree_death("fire")
			crdcal
		else
			trees_newborn("normal")
			tree_death("normal")
		end
		trees_grow
	end
	def reset_counter
		for spp in 1..@settings.num_sp do
			@@num_count[spp]=0
			@@death_count[spp]=0
			@@recruit_count[spp]=0
		end
	end
	
	def stat_records
		buf=Array.new
		buf.push([@year]+["num"]+[@@num_count.values])
		buf.push([@year]+["death"]+[@@death_count.values])
		buf.push([@year]+["sinki"]+[@@recruit_count.values])
		return buf
	end
	
	def tree_death(fire)
		dead_tree=@trees.select{
			|tree| tree.is_dead(fire)
		}
		for spp in 1..@settings.num_sp do
			@@death_count[spp]+=dead_tree.count{|item| item.sp==spp}
		end
		@trees=@trees-dead_tree
	end
	
	def kakunin
		puts @@num_count
		puts @@death_count
		puts @@recruit_count
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
			@@num_count[tree.sp]+=1
		end
	end
	
	def parent_select(sp)
		parent_tree=Array.new
		parent_tree=@trees.select{
				|tree| tree.sp==sp&&tree.mysize>5.0
			}
		return parent_tree
	end
	def trees_newborn(fire)
		larix_recruit(fire)
		betula_recruit(fire)
		populus_recruit(fire)
	end
	def larix_recruit(fire)
		if fire=="fire"
			para=["kanyu3","kamyu5"]
		elsif fire=="normal"
			para=["kanyu1","kanyu2"]
		end
		parent_trees=Array.new
		parent_trees=parent_select(1)
		parent_trees.each do |parent|
			recruit_expect=(parent.mysize*@settings.spdata(1,para[0]))
			recruit_number=expect(recruit_expect)
			@@recruit_count[1]+=recruit_number
			if recruit_number>0 then
				for i in 1..recruit_number do
					random_newborn(1,parent)
				end
			end
		end
	end
	def populus_recruit(fire)
		if fire=="fire"
			para=["kanyu3","kamyu5","kanyu6"]
		elsif fire=="normal"
			para=["kanyu1","kanyu2","kanyu7"]
		end
		parent_trees=Array.new
		parent_trees=parent_select(3)
		parent_trees.each do |parent|
			recruit_expect=(parent.mysize*@settings.spdata(3,para[0]))
			recruit_number=expect(recruit_expect)
			@@recruit_count[3]+=recruit_number
			if recruit_number>0 then
				for i in 1..recruit_number do
					random_newborn(3,parent)
				end
			end
		end
	end
	def betula_recruit(fire)
		if fire=="fire"
			para=["kanyu3","kamyu5"]
		elsif fire=="normal"
			para=["kanyu1","kanyu2"]
		end
		parent_trees=Array.new
		parent_trees=parent_select(2)
		parent_trees.each do |parent|
			####実生更新####
			seed_recruit_expect=(parent.mysize*@settings.spdata(2,para[0]))
			seed_recruit_number=expect(seed_recruit_expect)
			@@recruit_count[2]+=seed_recruit_number
			if seed_recruit_number>0 then
				for i in 1..seed_recruit_number do
					random_newborn(2,parent)
				end
			end
			####株立ち更新####
			sprout_recruit_expect=(parent.mysize*@settings.spdata(2,para[0]))
			sprout_recruit_number=expect(sprout_recruit_expect)
			@@recruit_count[2]+=sprout_recruit_number
			if sprout_recruit_number>0 then
				for i in 1..sprout_recruit_number do
					around_parent(2,parent)
				end
			end

		end
	end
	def expect(a)
	    b=1.0/(a+1.0)
	    for i in 0..1000 do
	        
	        if rand(0.0..1.0)<b
	            break
	        end
	    end
	    return i
	end

	# def trees_newborn(fire)
	# 	for spp in 1..@settings.num_sp do
	# 		if fire=="fire"
	# 			para=["kanyu3","kamyu5"]
	# 		elsif fire=="normal"
	# 			para=["kanyu1","kanyu2"]
	# 		end	

	# 		parent_tree=Array.new
	# 		parent_tree=parent_select(spp)
	# 		parent_num=parent_tree.count
	# 		kanyuusuu=(parent_num*@settings.spdata(spp,para[0])).to_i
	# 		@@recruit_count[spp]+=kanyuusuu
	# 		for i in 1..kanyuusuu do
	# 			if @settings.spdata(spp,para[1])<=rand(0.0..1.0)#加入場所がランダムか親木の周りかの決定
	# 				around_parent(spp,parent_tree,parent_num)
	# 			else
	# 				random_newborn(spp,parent_tree,parent_num)
	# 			end
	# 		end
	# 	end
	# end

	def around_parent(spp,parent)
		distance=rand(0.0..1.0)*@settings.spdata(spp,"kanyu4")
		angle=rand(0.0..2.0*Math::PI)
		cand_x=parent.x+distance*Math.sin(angle)#@x
		cand_y=parent.y+distance*Math.cos(angle)#@y
		ds=0.0
		@trees.push(Tree.new(
			cand_x,
			cand_y,
			spp,
			0,#age
			0.0,#size
			0,#@tag
			parent.tag,#motherのタグ
			parent.sprout
			))
	end
	def random_newborn(spp,parent)
		for j in 1..1000 do
			cand_x=rand(0.0..@settings.plot_x)
			cand_y=rand(0.0..@settings.plot_y)#@y
			ds=0.0
			ss=0.0
			@trees.each do |obj|
				_dist =((cand_x-obj.x)**2.0+(cand_y-obj.y)**2.0)**0.5
				if obj.sp!=spp then
					if _dist<@settings.spdata(spp,"kanyu21")
						if _dist==0.0
							ds+=obj.mysize/0.01
						else
							ds+=obj.mysize/_dist
						end
					end
				elsif obj.sp==spp
					if _dist<@settings.spdata(spp,"kanyu24")
						if _dist==0.0
							ss+=obj.mysize/0.01
						else
							ss+=obj.mysize/_dist
						end
					end
				end
			end
			kanyuritu=1.0/(1.0+Math::exp(-ds*@settings.spdata(spp,"kanyu22")-
			ss*@settings.spdata(spp,"kanyu22")-
			@settings.spdata(spp,"kanyu23")))
			if rand(0.0..1.0)<kanyuritu
				@trees.push(Tree.new(
					cand_x,
					cand_y,
					spp,
					0,#age
					0.0,#size
					0,#@tag
					parent.tag,#motherのタグ
					"newsprout"
					))
				break
			end
		end
	end

	def crdcal
		@trees.each do |tar|
			tar.crd=0.0
			tar.sc=0.0
			@trees.each do | obj |#treesのデータがobjに格納された上で以下の処理を繰り返す
				if obj.tag != tar.tag then#obj.num≠target.numberならば･･･
					_dist =dist(tar, obj)#targetとobjの距離を_distで返す
					if _dist<9.0
						if tar.sprout==obj.sprout&&tar.sprout!=0
							if _dist==0.0
								tar.sc+=obj.mysize/0.01
							else
								tar.sc+=obj.mysize/_dist
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
	
	def sq(_flt)
		return _flt * _flt
	end
end