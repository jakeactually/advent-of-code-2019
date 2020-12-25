my @grid = slurp("maze.txt").lines.map: {
    [.split("").rotor(2)>>[1]]
};

sub out([$x, $y]) {
    [
        [$x, $y - 1],
        [$x, $y + 1],
        [$x - 1, $y],
        [$x + 1, $y]
    ]
}

my @walkers = [5, 1],;
my $i = 0;

while @walkers.elems {
    for @walkers {
        @grid[$_[1]][$_[0]] = ".";
    }

    @walkers = @walkers.flatmap(&out).grep: {
        @grid[$_[1]][$_[0]] eq " "
    };

    $i++;
}

say $i - 1;
