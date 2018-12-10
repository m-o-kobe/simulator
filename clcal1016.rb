require "./cltree.rb"
require "csv"
time = Time.now
srand(time.usec)
plot="ctr"
$targetspp="bp"
if plot=="ctr"
	infile = File.open("ctrl0904.csv", "r")
	jogai=484
	$xmax=100
	$ymax=50
	$xmin=0
	$ymin=0
	
elsif plot=="int"

	infile = File.open("int0905.csv", "r")

	$jogai=484
	$xmax=50.3
	$ymax=50
	$xmin=0
	$ymin=-50
end
#####変更ポイントここまで
$xmid=$xmin+($xmax-$xmin)/2
$ymid=$ymin+($ymax-$ymin)/2
############## read file
trees = Array.new#treesを配列として定義
infile.each do |line|#1行目で読み込んだinfileの1行目だけ取り除いてTreeに入れ込む処理？
	if line =~/^#/
	else
		trees.push( Tree.new(line) )
	end
end

############### Calculate

arei=Hairetu.new()
=begin
Ran=[]
for num in 1..100 do
	Ran.push(Ransu.new(num))
end
=end
Num=["num"]
Xx=["x"]
Yy=["y"]
Spp=["spp"]
Dbh01=["dbh01"]
Dbh04=["dbh04"]
trees.each do |target|
	if target.spp==$targetspp&&target.dbh01!=0.0&&target.x<=$xmax&&target.x>=$xmin&&target.y<=$ymax&&target.y>=$ymin&&target.num!=$jogai&&target.dbh01<=2.1
		Num.push(target.num)
		Xx.push (target.x)
		Yy.push(target.y)
		Spp.push(target.spp)
		Dbh01.push(target.dbh01)
		
	crdcal(target,trees,arei)

	end
end	
kazu=Num.count-1
CSV.open('n_ctr_1016bp.csv','w') do |test|
	for i in 0..kazu do
		test << [Num[i], Xx[i],Yy[i],Spp[i],Dbh01[i],arei.Crd1[i],arei.Crd2[i],arei.Crd3[i],arei.Crd4[i],arei.Crd5[i],arei.Crd6[i],arei.Crd7[i],arei.Crd8[i],arei.Crd9[i],arei.Onaji1[i],arei.Onaji2[i],arei.Onaji3[i],arei.Onaji4[i],arei.Onaji5[i],arei.Onaji6[i],arei.Onaji7[i],arei.Onaji8[i],arei.Onaji9[i]]
	end
end	