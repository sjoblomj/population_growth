#!/bin/bash

in2csv -n WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx | xargs -I % sh -c "in2csv --sheet '%' WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx > WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1_$(echo \'%\').csv"

echo "year,type,population,pop_growth_rate" > demographics.csv

cat f-population-world-long-trend-since-8000bc.csv | awk -F ',' '
  BEGIN {
    prevstr = "";
    prevpop = 1;
    prevratio = 1;
  }
  {
    if (int($1) > 1800 && int($1) <= 1950) {
      prevratio = (($2 - prevpop) / prevpop) * 100;
      printf("%s,%1.3f\n", prevstr, prevratio);
    }
    if (int($1) == 1951) { # Make transition to next dataset smoother
      printf("%s,%1.3f\n", prevstr, prevratio);
    }
    if (int($1) >= 1800) {
      prevpop = int($2);
      if (int($1) >= 1950) {
        prevpop -= 20000000; # Make transition to next dataset smoother
      }
      prevstr = $1 ",gapminder," prevpop;
    }
  }' >> demographics.csv

cat WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1*.csv | grep -P "[0-9]+,(Estimates|Medium),WORLD" | awk -F ',' '
  BEGIN {
    prevstr = "";
    prevpop = 1;
  }
  {
    if($11 > 1950) {
      printf("%i,%s,%i,%1.3f\n", $11, $2 == "Estimates" ? "un_past" : "un_prediction", $12 * 1000, (($12 * 1000 - prevpop) / prevpop)*100);
    }
    prevpop = $12 * 1000;
  }' >> demographics.csv
