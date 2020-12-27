my @arr = open("map.txt").lines>>.split("", :skip-empty)>>.Array;

my $sum = 0;

for 0..^@arr.elems -> $y {
    for 0..^@arr[0].elems -> $x {
        my $intersect =
            $y > 0 &&
            $x > 0 &&
            (@arr[$y][$x] || "") eq "#" &&
            (@arr[$y - 1][$x] || "") eq "#" &&
            (@arr[$y + 1][$x] || "") eq "#" &&
            (@arr[$y][$x - 1] || "") eq "#" &&
            (@arr[$y][$x + 1] || "") eq "#";

        if $intersect {
            say ($x, $y);
            $sum += $x * $y;
        }
    }
}

say $sum;
