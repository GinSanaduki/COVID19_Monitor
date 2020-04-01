<p align="center">
    <a href="https://opensource.org/licenses/BSD-3-Clause"><img src="https://img.shields.io/badge/license-bsd-orange.svg" alt="Licenses"></a>
</p>

# COVID19_Monitor
Output Console Country/Other, Mortality, Future Deaths Every 5 seconds. 
data source : Coronavirus Update (Live) from COVID-19 Virus Outbreak Worldometer
https://www.worldometers.info/coronavirus/  

Works on Android(on Termux, UserLAnd, and other...) / Windows(WSL, Windows Subsystem for Linux) / UNIX(Unix-like, as *nix. Example Linux, AIX, HP-UX...) / Mac OS X.

The curl commands need to be installed.

Mortality : ([total recovered]/[total case])
Future Deaths : ([total deaths]/[total case] * ([serious, critical]+[active case]))

* $1 : Country,Other
* $2 : Total Cases
* $3 : New Cases
* $4 : Total Deaths
* $5 : New Deaths
* $6 : Total Recovered
* $7 : Active Cases
* $8 : Serious, Critical
* $9 : Tot Cases/1M pop
* $10 : Deaths/1M pop
* $11 : Reported 1st case

