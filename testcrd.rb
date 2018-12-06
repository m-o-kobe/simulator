require"./settings.rb"
require"./simulator.rb"
require"./forest.rb"
require"./fileio.rb"

fileio = Fileio.new( "data/testset.csv","data/init.csv","data/output.dat")
tmp=Settings.new
tmp.load_file( fileio.read_settings )
forest=Forest.new([
	[1,1,3,0,10,0],
	[1,3,3,0,1,0]
	])

forest.trees.concat(forest.newborn)

p "処理後"
p forest.trees
	 