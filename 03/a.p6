class Line {
    has $.id;
    has $.horizontal;

    has $.x1;
    has $.y1;
    has $.x2;
    has $.y2;

    method from(@arr, $horizontal, $id) {
        my @arr2 = @arr.sort(&manhattan);
        
        my ($x1, $y1) = @arr2[0];
        my ($x2, $y2) = @arr2[1];

        Line.new: :x1($x1), :y1($y1), :x2($x2), :y2($y2), :horizontal($horizontal), :id($id)
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

my @lines = gather {
    for [(@a, 1), (@b, 2)] -> (@arr, $id) {
        for @arr {
            my ($x1, $y1) = ($x, $y); 

            my ($dir, $num) := $_ ~~ /(<[RLUD]>)(\d+)/;
            
            given $dir {
                $x -= $num when 'R';
                $x += $num when 'L';
                $y -= $num when 'U';
                $y += $num when 'D';
            }
                
            my ($x2, $y2) = ($x, $y);
            
            my $horizontal = $dir eq 'R' || $dir eq 'L';

            take Line.from: [($x1, $y1), ($x2, $y2)], $horizontal, $id;
        }
    }
};

my @sorted = @lines.sort: *.manhattan;

for 0..@sorted.elems - 2 {
    my $a = @sorted[$_];
    my $b = @sorted[$_ + 1];


    if $a.horizontal {
        if $a.y1 > $b.y1 && $a.y1 < $b.y2 && $b.x1 > $a.x1 && $b.x1 < $a.x2 {
            say ($a, $b);
        }
    }

    if $b.horizontal {
        if $b.y1 > $a.y1 && $b.y1 < $a.y2 && $a.x1 > $b.x1 && $a.x1 < $b.x2 {
            say ($a, $b);
        }
    }
}
