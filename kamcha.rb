require "./simulator.rb"
require 'timeout'
######################
# Fix random numbers: for development purpose

#ARGVはコマンドライン引数の取得
if ARGV.size < 3
	STDERR.print "Usage: ruby #{$0} setting_filename initial_filename output_filename\n"
	exit
end

simulator = Simulator.new( ARGV[0], ARGV[1], ARGV[2] )

#.newで作成したobjectに対してinitializeメソッドを呼び出し
begin
  Timeout.timeout(30){
 simulator.run
  }
rescue Timeout::Error
  puts "timeout"
end


#.runはsimulator.rbの中で定義されているメソッド