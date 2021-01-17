my @deck = 0..10006;

for open("input.txt").lines {
    .say;

    when /cut \s (\-?\d+)/ {
        my $n = $/[0].Int;

        if $n < 0 {
            $n = @deck.elems + $n;
        }
        
        @deck = flat(@deck[$n..*], @deck[0..^$n]);
    }

    when /increment \s (\d+)/ {
        my $n = $/[0].Int;
        my @copy = @deck.clone;

        for 0..^@deck.elems {
            @copy[$_ * $n % @deck.elems] = @deck[$_];
        }

        @deck = @copy;
    }

    when /stack/ {
        @deck = @deck.reverse;
    }
}

say @deck.first(2019, :k);
