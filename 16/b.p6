my @input = flat(slurp("input.txt").split("", :skip-empty)>>.Int xx 1000);

@input = @input[*-529193..*].reverse;

for 1..100 {
    @input = @input.produce((* + *) % 10);
    say @input[0..7];
}

say @input.reverse[0..7];
