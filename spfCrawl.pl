#!/usr/bin/perl
use strict;
use warnings;


my $domain;

if(scalar @ARGV >= 1){
  $domain = $ARGV[0];
}else{
  print "Usage : spfCrawl.pl <domain-name>\n";
  exit;
}

my $digResults = `dig +short -t txt $domain | grep spf`;
chomp $digResults;

if($digResults eq ''){
  $digResults = `dig +short -t spf $domain | grep spf`;
  chomp $digResults;
}

if($digResults eq ''){
  print "No SPF records for $domain\n";
  exit;
}

while($digResults =~ s/([^ \"]+)//){
  print "$1\n";
  if($1 =~ m/include:([^ ]+)/){
    my @nextLevel = `./spfCrawl.pl $1`;
    foreach my $line ( @nextLevel) {
      chomp $line;
      print "|.. $line\n";
    }
  }
}
