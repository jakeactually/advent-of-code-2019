my @arr = open("input.txt").lines>>.split("", :skip-empty)>>.Array;
my $min = -1;
my $max = 1;

my %graph;

for 0..4 -> $y {
    for 0..4 -> $x {
        %graph{"$x $y 0"} = @arr[$y][$x];
    }
}

my %copy = %graph.clone;

sub at($x, $y, $depth) {
    %graph{"$x $y $depth"} || "."
}

for 1..200 {
    say $_;
    
    for $min..$max -> $depth {
        for 0..4 -> $y {
            for 0..4 -> $x {
                my $count = 0;

                if $x == 2 && $y == 2 {
                    next;
                }

                if $y > 0 {
                    $count++ if at($x, $y - 1, $depth) eq "#";
                } else {
                    $count++ if at(2, 1, $depth - 1) eq "#";
                }

                if $y < 4 {
                    $count++ if at($x, $y + 1, $depth) eq "#";
                } else {
                    $count++ if at(2, 3, $depth - 1) eq "#";
                }

                if $x > 0 {
                    $count++ if at($x - 1, $y, $depth) eq "#";
                } else {
                    $count++ if at(1, 2, $depth - 1) eq "#";
                }

                if $x < 4 {
                    $count++ if at($x + 1, $y, $depth) eq "#";
                } else {
                    $count++ if at(3, 2, $depth - 1) eq "#";
                }

                if $x == 2 && $y == 1 {
                    for 0..4 {
                        $count++ if at($_, 0, $depth + 1) eq "#";
                    }
                }

                if $x == 3 && $y == 2 {
                    for 0..4 {
                        $count++ if at(4, $_, $depth + 1) eq "#";
                    }
                }

                if $x == 2 && $y == 3 {
                    for 0..4 {
                        $count++ if at($_, 4, $depth + 1) eq "#";
                    }
                }

                if $x == 1 && $y == 2 {
                    for 0..4 {
                        $count++ if at(0, $_, $depth + 1) eq "#";
                    }
                }

                %copy{"$x $y $depth"} = "." if at($x, $y, $depth) eq "#" && $count != 1;
                %copy{"$x $y $depth"} = "#" if at($x, $y, $depth) eq "." && $count ~~ 1..2;
            }
        }
    }

    $min--;
    $max++;

    %graph = %copy.clone;
}

say %copy.values.grep("#").elems;
