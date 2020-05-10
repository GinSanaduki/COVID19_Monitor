#! /bin/sh
# Cov19_Crawler.sh
# sh Cov19_Crawler.sh
# This source code is governed by a BSD-style license that can be found in the LICENSE file.

type curl > /dev/null
test $? -ne 0 && echo "This Script need curl command." && exit 99

FileNameHash=`od -A n -t u4 -N 4 /dev/urandom | \
	sed 's/[^0-9]//g' | \
	sha512sum | \
	cut -c 1-64 | \
	awk '{for(i=1; i < length($0); i++){print substr($0,i,1);}}' | \
	shuf | \
	tr -d '\n'`

Cov19_Fname="Covid19_"$FileNameHash".txt"
echo "新型コロナウイルス感染症対策サイトへの接続試行中です・・・"
curl -I --silent https://stopcovid19.metro.tokyo.lg.jp/ | grep '^HTTP' | awk '{if($2 == 200){exit;}else{exit 1;}}'
test $? -ne 0 && echo "新型コロナウイルス感染症対策サイトへの接続が失敗しました。" && exit 99
echo "新型コロナウイルス感染症対策サイトへの接続に問題はありませんでした。"
echo "2秒インターバルを開けています・・・"
sleep 2

echo "新型コロナウイルス感染症対策サイトのHTML取得中・・・"
curl --silent https://stopcovid19.metro.tokyo.lg.jp/ > $Cov19_Fname

# 検査陽性者の状況
echo "検査陽性者の状況のCSV変換開始・・・"
cat $Cov19_Fname | \
awk '{gsub(/\s/,""); print;}' | \
awk '/^検査陽性者の状況$/,/^陽性患者数$/' | \
awk '{gsub("><",">\n<"); print;}' | \
awk '/^陽性者数$/,/<divclass="DataView-Description">/' | \
fgrep -v -e 'span>' -e 'div>' -e 'li>' -e 'ul>' -e '<!' -e 'class' | \
fgrep "<strong>" | \
sed -e 's/,//g'| \
awk '{gsub("<strong>",""); gsub("</strong>",""); print;}' | \
awk '{if(NR % 6){ORS=",";} else {ORS="\n";} print;}' | \
awk 'BEGIN{print "陽性者数（累計）,入院中,軽症・中等症,重症,死亡,退院（療養期間経過を含む）";}{print;}' > "検査陽性者の状況_"$FileNameHash".csv"
echo "検査陽性者の状況のCSV変換完了"

# 陽性患者数
echo "陽性患者数のCSV変換開始・・・"
cat $Cov19_Fname | \
awk '{gsub(/\s/,""); print;}' | \
awk '/^陽性患者数$/,/^陽性患者数（区市町村別）$/' | \
awk '{gsub("><",">\n<"); print;}' | \
awk '/^<th>.*?<\/th>$/{print;}/^<tdclass="text-end">.*?<\/td>$/{print;}' | \
awk '{if(NR % 3){ORS="\t";} else {ORS="\n";} print;}' | \
awk '{gsub("<th>",""); gsub("</th>",""); gsub(/<tdclass="text-start">/,""); gsub(/<tdclass="text-end">/,""); gsub("</td>",""); gsub(",",""); gsub("/","\t"); print;}' | \
awk 'BEGIN{FS = "\t";}($1 == "都外"){print ",,"$1","$2; print ",,"$3","$4; next;}{print;}' | \
awk 'BEGIN{print "月,日,陽性患者数（日別）,陽性患者数（累計）";}{gsub("\t",","); print;}' > "陽性患者数_"$FileNameHash".csv"
echo "陽性患者数のCSV変換完了"

# 陽性患者の属性
echo "陽性患者の属性のCSV変換開始・・・"
# curlで取れんかった・・・w
cat $Cov19_Fname | \
awk '{gsub(/\s/,""); print;}' | \
awk '/^陽性患者数のグラフ$/,/^陽性患者数（区市町村別）$/' | \
awk '{gsub("><",">\n<"); print;}' | \
fgrep "<ahref=\"https" | \
sed -e 's/target.*//g' -e 's/"//g' -e 's/<ahref=//g' | \
awk '{print "curl --silent "$0;}' | \
sh | \
awk '{gsub(/\s/,""); print;}' | \
fgrep "<ahref=\"https" | \
fgrep ".csv" | \
sed -e 's/class.*//g' -e 's/"//g' -e 's/<ahref=//g' | \
awk '{print "curl --silent "$0;}' | \
sh | \
awk '{gsub("\r\n","\n"); print;}' > "陽性患者の属性_オープンデータ版_"$FileNameHash".csv"

