# Script to set environmental variables in Control-M for previous month
# November 2010 Robert Stinnett
#
# Changes
# 1-11-2011:  Robert Stinnett - Changed year logic; was miscalculating year when previous month was December.
# 4-12-2019:  Robert Stinnett - Added two month back logic.
#



sub getNewMonth
{

@monthstrings = ("JANUARY","FEBRUARY","MARCH","APRIL","MAY","JUNE","JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER");


my ($sec,$min,$hr,$mday,$mon,$year,$wday,$yday,$isdst) = localtime time;
my $year_previous = 0;
my $current_month_string_abbreviated  = ucfirst( lc(substr($monthstrings[$mon],0,3)));


if ($mon == 0) # Jan
{
  $mon = 11; #Set to December
  $prev_2_mon = 10; #NOvember
  $year_previous = $year + 1900 - 1;
  $year_2mon_previous = $year_previous
}
elsif ($mon == 1) #Feb
{
  $mon = 0; #Set to January
  $prev_2_mon = 11; #December
  $year_previous = $year + 1900;
  $year_2mon_previous = $year + 1900 - 1;
}
else
{

  $mon--;  #Previous month
  $year_previous = $year + 1900;
  $prev_2_mon = $mon - 1;
  $year_2mon_previous = $year_previous;

}

my $month_numerical = sprintf("%02d", ($mon + 1));
my $month_abbreviated =ucfirst( lc(substr($monthstrings[$mon],0,3)));
my $month_string = $monthstrings[$mon];
my $two_month_string = $monthstrings[$prev_2_mon];



print "Previous Month Full - $month_string\n\n";
print "Previous 2 Months Full - $two_month_string\n\n";
print "Previous Month Abbreviated - $month_abbreviated\n\n";
print "Previous Month Numerical - $month_numerical\n\n";
print "Previous Month Year - $year_previous\n\n";
print "Previous 2 Months Year - $year_2mon_previous \n\n";


# Execute Control-M Variable calls
system("ctmvar -action set -var %%\\\\SCURRENTMONS -varexpr $current_month_string_abbreviated");
system("ctmvar -action set -var %%\\\\PREVMON -varexpr $month_numerical");
system("ctmvar -action set -var %%\\\\PREVMONS -varexpr $month_string");
system("ctmvar -action set -var %%\\\\SPREVMONS -varexpr $month_abbreviated");
system("ctmvar -action set -var %%\\\\PREVMONYR -varexpr $year_previous");
system("ctmvar -action set -var %%\\\\PREV2MONS -varexpr $two_month_string");
system("ctmvar -action set -var %%\\\\PREV2MONYR -varexpr $year_2mon_previous");


}


getNewMonth();
