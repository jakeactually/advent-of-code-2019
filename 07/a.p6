my @program = slurp('input.txt').split(',');

my $max = 0;

for (0, 1, 2, 3, 4).permutations {
    my $output = 0;

    for $_ {
        my @arr = @program.clone;
        my $ip = 0;
        my @input = [$_, $output];

        loop {
            my $modes = @arr[$ip];
            my ($mc, $mb, $ma, $op1, $op2) = sprintf('%05d', $modes).split('', :skip-empty);
            my $op = $op1 ~ $op2;

            my $size = (given $op {
                when $_ == 99 { 1 }
                when $_ == (3, 4).any { 2 }
                when $_ == (5, 6).any { 3 }
                when $_ == (1, 2, 7, 8).any { 4 }
            });

            my ($m, $a, $b, $c) = @arr[$ip..^$ip + $size];

            # dummies
            $a ||= 0;
            $b ||= 0;
            
            my $ta = (if $ma == 0 { @arr[$a] } else { $a });
            my $tb = (if $mb == 0 { @arr[$b] } else { $b });

            my $pip = $ip;

            given $op {
                @arr[$c] = $ta + $tb when 1;
                @arr[$c] = $ta * $tb when 2;
                @arr[$a] = @input.shift when 3;
                $output = $ta when 4;
                $ip = $tb when $_ == 5 && $ta != 0;
                $ip = $tb when $_ == 6 && $ta == 0;
                @arr[$c] = ($ta < $tb).Int when 7;
                @arr[$c] = ($ta == $tb).Int when 8;
                last when 99;
            }

            $ip += $size if $pip == $ip;
        }
    }

    $max = max($max, $output);
}

say $max;
