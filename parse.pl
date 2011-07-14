#!/usr/bin/env perl -w

use strict;
use warnings;

use utf8;

my $target = '?';
my $query  = '?';

while (<>) {
  chomp;
  next if m{^--- ($query) ping statistics ---$};
  next if m{^$};

  if (m{^(\d+) bytes from ($target): icmp_seq=(\d+) ttl=(\d+) time=((\d+)\.\d+) ms$}) {
    my $padding = ' ' x (3 - length $6);
    # Uncomment this if you want it to show each ping time in the final message.
    # print "t = $padding$5 ms\n";
    next;
  }

  if (m{^PING (.+) \((\d+\.\d+\.\d+\.\d+)\): (\d+) data bytes$}) {
    $query  = $1;
    $target = $2;
    next;
  }

  if (m{^(\d+) packets transmitted, (\d+) packets received, (\d+\.\d+%) packet loss$}) {
    print "$3 loss ($2/$1)\n";
    next;
  }

  if (m{^round-trip min/avg/max/stddev = (\d+\.\d+)/(\d+\.\d+)/(\d+\.\d+)/(\d+\.\d+) ms$}) {
    print "μ = $2\nσ = $4\n$1 ≤ t ≤ $3\n";
    next;
  }

  if (m{^Request timeout for icmp_seq (\d+)$}) {
    print STDERR "Timeout of Ping #$1\n";
    next;
  }
}
