class Line {
    has $.id;
    has $.horizontal;
    has $.steps;

    has $.x1;
    has $.y1;
    has $.x2;
    has $.y2;

    method from([($x1, $y1), ($x2, $y2)], $horizontal, $id, $steps) {
        Line.new: :$x1, :$y1, :$x2, :$y2, :$horizontal, :$id, :$steps
    }

    method manhattan {
        abs($.x1) + abs($.y1)
    }
}

sub manhattan((Int $x, Int $y)) {
    abs($x) + abs($y)
}

my (@a, @b) := slurp('input.txt').lines.map: *.split(',');

my ($x, $y) = (0, 0);
my $steps = 0;

my @lines = gather {
    for [(@a, 1), (@b, 2)] -> (@arr, $id) {
        ($x, $y) = (0, 0);
        $steps = 0;

        for @arr {
            my ($x1, $y1) = ($x, $y); 

            my ($dir, $num) := $_ ~~ /(<[LRUD]>)(\d+)/;
            
            given $dir {
                $x -= $num when 'L';
                $x += $num when 'R';
                $y += $num when 'U';
                $y -= $num when 'D';
            }
            
            my ($x2, $y2) = ($x, $y);
            
            my $horizontal = $dir eq 'R' || $dir eq 'L';

            take Line.from: [($x1, $y1), ($x2, $y2)], $horizontal, $id, $steps;

            $steps += $num;
        }
    }
};

#.say for @lines;

for @lines.combinations(2) -> ($l1, $l2) {
    next if $l1.horizontal == $l2.horizontal || $l1.id == $l2.id;

    my ($a, $b) = (if $l1.horizontal { ($l1, $l2) } else { ($l2, $l1) });

    my $intersect =
        ($a.y1 > min($b.y1, $b.y2) && $a.y1 < max($b.y1, $b.y2)) &&
        ($b.x1 > min($a.x1, $a.x2) && $b.x1 < max($a.x1, $a.x2));

    if $intersect {
        #say ($a, $b);
        #say ($b.x1, $a.y1);
        say ($a.steps + $b.steps);
    }
}
