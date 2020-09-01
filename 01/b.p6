say open("input.txt").lines.map(&fuel).sum;

sub fuel($n) {
    my $next = floor($n / 3) - 2;

    if $next < 0 {
        0
    } else {
        $next + fuel($next)
    }
}
