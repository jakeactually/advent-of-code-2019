my $count = 0;

for 254032..789860 {
    my ($double, $increase) = (False, True);
    my @digits = .split('');

    for 0..@digits.elems - 2 {
        if @digits[$_] - @digits[$_ + 1] < 0 {
            $increase = False;
        }

        if @digits[$_] - @digits[$_ + 1] == 0 {
            $double = True;
        }

        if $double && $increase {
            $count++;
        }
    }
}

say $count;