echo "陽性患者の属性のCSV変換完了"

# 陽性患者数（区市町村別）
echo "陽性患者数（区市町村別）のCSV変換開始・・・"
cat $Cov19_Fname | \
awk '{gsub(/\s/,""); print;}' | \
awk '/^陽性患者数（区市町村別）$/,/^検査実施状況$/' | \
awk '{gsub("><",">\n<"); print;}' | \
awk '/^<th>.*?<\/th>$/{print;}/^<tdclass="text-start">.*?<\/td>$/{print;}/^<tdclass="text-end">.*?<\/td>$/{print;}' | \
awk '{if(NR % 4){ORS="\t";} else {ORS="\n";} print;}' | \
awk '{gsub("<th>",""); gsub("</th>",""); gsub(/<tdclass="text-start">/,""); gsub(/<tdclass="text-end">/,""); gsub("</td>",""); gsub(",",""); gsub("/","\t"); print;}' | \
awk 'BEGIN{FS = "\t";}($1 == "都外"){print ",,"$1","$2; print ",,"$3","$4; next;}{print;}' | \
awk 'BEGIN{print "地域,ふりがな,区市町村,陽性患者数";}{gsub("\t",","); print;}' > "陽性患者数（区市町村別）_"$FileNameHash".csv"
echo "陽性患者数（区市町村別）のCSV変換完了"

# 検査実施状況
echo "検査実施状況のCSV変換開始・・・"
cat $Cov19_Fname | \
awk '{gsub(/\s/,""); print;}' | \
awk '/^検査実施状況$/,/^検査実施人数$/' | \
awk '{gsub("><",">\n<"); print;}' | \
awk '/検査実施人数<br>/,/<divclass="DataView-Description">/' | \
fgrep -v -e 'span>' -e 'div>' -e 'li>' -e 'ul>' -e '<!' -e 'class' | \
fgrep "<strong>" | \
sed -e 's/,//g'| \
awk '{gsub("<strong>",""); gsub("</strong>",""); print;}' | \
awk '{if(NR % 4){ORS=",";} else {ORS="\n";} print;}' | \
awk 'BEGIN{print "検査実施人数（健康安全研究センターによる実施分）（累計）,検査実施件数（累計）合計,検査実施件数（累計）都内発生,検査実施件数（累計）その他（チャーター機・クルーズ船等）";}{print;}' > "検査実施状況_"$FileNameHash".csv"
echo "検査実施状況のCSV変換完了"

# 検査実施人数
echo "検査実施人数のCSV変換開始・・・"
cat $Cov19_Fname | \
awk '{gsub(/\s/,""); print;}' | \
awk '/^検査実施状況$/,/^新型コロナコールセンター相談件数$/' | \
awk '{gsub("><",">\n<"); print;}' | \
awk '/<span>検査実施人数\(累計\)<\/span>/,/<divclass="DataView-Description">/' | \
awk '/^<th>.*?<\/th>$/{print;}/^<tdclass="text-end">.*?<\/td>$/{print;}' | \
awk '{if(NR % 3){ORS="\t";} else {ORS="\n";} print;}' | \
awk '{gsub("<th>",""); gsub("</th>",""); gsub(/<tdclass="text-end">/,""); gsub("</td>",""); gsub(",",""); gsub("/","\t"); print;}' | \
awk 'BEGIN{print "月,日,検査実施人数（日別）,検査実施人数（累計）";}{gsub("\t",","); print;}' > "検査実施人数_"$FileNameHash".csv"
echo "検査実施人数のCSV変換完了"

