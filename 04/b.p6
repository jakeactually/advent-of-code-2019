my $count = 0;

for 254032..789860 {
    my @digits = .split('', :skip-empty);
    my ($double, $increase) = (False, True);

    for 0..@digits.elems - 2 {
        $increase = False if @digits[$_] > @digits[$_ + 1];
        $double = True if @digits[$_] == @digits[$_ + 1] && @digits.grep(@digits[$_]).elems < 3;
    }

    $count++ if $double && $increase;
}

say $count;
