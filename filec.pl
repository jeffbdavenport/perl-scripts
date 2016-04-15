#!/usr/bin/perl
use 5.10.1;
use warnings;
use strict;
use Time::HiRes qw(usleep);
my $Arg = $ARGV[0];
my $i = 0; # +1 for the current dir,
my $d = 0;
my $total = 0;
my $curpath = ".";
my $curDir = "~";

if ( $Arg && $Arg =~m/^(.\/|\/|~\/|.$|~$)/ ){
  $curpath = $ARGV[0];
}
count($curpath);

sub count {
	  my $path = shift;
	  if(opendir my $DIR, "$path"){
	  	
		my $current_count = 1;
	  	print "\rCurrent count: $i Dir: $path                                \r";
		foreach(readdir $DIR) {
		  	if(m/^\.\.?$/){
		  		next;
		  	}
		  	$current_count++;
		  	$i++;
			if( -d "$path/$_" ){
				$total++;
				usleep(2000);
				count("$path/$_");
			}
	  	}
	  	if($current_count > 500){
		  	print "\n$current_count in $path";
	  	}
	  	$current_count = 0;
	  	closedir $DIR;
  	}
}

sub count2{
  my $dir;
  if( "$curDir" =~ /^[0-9]/ ){
    say "$d/$curDir";
  } else {
     say "$d$curDir";
  }
  my $path="$curpath";
  opendir($dir, "$curpath");
  foreach (grep { !/^\.\.?$/ && -f "$path/$_" || -l "$path/$_" } readdir $dir) {
    if( "$_" =~ /^[0-9]/ ){
      say "/$_";
    } else {
      say "$_";
    }
  }
  opendir($dir, "$curpath");
  foreach (grep { !/^\.\.?$/ && -d "$path/$_" && ! -l "$path/$_" } readdir $dir) {
    $curpath = "$path/$_";
    $curDir = "$_";
    $d++;
    $total++;
    count2();
    $d--;
  }
  closedir($dir);
}


say "You have $i files and $total of those are directories."
