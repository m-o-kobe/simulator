require "./settings.rb"

class Tree
	
	###############
	attr_accessor :x, :y, :sp, :age, :mysize,:tag, :mother, :crd,:kabu
	# Newborn tags: Change if the initial data has >10000 trees
	@@tag = 10001

	def initialize( _x, _y, _sp, _age, _mysize, _tag, _mother )
		@settings = Settings.new
		@x = _x
		@y = _y
		@sp = _sp
		@age = _age
		@mysize = _mysize
		@mother = _mother
		@crd=0
		@kabu=0
		#tagは木の一本ずつに振ってある番号
		if _tag != 0 then
			@tag = _tag
			
		else
			@tag = @@tag
			@@tag += 1
		end
	end
	


	def resource
		return RES_CONST * @mysize#settingでRES_CONSTが定義されている。基本は1
	end

		def grow
			@mysize+=@settings.spdata( @sp , "growth1" ) +@settings.spdata( @sp , "growth2" )*@mysize+@settings.spdata(@sp,"growth3")*@kabu+@settings.spdata(@sp,"growth4")*@crd
			@age += 1
		end
		
		
#変えるとしたらここらへん
	def reproduction
		num_juvs = ( resource / ( @settings.spdata( @sp , "rep" ).to_f ) ).to_i
		#@mysize/spdata[rep]でその木が産出する種子の数？

		seeds = Array.new
		
		for i in 0..(num_juvs-1)
			
		
			seeds.push( 
				Tree.new(
					@x + ( (rand(0.0..1.0) -0.5)* @settings.spdata( @sp , "disp" ) ).to_i,#元の木の周りに分布
					@y + ( (rand(0.0..1.0) -0.5)* @settings.spdata( @sp , "disp" ) ).to_i,#てかこれ座標は全て整数値でいいんか？
					@sp,
					0,#age
					0.1,#size
					0,#@tag.にしておくと割り振られる
					@tag#mother木のタグ
					

				)
			)
		end
		return seeds
	end
	
	

	def is_dead
		seisi=rand(0.0..1.0)
		seizonritu=1/(1+Math::exp(-@settings.spdata(@sp,"death1")-@settings.spdata(@sp,"death2")*@mysize-@settings.spdata(@sp,"death3")*@kabu-@settings.spdata(@sp,"death4")*@crd))**(1.0/3.0)
		return seisi>seizonritu
		#return @age > 15 #@settings.spdata( @sp , "death" ) #settingのdeathをageが超えたらtrue
	end
	def seed_dead
		kanyu=rand(0.0..1.0)
		
		kanyuritu=1/(1+Math::exp(-@settings.spdata(@sp,"kanyu1")-@settings.spdata(@sp,"kanyu2")*@mysize-@settings.spdata(@sp,"kanyu3")*@kabu-@settings.spdata(@sp,"kanyu4")*@crd))
		#上の式は見直したほうがいい.特に最後の3で割るとことか
		p "kanyu="+kanyu.to_s
		p "kanyuritu="+kanyuritu.to_s
		return kanyu>kanyuritu
		
	end



	def record
		return [ @x, @y, @sp, @age, @mysize, @tag, @mother,@crd,@kabu ] 
	end

	

	##############################
	#### for debug
	def show_status
		print @tag, ": ", @sp, "@ (", @x, ",", @y, ")-", @mysize, "\n"
	end
end

