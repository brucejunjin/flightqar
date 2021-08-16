PROC IMPORT 
DATAFILE="\\Client\D$\land-\spread_z.xlsx"
OUT=landing_z 
DBMS=XLSX;
 SHEET="Sheet1";
 GETNAMES=YES; 
 DATAROW=2;
RUN;


proc quantreg data=landing_z algorithm=interior ci=resampling;
  model _3094 = _1008 _1015 _1046 _1064 _1066 _1066*_1066 _1103 _1115 _3040 _3078 _3131 _3200 _3251 _3268 _3385/ quantile = 0.10 to 0.90 by 0.1 seed=1268 plot=quantplot;
  id flight_id;
  test _1008 _1015 _1046 _1064 _1066 _1066*_1066 _1103 _1115 _3040 _3078 _3131 _3200 _3251 _3268 _3385/ wald;
run;

PROC IMPORT 
DATAFILE="\\Client\D$\land-\spread.xlsx"
OUT=landing
DBMS=XLSX;
 SHEET="Sheet1";
 GETNAMES=YES; 
 DATAROW=2;
RUN;


proc quantreg data=landing algorithm=interior ci=resampling;
  model _3094 =_1066 _1066*_1066 / quantile = 0.10 to 0.90 by 0.1 seed=1268 plot=quantplot;
  id flight_id;
  test _1066 _1066*_1066 / wald;
run;



proc quantreg data=landing algorithm=interior ci=resampling;
  model _3094 = _1008 _1015 _1046 _1066 _1066*_1066 _1103 _1115 _3040 _3251 _3385/ quantile = 0.10 to 0.90 by 0.1 seed=1268 plot=quantplot;
  id flight_id;
  test _1008 _1015 _1046 _1066 _1066*_1066 _1103 _1115 _3040 _3251 _3385 / wald;
run;