# 検査実施件数
echo "検査実施件数のCSV変換開始・・・"
cat $Cov19_Fname | \
awk '{gsub(/\s/,""); print;}' | \
awk '/^検査実施件数のグラフ$/,/^新型コロナコールセンター相談件数$/' | \
awk '{gsub("><",">\n<"); print;}' | \
awk '/^<th>.*?<\/th>$/{print;}/^<tdclass="text-end">.*?<\/td>$/{print;}' | \
awk '{if(NR % 5){ORS="\t";} else {ORS="\n";} print;}' | \
awk '{gsub("<th>",""); gsub("</th>",""); gsub(/<tdclass="text-end">/,""); gsub("</td>",""); gsub(",",""); gsub("/","\t"); print;}' | \
awk 'BEGIN{print "月,日,健康安全研究センター実施分（日別）,健康安全研究センター実施分（累計）,医療機関等実施分（日別）,医療機関等実施分（累計）";}{gsub("\t",","); print;}' > "検査実施件数_"$FileNameHash".csv"
echo "検査実施件数のCSV変換完了"

# 新型コロナコールセンター相談件数
echo "新型コロナコールセンター相談件数のCSV変換開始・・・"
cat $Cov19_Fname | \
awk '{gsub(/\s/,""); print;}' | \
awk '/^新型コロナコールセンター相談件数$/,/^新型コロナ受診相談窓口相談件数$/' | \
awk '{gsub("><",">\n<"); print;}' | \
awk '/^<th>.*?<\/th>$/{print;}/^<tdclass="text-end">.*?<\/td>$/{print;}' | \
awk '{if(NR % 3){ORS="\t";} else {ORS="\n";} print;}' | \
awk '{gsub("<th>",""); gsub("</th>",""); gsub(/<tdclass="text-end">/,""); gsub("</td>",""); gsub(",",""); gsub("/","\t"); print;}' | \
awk 'BEGIN{print "月,日,新型コロナコールセンター相談件数 （日別）,新型コロナコールセンター相談件数（累計）";}{gsub("\t",","); print;}' > "新型コロナコールセンター相談件数_"$FileNameHash".csv"

# オープンデータ取得
cat $Cov19_Fname | \
cat Covid19_e2877ffe2432843569f947bbdba03dbf37facf9082f5682edc2ace1c5f1d61a.txt | \
awk '{gsub(/\s/,""); print;}' | \
awk '/^新型コロナコールセンター相談件数のグラフ$/,/^新型コロナ受診相談窓口相談件数$/' | \
awk '{gsub("><",">\n<"); print;}' | \
fgrep "<ahref=\"https" | \
sed -e 's/target.*//g' -e 's/"//g' -e 's/<ahref=//g' | \
awk '{print "curl --silent "$0;}' | \
sh | \
awk '{gsub(/\s/,""); print;}' | \
fgrep "<ahref=\"https" | \
fgrep ".csv" | \
sed -e 's/class.*//g' -e 's/"//g' -e 's/<ahref=//g' | \
awk '{print "curl --silent "$0;}' | \
sh | \
awk '{gsub("\r\n","\n"); print;}' > "新型コロナコールセンター相談件数_オープンデータ版_"$FileNameHash".csv"

echo "新型コロナコールセンター相談件数のCSV変換完了"

# 新型コロナ受診相談窓口相談件数
echo "新型コロナ受診相談窓口相談件数のCSV変換開始・・・"
cat $Cov19_Fname | \
awk '{gsub(/\s/,""); print;}' | \
awk '/^新型コロナ受診相談窓口相談件数$/,/^都営地下鉄の利用者数の推移$/' | \
awk '{gsub("><",">\n<"); print;}' | \
awk '/^<th>.*?<\/th>$/{print;}/^<tdclass="text-end">.*?<\/td>$/{print;}' | \
awk '{if(NR % 3){ORS="\t";} else {ORS="\n";} print;}' | \
awk '{gsub("<th>",""); gsub("</th>",""); gsub(/<tdclass="text-end">/,""); gsub("</td>",""); gsub(",",""); gsub("/","\t"); print;}' | \
awk 'BEGIN{print "月,日,新型コロナ受診相談窓口相談件数（日別）,新型コロナ受診相談窓口相談件数（累計）";}{gsub("\t",","); print;}' > "新型コロナ受診相談窓口相談件数_"$FileNameHash".csv"

