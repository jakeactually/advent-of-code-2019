my @arr = open("input.txt").lines>>.split("", :skip-empty)>>.Array;
my @copy = @arr>>.Array;
my %set;

loop {
    for 0..4 -> $y {
        for 0..4 -> $x {
            my $count = 0;

            $count++ if $y > 0 && @arr[$y - 1][$x] eq "#";
            $count++ if $y < 4 && @arr[$y + 1][$x] eq "#";
            $count++ if $x > 0 && @arr[$y][$x - 1] eq "#";
            $count++ if $x < 4 && @arr[$y][$x + 1] eq "#";

            @copy[$y][$x] = "." if @arr[$y][$x] eq "#" && $count != 1;
            @copy[$y][$x] = "#" if @arr[$y][$x] eq "." && $count ~~ 1..2;
        }
    }
    
    say @copy;
    my $hash = @copy>>.join.join;
    
    if %set{$hash} {
        say @copy>>.list.flat.pairs
            .map({ if .value eq "#" { 2 ** .key } else { 0 } }).sum;
        last;
    }

    %set{$hash} = True;
    @arr = @copy>>.Array;
}
