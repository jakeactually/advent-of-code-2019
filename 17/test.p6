my @arr = open("map.txt").lines>>.split("", :skip-empty)>>.Array;
my @path = "L,9,R,7,L,5,R,5,L,7,L,7,R,7,L,9,R,7,L,5,R,5,R,7,L,5,L,9,L,9,L,9,R,7,L,5,R,5,L,7,L,7,R,7,R,7,L,5,L,9,L,9,L,7,L,7,R,7,R,7,L,5,L,9,L,9,L,7,L,7,R,7".split(",");

my ($x, $y) = (52, 26);
my $dir = 0;

for @path -> $turn, $steps {
    $dir = ($dir + 1) % 4 if $turn eq "R";
    $dir = ($dir + 3) % 4 if $turn eq "L";

    for 0..$steps {
        given $dir {
            when 0 { $y-- }
            when 1 { $x++ }
            when 2 { $y++ }
            when 3 { $x-- }
        }

        @arr[$y][$x] = "+";
    }
}

spurt "test.txt", @arr>>.join.join("\n");
