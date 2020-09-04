my @arr = slurp('input.txt').split(',');

@arr[1] = 12;
@arr[2] = 2;

for 0..@arr.elems / 4  {
    my ($a, $b, $c, $d) = @arr[$_*4..$_*4+3];
    
    given $a {
        @arr[$d] = @arr[$b] + @arr[$c] when 1;
        @arr[$d] = @arr[$b] * @arr[$c] when 2;
        last when $a > 2;
    }
}

say @arr[0];
