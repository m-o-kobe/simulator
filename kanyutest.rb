require"./settings.rb"
require"./simulator.rb"
require"./forest.rb"
require"./fileio.rb"
require 'timeout'

fileio = Fileio.new( "data/testset.csv","data/init.csv","data/output.dat")
tmp=Settings.new
tmp.load_file( fileio.read_settings )
forest=Forest.new([
	[2,1,3,0,10,0],
	[1,3,3,0,1,0]
	])
p forest
begin
  Timeout.timeout(30){
	forest.trees_newborn
  }
rescue Timeout::Error
  puts "timeout"
end
p forest

