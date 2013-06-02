#!/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';
use Hack4LA::Schema;

use XML::Simple;
use Getopt::Long;
use IO::File;
use LWP;

my $schema = Hack4LA::Schema->connect('dbi:mysql:database=hack4la','max','cabral',{ AutoCommit => 1 },);
warn ref $schema;

warn $schema->resultset('Job')->search()->count();

my $file_loc;
GetOptions(
  'file=s' => \$file_loc,
);

if (my $fh = IO::File->new($file_loc)){
  warn "Opened";
  my $ref = XMLin($fh);
  warn keys %$ref;
  my $jobs = $ref->{job};
  warn ref $jobs;
  warn scalar @{$jobs};
  upload_records($jobs);
}

sub upload_records {
  my ($jobs) = shift;
  
  foreach my $job (@{$jobs}){
    $schema->resultset('Job')->create($job);
  }  
};

