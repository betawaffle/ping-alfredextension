#!/usr/bin/env perl -w

use strict;
use warnings;

use utf8;

my $target = '?';
my $query  = '?';
my $result = '';

while (<>) {
  chomp;
  next if m{^--- ($query) ping statistics ---$};
  next if m{^$};

  if (m{^(\d+) bytes from ($target): icmp_seq=(\d+) ttl=(\d+) time=((\d+)\.\d+) ms$}) {
    my $padding = ' ' x (3 - length $6);
    system "/usr/local/bin/growlnotify -wn ping --image ./icon.png -m 'Pong: $5 ms' -t 'Ping $target' &";
    # print "t = $padding$5 ms\n";
    next;
  }

  if (m{^PING (.+) \((\d+\.\d+\.\d+\.\d+)\): (\d+) data bytes$}) {
    $query  = $1;
    $target = $2;
    next;
  }

  if (m{^(\d+) packets transmitted, (\d+) packets received, (\d+\.\d+%) packet loss$}) {
    $result .= "$3 loss ($2/$1)\n";
    # print "$3 loss ($2/$1)\n";
    next;
  }

  if (m{^round-trip min/avg/max/stddev = (\d+\.\d+)/(\d+\.\d+)/(\d+\.\d+)/(\d+\.\d+) ms$}) {
    $result .= "μ = $2 ms\nσ = $4 ms\n$1 ms ≤ t ≤ $3 ms\n";
    # print "μ = $2, σ = $4\n$1 ≤ t ≤ $3\n";
    # print "Avg: $2, StdDev: $4\nMin: $1, Max: $3\n";
    next;
  }

  if (m{^Request timeout for icmp_seq (\d+)$}) {
    system "/usr/local/bin/growlnotify -wn ping --image ./icon.png -m 'Timeout' -t 'Ping $target' &";
    next;
  }

  print;
  print "\n";
}

sleep 1;
system "/usr/local/bin/growlnotify -swn ping --image ./icon.png -m '$result' -t 'Ping $target' &";
