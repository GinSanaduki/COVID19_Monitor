# 検査実施人数
```bash
curl --silent https://stopcovid19.metro.tokyo.lg.jp/ | \
awk '{gsub(/\s/,""); print;}' | \
awk '/^検査実施状況$/,/^新型コロナコールセンター相談件数$/' | \
awk '{gsub("><",">\n<"); print;}' | \
awk '/<span>検査実施人数\(累計\)<\/span>/,/<divclass="DataView-Description">/' | \
awk '/^<th>.*?<\/th>$/{print;}/^<tdclass="text-end">.*?<\/td>$/{print;}' | \
awk '{if(NR % 3){ORS="\t";} else {ORS="\n";} print;}' | \
awk '{gsub("<th>",""); gsub("</th>",""); gsub(/<tdclass="text-end">/,""); gsub("</td>",""); gsub(",",""); gsub("/","\t"); print;}' | \
awk 'BEGIN{print "月,日,検査実施人数（日別）,検査実施人数（累計）";}{gsub("\t",","); print;}' > 検査実施人数.csv
```

```
月,日,検査実施人数（日別）,検査実施人数（累計）
5,7,111,12990
5,6,65,12879
5,5,109,12814
5,4,219,12705
5,3,399,12486
5,2,200,12087
5,1,196,11887
4,30,437,11691
4,29,189,11254
4,28,84,11065
4,27,279,10981
4,26,314,10702
4,25,272,10388
4,24,289,10116
4,23,470,9827
4,22,233,9357
4,21,167,9124
4,20,276,8957
4,19,304,8681
4,18,337,8377
4,17,314,8040
4,16,482,7726
4,15,160,7244
4,14,91,7084
4,13,250,6993
4,12,57,6743
4,11,503,6686
4,10,362,6183
4,9,344,5821
4,8,366,5477
4,7,271,5111
4,6,356,4840
4,5,62,4484
4,4,65,4422
4,3,551,4357
4,2,469,3806
4,1,164,3337
3,31,145,3173
3,30,41,3028
3,29,331,2987
3,28,244,2656
3,27,143,2412
3,26,87,2269
3,25,95,2182
3,24,74,2087
3,23,56,2013
3,22,1,1957
3,21,44,1956
3,20,15,1912
3,19,49,1897
3,18,105,1848
3,17,71,1743
3,16,19,1672
3,15,0,1653
3,14,71,1653
3,13,58,1582
3,12,84,1524
3,11,119,1440
3,10,65,1321
3,9,23,1256
3,8,0,1233
3,7,94,1233
3,6,71,1139
3,5,79,1068
3,4,82,989
3,3,74,907
3,2,32,833
3,1,14,801
2,29,56,787
2,28,64,731
2,27,68,667
2,26,51,599
2,25,44,548
2,24,14,504
2,23,7,490
2,22,34,483
2,21,35,449
2,20,60,414
2,19,80,354
2,18,24,274
2,17,7,250
2,16,74,243
2,15,130,169
2,14,3,39
2,13,4,36
2,12,1,32
2,11,0,31
2,10,1,31
2,9,3,30
2,8,0,27
2,7,4,27
2,6,5,23
2,5,3,18
2,4,4,15
2,3,0,11
2,2,0,11
2,1,1,11
1,31,2,10
1,30,1,8
1,29,5,7
1,28,0,2
1,27,1,2
1,26,0,1
1,25,1,1
1,24,0,0

```

# 検査実施件数
```bash
curl --silent https://stopcovid19.metro.tokyo.lg.jp/ | \
awk '{gsub(/\s/,""); print;}' | \
awk '/^検査実施件数のグラフ$/,/^新型コロナコールセンター相談件数$/' | \
awk '{gsub("><",">\n<"); print;}' | \
awk '/^<th>.*?<\/th>$/{print;}/^<tdclass="text-end">.*?<\/td>$/{print;}' | \
awk '{if(NR % 5){ORS="\t";} else {ORS="\n";} print;}' | \
awk '{gsub("<th>",""); gsub("</th>",""); gsub(/<tdclass="text-end">/,""); gsub("</td>",""); gsub(",",""); gsub("/","\t"); print;}' | \
awk 'BEGIN{print "月,日,健康安全研究センター実施分（日別）,健康安全研究センター実施分（累計）,医療機関等実施分（日別）,医療機関等実施分（累計）";}{gsub("\t",","); print;}' > 検査実施件数.csv
```

