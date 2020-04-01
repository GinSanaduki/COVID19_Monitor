#!/bin/sh
# COVID19_Monitor.sh
# sh COVID19_Monitor.sh

while :
do
	clear
	Tmpfile_01=`od -A n -t u4 -N 4 /dev/urandom | sed 's/[^0-9]//g'`
	Tmpfile_01=$Tmpfile_01".csv";
	curl -s https://www.worldometers.info/coronavirus/ | \
	awk '/<div class="row">/,/<style>/{print;}' | \
	awk '/<tr style="">/,/<\/tr>/{print;}' | \
	awk '{printf $0}' | \
	awk '{gsub("</tr>","</tr>\n"); print;}' | \
	awk '{gsub("</td></tr>",""); print;}' | \
	awk '{gsub("<tr style=\"\">",""); print;}' | \
	awk '{gsub(",",""); print;}' | \
	awk '{gsub("><",">\n<"); print;}' | \
	awk '{gsub("</td>","\n</td>\n"); print;}' | \
	awk '/./{print;}' | \
	fgrep -v "</td>" | \
	awk 'BEGIN{FS = ">";}{gsub("\\s","",$1); print $1","$2;}' | \
	sed -e 's/<\/a//g' | \
	awk 'BEGIN{FS = ",";}{Col2_LastChar = substr($2,length($2),1); if(Col2_LastChar == " "){$2 = substr($2,1,length($2) - 1)",";} else {$2 = $2",";} print $1","$2;}' | \
	awk 'BEGIN{FS = ",";}{mat = match($1,/text-align.left/); if($2 == "" && mat > 0){next;} print;}' | \
	awk 'BEGIN{FS = ",";}{if($2 == ""){$2 = "<NO DATA>";} print $1","$2;}' | \
	cut -f 2 -d ',' | \
	awk 'BEGIN{FS = ",";}{mat = match($0,/Jan [0-3]|Feb [0-3]|Mar [0-3]|Apr [0-3]|May [0-3]|June [0-3]|July [0-3]|Aug [0-3]|Sept [0-3]|Oct [0-3]|Nov [0-3]|Dec [0-3]/); if(mat > 0){print $0"<LF>";} else {print $0",";}}' | \
	awk '{printf $0}' | \
	awk '{gsub("<LF>","\n"); print;}' | \
	awk 'BEGIN{FS = ",";}{if($1 != "<NO DATA>"){print; next;}for(i = 2; i <= NF; i++){if(i == NF){print Tex $i; next;}Tex = Tex $i",";}}' > $Tmpfile_01
	
	Tmpfile_02=`od -A n -t u4 -N 4 /dev/urandom | sed 's/[^0-9]//g'`
	Tmpfile_02=$Tmpfile_02".csv";
	Tmpfile_03=`od -A n -t u4 -N 4 /dev/urandom | sed 's/[^0-9]//g'`
	Tmpfile_03=$Tmpfile_03".csv";
	Tmpfile_04=`od -A n -t u4 -N 4 /dev/urandom | sed 's/[^0-9]//g'`
	Tmpfile_04=$Tmpfile_04".csv";
	cp $Tmpfile_01 $Tmpfile_02
	rm -f $Tmpfile_01 > /dev/null 2>&1
	while :
	do
		: > $Tmpfile_03
		: > $Tmpfile_04
		awk 'BEGIN{Bit = 0;}{Tex = "";while(1){split($0,Arrays,",");mat = match(Arrays[11],/Jan [0-3]|Feb [0-3]|Mar [0-3]|Apr [0-3]|May [0-3]|June [0-3]|July [0-3]|Aug [0-3]|Sept [0-3]|Oct [0-3]|Nov [0-3]|Dec [0-3]|DATA/);if(mat == 0){Bit++;if(Arrays[11] != "<NO DATA>"){Arrays[11] = "<NO DATA>\n"Arrays[11];}Tex = "";for(i in Arrays){Tex = Tex Arrays[i]",";}print Tex;} else {if(substr($0,length($0),1) == ","){print substr($0,1,length($0) - 1);} else {print;}}delete Arrays;next;}}END{if(Bit == 0){exit 0;} else {exit 1;}}' $Tmpfile_02 > $Tmpfile_03;
		RetCode=$?
		test $RetCode -eq 0 && break
		awk 'BEGIN{FS = ",";}($1 != ""){if($1 != "<NO DATA>"){print;}}' $Tmpfile_03 > $Tmpfile_04
		cp $Tmpfile_04 $Tmpfile_02
		: > $Tmpfile_03
		: > $Tmpfile_04
	done
	rm -f $Tmpfile_02 > /dev/null 2>&1
	rm -f $Tmpfile_04 > /dev/null 2>&1
	awk 'BEGIN{FS = ",";}{print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11}' $Tmpfile_03 | \
	sort -t ',' -k 1,1 | \
	uniq | \
	awk 'BEGIN{FS = ","; Col_01="";}(NR == 1){Col_01 = $1; print; next;}{if(Col_01 == $1){next;} Col_01 = $1; print; next;}' | \
	# $1 : Country,Other
	# $2 : Total Cases
	# $3 : New Cases
	# $4 : Total Deaths
	# $5 : New Deaths
	# $6 : Total Recovered
	# $7 : Active Cases
	# $8 : Serious, Critical
	# $9 : Tot Cases/1M pop
	# $10 : Deaths/1M pop
	# $11 : Reported 1st case
	awk 'BEGIN{FS = ",";}{print $1","$2","$6","$8","$4","$7}' | \
	awk 'BEGIN{FS = ",";}{$2 = $2 + 0; $3 = $3 + 0; $4 = $4 + 0; $5 = $5 + 0; $6 = $6 + 0; print $1","$2","$3","$4","$5","$6;}' | \
	# Country/Other, Mortality([total recovered]/[total case]), Future Deaths([total deaths]/[total case] * ([serious, critical]+[active case]))
	awk 'BEGIN{FS = ",";}{if($2 > 0){Mortality = $5 / $2 * 100;} else {Mortality = 0;} Present = $4 + $6; FutureDeaths = Mortality / 100 * Present; print $1","Mortality","FutureDeaths}'
	rm -f $Tmpfile_03 > /dev/null 2>&1
	sleep 5
done

