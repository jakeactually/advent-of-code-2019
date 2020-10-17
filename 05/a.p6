my @arr = slurp('input.txt').split(',');
my $ip = 0;

loop {
    my $modes = @arr[$ip];
    my ($mc, $mb, $ma, $op1, $op2) = sprintf('%05d', $modes).split('', :skip-empty);
    my $op = $op1 ~ $op2;

    my $size = (if $op == 1 || $op == 2 { 4 } else { 2 });
    my ($m, $a, $b, $c) = @arr[$ip..^$ip + $size];
    
    $b ||= 0; # dummy
    
    my $ta = (if $ma == 0 { @arr[$a] } else { $a });
    my $tb = (if $mb == 0 { @arr[$b] } else { $b });

    given $op {
        @arr[$c] = $ta + $tb when 1;
        @arr[$c] = $ta * $tb when 2;
        @arr[$a] = prompt("Enter input: ") when 3;
        say $ta when 4;
        last when 99;
    }

    $ip += $size;
}
