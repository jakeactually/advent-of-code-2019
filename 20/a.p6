my @arr = open("input.txt").lines>>.split("", :skip-empty)>>.Array;

my %coords =
    1 =>
        <3 3
        123 3
        33 85
        93 85>,
    2 =>
        <33 33
        93 33
        3 115
        123 115>,
    3 =>
        <33 33
        33 85
        123 3
        123 115>,
    4 =>
        <3 3
        3 115
        93 33
        93 85>;

my %test =
    1 =>
        <3 3
        35 3
        9 27
        29 27>,
    2 =>
        <9 9
        29 9
        3 33
        35 33>,
    3 =>
        <9 9
        9 27
        35 3
        35 33>,
    4 =>
        <3 3
        3 33
        29 9
        29 27>;

# %coords = %test;

%coords = %coords.map: { .key => .value <<->> 1 };

sub to_dir($x, $y, $dir) {
    given $dir {
        when 1 { $x - 2, $y, $x - 1, $y }
        when 2 { $x + 1, $y, $x + 2, $y }
        when 3 { $x, $y + 1, $x, $y + 2 }
        when 4 { $x, $y - 2, $x, $y - 1 }
    }
}

sub out($x, $y) {
    $x, $y - 1,
    $x, $y + 1,
    $x - 1, $y,
    $x + 1, $y
}

my @labels;

for %coords.kv -> $k, @v {
    for @v -> $y1, $x1, $y2, $x2 {
        
        for $y1..$y2 -> $y {
            for $x1..$x2 -> $x {                
                if @arr[$y][$x] eq "." {
                    my ($rx1, $ry1, $rx2, $ry2) = to_dir($x, $y, $k);
                    my $label = @arr[$ry1][$rx1] ~ @arr[$ry2][$rx2];
                    @labels.push: $label, $x, $y;
                }
            }
        }
    }
}

my %graph;

for @labels -> $k, $x, $y {
    my @walkers = $x, $y;
    my @grid = @arr>>.Array;
    my $steps = 1;
    
    while @walkers.elems {
        for @walkers -> $x, $y {
            @grid[$y][$x] = " ";
        }

        my @out = @walkers
            .flatmap(&out)
            .grep(-> $x, $y {
                @grid[$y][$x] eq "."
            })
            .flat;
        
        for @out -> $x, $y {
            my $pair = @labels.rotor(3).first({ $x eq $_[1] && $y eq $_[2] });
            %graph{$k}.push: $pair[0], $steps + 0 if $pair;
        }
        
        @walkers = @out;
        $steps++;
    }
}


class Walker {
    has $.label;
    has $.steps = -1;
    has %.set;
    has @.route;

    method out {
        %graph{$.label}
            .map(-> $other, $distance {
                Walker.new:
                    :label($other),
                    :steps($.steps + $distance + 1)
                    :set(%.set (|) $.label),
                    :route(@.route.clone.push($.label, $distance))
            })
            .grep({ !%.set{$_.label} });
    }

    method to_sort {
        my $steps = sprintf '%05d', $.steps;

        "$steps $.label"
    }
}

my $walker = Walker.new: :label("AA");
my %walkers = $walker.steps => $walker;

loop {
    my $min = %walkers.min;
    %walkers{$min.key}:delete;

    my @out = $min.value.out;
    next if !@out.elems;

    if @out.any.label eq "ZZ" {
        say @out;
        last;
    }

    %walkers{$_.to_sort} = $_ for @out;
}
