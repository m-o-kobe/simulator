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
		@crd=0.0
		@kabu=0.0
		#tagは木の一本ずつに振ってある番号
		if _tag != 0 then
			@tag = _tag
			
		else
			@tag = @@tag
			@@tag += 1
		end
	end

	def grow
		@mysize+=@settings.spdata( @sp , "growth1" ) +@settings.spdata( @sp , "growth2" )*@mysize+@settings.spdata(@sp,"growth3")*@kabu+@settings.spdata(@sp,"growth4")*@crd
		@age += 1
	end

	def is_dead
		seisi=rand(0.0..1.0)
		seizonritu=(1.0/(1.0+Math::exp(-@settings.spdata(@sp,"death1")-@settings.spdata(@sp,"death2")*@mysize-@settings.spdata(@sp,"death3")*@kabu-@settings.spdata(@sp,"death4")*@crd)))**(1.0/3.0)
		return seisi>seizonritu
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

