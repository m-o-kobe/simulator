require "./settings.rb"

class Tree
	
	###############
	attr_accessor :x,
				:y,
				:sp,
				:age, 
				:mysize,
				:tag, 
				:mother,
				:crd,
				:sc,
				:sprout
# Newborn tags: Change if the initial data has >10000 trees
	@@tag = 10001
	@@sprout=10001

	def initialize( _x, _y, _sp, _age, _mysize, _tag, _mother,_sprout )
		@settings = Settings.new
		@x = _x
		@y = _y
		@sp = _sp
		@age = _age
		@mysize = _mysize
		@mother = _mother
		@crd=0.0
		@sc=0.0
		#tagは木の一本ずつに振ってある番号
		if _tag != 0 then
			@tag = _tag
			
		else
			@tag = @@tag
			@@tag += 1
		end
		if _sprout != "newsprout" then
			@sprout=_sprout
			
		else
			@sprout = @@sprout
			@@sprout += 1
		end

	end

	def grow
		gro=@settings.spdata( @sp , "growth1" )+
			@settings.spdata( @sp , "growth2" )*@mysize+
			@settings.spdata(@sp,"growth3")*@sc+
			@settings.spdata(@sp,"growth4")*@crd
		if gro>=0&&@age>=5 then
			@mysize+=gro
		end
		@age += 1
	end

	def is_dead(fire)
		if fire=="fire"
			para=["death11","death12","death13","death14","death15",1.0/3.0]
		elsif fire=="normal"
			para=["death21","death22","death23","death24","death25",1.0]
		end	
		if @age<5 then
			deathrate=@settings.spdata(@sp,para[4])
		else
			deathrate=(1.0/(1.0+Math::exp(-@settings.spdata(@sp,para[0])-
				@settings.spdata(@sp,para[1])*@mysize-
				@settings.spdata(@sp,para[2])*@sc-
				@settings.spdata(@sp,para[3])*@crd)))**para[5]
		end

		return rand(0.0..1.0)>deathrate
	end
	
	def record
		return [ @x, @y, @sp, @age, @mysize, @tag, @mother,@crd,@sc,@sprout ] 
	end

	##############################
	#### for debug
	def show_status
		print @tag, ": ", @sp, "@ (", @x, ",", @y, ")-", @mysize, "\n"
	end
end

