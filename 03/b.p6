class Point {
    has $.x;
    has $.y;

    method from((Int $x, Int $y)) {
        Point.new: :$x, :$y
    }
}

class Line {
    has $.id;
    has $.horizontal;
    has $.steps;
    has $.p1;
    has $.p2;

    method from([$p1, $p2], $horizontal, $id, $steps) {
        Line.new: :p1(Point.from($p1)), :p2(Point.from($p2)), :$horizontal, :$id, :$steps
    }

    method inY(Line $l) {
        $.p1.y > min($l.p1.y, $l.p2.y) && $.p1.y < max($l.p1.y, $l.p2.y)
    }

    method inX(Line $l) {
        $.p1.x > min($l.p1.x, $l.p2.x) && $.p1.x < max($l.p1.x, $l.p2.x)
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

    my $intersect = $a.inY($b) && $b.inX($a);

    if $intersect {
        my $diff_x = abs(abs($a.p1.x) - abs($b.p1.x));
        my $diff_y = abs(abs($a.p1.y) - abs($b.p1.y));

        say ($a.steps + $b.steps + $diff_x + $diff_y);
    }
}
