#!/usr/bin/env perl

use strict;
use warnings;

use lib '../lib/';
use Hack4LA::Schema;

use XML::Simple;
use Getopt::Long;
use IO::File;
use LWP;

my $schema = Hack4LA::Schema->clone();

warn ref $schema;

$schema->connect('dbi:mysql:database=hack4la','max','cabral',{ AutoCommit => 1 },);

warn $schema->resultset('Job')->search()->count();

die;

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
}

sub upload_records {
  
};

