#!/usr/bin/perl
# Flowmapper: A microblogging geotagger.
# Copyright (c) 2011 Gianluca Ciccarelli.
#
# This file is part of Flowmapper.
#
# Flowmapper is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Flowmapper is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Flowmapper.  If not, see <http://www.gnu.org/licenses/>.

# Prototype!
package GeoTagger;

use strict;
use warnings;
use Geo::GeoNames;

my $geo = new Geo::GeoNames();

# Return a geotag for the given tweet (this is only a prototype).
sub parser ($) {
  my $tag = "";
  my $line = shift;

  my @tokens = split(/ /, $line);

  # Take the first hashmark and use it to query the GeoNames API
  for my $token (@tokens) {
    if ($token =~ /#(?<location>\w+)/) {
      $tag = $+{location};
      last;
    }
  }

  # TODO Check whether this is a location at all -- use the text parser
  # here.

  if ($tag ne "") {
    my $result = $geo->search(q => "$tag", maxRows => 20);

    # Print the first (more accurate?) result:
    if ($result && $result->[0]->{name}) {
        print $result->[0]->{name} . " => long: " . $result->[0]->{lng} . 
          ", lat: " . $result->[0]->{lat} . "\n";
    } else {
      print "Location not found\n";
    }
  }
  return $tag;
}

# Input: the tweets.
open(TWEET_STREAM, "geo_tweets.txt") or die "Error: $!";
while (<TWEET_STREAM>) {
  parser($_);
}
close TWEET_STREAM;
