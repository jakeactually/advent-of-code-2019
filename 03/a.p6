my (@a, @b) := slurp('input.txt').lines.map: *.split(',');

my @arr = [0 xx 10000] xx 10000;

my ($x, $y) = (5000, 5000);

for @a {
    my $walk = $_ ~~ /(<[RLUD]>)(\d+)/;

    for 1..$walk[1] {
        given $walk[0] {
            $x++ when 'R';
            $x-- when 'L';
            $y-- when 'U';
            $y++ when 'D';
        }

        @arr[$y][$x] = 1;
    }
}

($x, $y) = (5000, 5000);

for @b {
    my $walk = $_ ~~ /(<[RLUD]>)(\d+)/;

    for 1..$walk[1] {
        given $walk[0] {
            $x++ when 'R';
            $x-- when 'L';
            $y-- when 'U';
            $y++ when 'D';
        }

        if @arr[$y][$x] == 1 {
            say (abs($x - 5000) + abs($y - 5000));
        }

        @arr[$y][$x] = 2;
    }
}
