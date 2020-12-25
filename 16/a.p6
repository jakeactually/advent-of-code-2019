my @input := slurp("input.txt").split("", :skip-empty)>>.Int.Array;
my @output := [0,0,0,0,0,0,0,0];

my @pattern = (0, 1, 0, -1);
my $len = @input.elems;

for 1..100 {
    for 0..^$len -> $i {
        @output[$i] = @input.kv.map(-> $j, $n { $n * @pattern[($j + 1) div ($i + 1) % 4] }).sum.abs % 10;
    }

    @input = @output;
}

say @output;
