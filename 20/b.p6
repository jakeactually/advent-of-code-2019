my @arr = open("input.txt").lines>>.split("", :skip-empty)>>.Array;

my %coords =
    0 =>
        <3 3
        123 3
        33 85
        93 85>,
    1 =>
        <3 115
        123 115
        33 33
        93 33>,
    2 =>
        <3 3
        3 115
        93 33
        93 85>,
    3 =>
        <123 3
        123 115
        33 33
        33 85>;

my %test =
    0 =>
        <3 3
        35 3
        9 37
        29 37>,
    1 =>
        <3 43
        35 43
        9 9
        29 9>,
    2 =>
        <3 3
        3 43
        29 9
        29 37>,
    3 =>
        <35 3
        35 43
        9 9
        9 37>;

# %coords = %test;

%coords = %coords.map: { .key => .value <<->> 1 };

sub to_dir($x, $y, $dir) {
    given $dir {
        when 0 { $x - 2, $y, $x - 1, $y }
        when 1 { $x + 1, $y, $x + 2, $y }
        when 2 { $x, $y - 2, $x, $y - 1 }
        when 3 { $x, $y + 1, $x, $y + 2 }
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
    my $delta = 1;

    for @v -> $y1, $x1, $y2, $x2 {
        $delta = (if $delta == 1 { -1 } else { 1 });

        for $y1..$y2 -> $y {
            for $x1..$x2 -> $x {                
                if @arr[$y][$x] eq "." {
                    my ($rx1, $ry1, $rx2, $ry2) = to_dir($x, $y, $k);
                    my $label = @arr[$ry1][$rx1] ~ @arr[$ry2][$rx2];
                    @labels.push: $label, $delta, $x, $y;
                }
            }
        }
    }
}

my %graph;

for @labels -> $label, $delta, $x, $y {
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
            my $pair = @labels.rotor(4).first({ $x eq $_[2] && $y eq $_[3] });
            %graph{"$label $delta"}.push: $pair[0], $pair[1], $steps + 0 if $pair;
        }
        
        @walkers = @out;
        $steps++;
    }
}

%graph{"AA 1"} = [];
%graph{"ZZ 1"} = [];

class Walker {
    has $.label;
    has $.delta;
    has $.depth = 0;
    has $.steps = -1;
    has %.set;
    has @.route;

    method out {
        %graph{"$.label $.delta"}
            .map(-> $other, $delta, $distance {
                Walker.new:
                    :label($other),
                    :delta(-$delta),
                    :depth($.depth + $delta),
                    :steps($.steps + $distance + 1)
                    :set(%.set (|) $.to_state),
                    :route(@.route.clone.push($.label, $.depth, $distance))
            })
            .grep({
                !%.set{$_.to_state} &&
                !$_.is_wall
            });
    }

    method is_wall { 
        $.depth <= 0 && $.delta == -1 && !($.label ~~ /AA|ZZ/) ||
        $.depth > 0 && $.label ~~ /AA|ZZ/ ||
        $.depth > 30 ||
        $.depth < -1
    }

    method to_state {
        "$.depth $.label $.delta"
    }

    method to_sort {
        my $steps = sprintf "%05d", $.steps;

        "$steps $.to_state"
    }
}

my $walker = Walker.new: :label("AA"), :delta(-1);
my %walkers = $walker.steps => $walker;

while %walkers.elems {
    my $min = %walkers.min;
    %walkers{$min.key}:delete;

    my @out = $min.value.out;
    say @out>>.to_sort;
    next if !@out.elems;

    my $goal = @out.first: { .label eq "ZZ" && .depth == -1 };

    if ($goal) {
        say $goal;
        last;
    }

    %walkers{$_.to_sort} = $_ for @out;
}
