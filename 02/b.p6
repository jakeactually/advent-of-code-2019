my @input = slurp('input.txt').split(',');

for 0..100 -> $i {
    for 0..100 -> $j {
        my @arr = @input.clone;

        @arr[1] = $i;
        @arr[2] = $j;

        for 0..@arr.elems / 4  {
            my ($a, $b, $c, $d) = @arr[$_*4..$_*4+3];
            
            given $a {
                @arr[$d] = @arr[$b] + @arr[$c] when 1;
                @arr[$d] = @arr[$b] * @arr[$c] when 2;
                last when $a > 2;
            }
        }

        say @arr[0];

        if @arr[0] == 19690720 {
            say (100 * $i + $j);
            exit;
        }
    }
}
