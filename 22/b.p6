my $len = 10007;
my $number = 2019;

for open("input.txt").lines {
    when /cut \s (\-?\d+)/ {
        my $n = $/[0].Int;

        if $n < 0 {
            $n = $len + $n;
        }
        
        if $number >= $n {
            $number = $number - $n;
        } else {
            $number = $number + $len - $n;
        }
    }

    when /increment \s (\d+)/ {
        my $n = $/[0].Int;
        $number = $number * $n % $len;
    }

    when /stack/ {
        $number = $len - 1 - $number;
    }
}

say $number;
