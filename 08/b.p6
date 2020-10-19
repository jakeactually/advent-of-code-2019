my @layers = slurp("input.txt").split("", :skip-empty).rotor(25 * 6).reverse;

my @msg := @layers.reduce({
    $^a <<[&pixel]>> $^b
});

sub pixel($p1, $p2) {
    if $p2 == 2 { $p1 } else { $p2 }
}

for @msg.rotor(25) {
    for $_ {
        print " " when 0;
        print "*" when 1;
    }

    say "";
}
