libname ass '/home/u41986747/ASSIGNMENT';
FILENAME REFFILE '/home/u41986747/ASSIGNMENT/Cleaned3.xlsx';

PROC IMPORT DATAFILE=REFFILE DBMS=XLSX OUT=WORK.listings;
	GETNAMES=YES;
RUN;

data listings (keep=is_location_exact review_scores_location neighbourhood_group);
	set listings;
run;

*convert char to num;
data listings;
	set listings (rename=(review_scores_location=convert_rsl));
	review_scores_location=input(convert_rsl, 3.);
	drop convert_rsl;
run;

*data exploration;
proc univariate data=listings;
var review_scores_location;
run;

*generate bar chart;
proc sgplot data=listings;
	title "Review Scores Based on Location Credibility";
	vbar is_location_exact / response=review_scores_location stat=mean 
		datalabel stat=mean fillattrs=(color=lightblue);
	yaxis label="Review Score";
	xaxis label="Location Credibility";
run;

*generate stacked bar chart;
proc sgplot data=listings;
  title "Review Scores and Location Credibility According to Boroughs";
  vbar neighbourhood_group / response=review_scores_location group=is_location_exact stat=mean;
  xaxis display=(nolabel);
  yaxis grid label="Review Score";
  run;