```
月,日,健康安全研究センター実施分（日別）,健康安全研究センター実施分（累計）,医療機関等実施分（日別）,医療機関等実施分（累計）
5,7,212,17228,1503,25783
5,6,110,17016,399,24280
5,5,151,16906,383,23881
5,4,302,16755,679,23498
5,3,474,16453,194,22819
5,2,315,15979,605,22625
5,1,261,15664,1013,22020
4,30,530,15403,941,21007
4,29,314,14873,256,20066
4,28,134,14559,1062,19810
4,27,358,14425,1389,18748
4,26,400,14067,76,17359
4,25,384,13667,468,17283
4,24,416,13283,1319,16815
4,23,630,12867,1028,15496
4,22,354,12237,1093,14468
4,21,227,11883,969,13375
4,20,378,11656,1297,12406
4,19,373,11278,66,11109
4,18,489,10905,356,11043
4,17,447,10416,941,10687
4,16,604,9969,952,9746
4,15,277,9365,836,8794
4,14,177,9088,742,7958
4,13,354,8911,1042,7216
4,12,67,8557,50,6174
4,11,568,8490,240,6124
4,10,427,7922,673,5884
4,9,379,7495,559,5211
4,8,394,7116,607,4652
4,7,296,6722,638,4045
4,6,364,6426,717,3407
4,5,63,6062,45,2690
4,4,79,5999,151,2645
4,3,557,5920,349,2494
4,2,482,5363,348,2145
4,1,165,4881,326,1797
3,31,157,4716,206,1471
3,30,79,4559,220,1265
3,29,331,4480,4,1045
3,28,251,4149,50,1041
3,27,163,3898,141,991
3,26,101,3735,95,850
3,25,108,3634,83,755
3,24,89,3526,76,672
3,23,78,3437,99,596
3,22,1,3359,4,497
3,21,60,3358,24,493
3,20,17,3298,10,469
3,19,60,3281,75,459
3,18,118,3221,68,384
3,17,85,3103,53,316
3,16,33,3018,82,263
3,15,0,2985,0,181
3,14,87,2985,4,181
3,13,74,2898,35,177
3,12,100,2824,33,142
3,11,135,2724,34,109
3,10,93,2589,22,75
3,9,48,2496,41,53
3,8,0,2448,0,12
3,7,121,2448,2,12
3,6,151,2327,10,10
3,5,136,2176,0,0
3,4,119,2040,0,0
3,3,117,1921,0,0
3,2,87,1804,0,0
3,1,19,1717,0,0
2,29,79,1698,0,0
2,28,114,1619,0,0
2,27,191,1505,0,0
2,26,59,1314,0,0
2,25,44,1255,0,0
2,24,24,1211,0,0
2,23,29,1187,0,0
2,22,143,1158,0,0
2,21,99,1015,0,0
2,20,136,916,0,0
2,19,96,780,0,0
2,18,44,684,0,0
2,17,30,640,0,0
2,16,78,610,0,0
2,15,156,532,0,0
2,14,11,376,0,0
2,13,20,365,0,0
2,12,13,345,0,0
2,11,0,332,0,0
2,10,3,332,0,0
2,9,4,329,0,0
2,8,0,325,0,0
2,7,10,325,0,0
2,6,54,315,0,0
2,5,33,261,0,0
2,4,5,228,0,0
2,3,0,223,0,0
2,2,0,223,0,0
2,1,1,223,0,0
1,31,212,222,0,0
1,30,1,10,0,0
1,29,5,9,0,0
1,28,0,4,0,0
1,27,1,4,0,0
1,26,0,3,0,0
1,25,3,3,0,0
1,24,0,0,0,0

```