# オープンデータ取得
cat $Cov19_Fname | \
awk '{gsub(/\s/,""); print;}' | \
awk '/^新型コロナ受診相談窓口相談件数のグラフ$/,/^都営地下鉄の利用者数の推移$/' | \
awk '{gsub("><",">\n<"); print;}' | \
fgrep "<ahref=\"https" | \
sed -e 's/target.*//g' -e 's/"//g' -e 's/<ahref=//g' | \
awk '{print "curl --silent "$0;}' | \
sh | \
awk '{gsub(/\s/,""); print;}' | \
fgrep "<ahref=\"https" | \
fgrep ".csv" | \
sed -e 's/class.*//g' -e 's/"//g' -e 's/<ahref=//g' | \
awk '{print "curl --silent "$0;}' | \
sh | \
awk '{gsub("\r\n","\n"); print;}' > "新型コロナ受診相談窓口相談件数_オープンデータ版_"$FileNameHash".csv"

echo "新型コロナ受診相談窓口相談件数のCSV変換完了"

# 都営地下鉄の利用者数の推移
echo "都営地下鉄の利用者数の推移のCSV変換開始・・・"
cat $Cov19_Fname | \
awk '{gsub(/\s/,""); print;}' | \
awk '/^都営地下鉄の利用者数の推移$/,/^都庁来庁者数の推移$/' | \
awk '{gsub("><",">\n<"); print;}' | \
awk '/^<th>.*?<\/th>$/{print;}/^<tdclass="text-end">.*?<\/td>$/{print;}' | \
awk '{if(NR % 4){ORS="\t";} else {ORS="\n";} print;}' | \
awk '{gsub("<th>",""); gsub("</th>",""); gsub(/<tdclass="text-end">/,""); gsub("</td>",""); gsub(",",""); gsub("~",","); gsub("/","\t"); print;}' | \
awk 'BEGIN{print "開始月,開始日,終了月,終了日,6時30分から7時30分の間の相対値,7時30分から9時30分の間の相対値,9時30分から10時30分の間の相対値";}{gsub("\t",","); print;}' > "都営地下鉄の利用者数の推移_"$FileNameHash".csv"

# 鉄道利用者数の推移（新宿、東京、渋谷、各駅エリア）[PDF] 取得
# PDFはtesseractでOCRしたほうがいい？
cat $Cov19_Fname | \
awk '{gsub(/\s/,""); print;}' | \
awk '/^都営地下鉄の利用者数の推移のグラフ/,/^鉄道利用者数の推移（新宿、東京、渋谷、各駅エリア）\[PDF\]$/' | \
awk '{gsub("><",">\n<"); print;}' | \
fgrep "<ahref=\"https" | \
sed -e 's/target.*//g' -e 's/"//g' -e 's/<ahref=//g' | \
awk '{print "curl --silent "$0;}' | \
sh > "鉄道利用者数の推移（新宿、東京、渋谷、各駅エリア）_オープンデータ版_"$FileNameHash".pdf"

# 主要駅の改札通過人数の推移（東京、新宿、渋谷、池袋ほか）[内閣官房HP]（ページ下部） 取得
# 内閣府のは、ダッシュボードを引き込んでいるので、トップページをみてもしょうがない、というか、jsで自動生成しているみたいだから、seleniumが要るねえ・・・。

echo "都営地下鉄の利用者数の推移のCSV変換完了"

# 都庁来庁者数の推移

echo "都庁来庁者数の推移のCSV変換開始・・・"
cat $Cov19_Fname | \
awk '{gsub(/\s/,""); print;}' | \
awk '/^都庁来庁者数の推移$/,/^当サイトではJavaScriptを使用しております。/' | \
awk '{gsub("><",">\n<"); print;}' | \
awk '/^<th>.*?<\/th>$/{print;}/^<tdclass="text-end">.*?<\/td>$/{print;}' | \
awk '{if(NR % 4){ORS="\t";} else {ORS="\n";} print;}' | \
awk '{gsub("<th>",""); gsub("</th>",""); gsub(/<tdclass="text-end">/,""); gsub("</td>",""); gsub(",",""); gsub("~",","); gsub("/","\t"); print;}' | \
awk 'BEGIN{print "開始月,開始日,終了月,終了日,第一庁舎計,第二庁舎計,議事堂計";}{gsub("\t",","); print;}' > "都庁来庁者数の推移_"$FileNameHash".csv"
echo "都庁来庁者数の推移のCSV変換完了"

echo "That's all, folks..."
exit 0

