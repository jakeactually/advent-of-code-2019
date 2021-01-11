my @arr = open("input.txt").lines>>.split("", :skip-empty)>>.Array;

sub out([$x, $y]) {
    [
        [$x, $y - 1],
        [$x, $y + 1],
        [$x - 1, $y],
        [$x + 1, $y]
    ]
}

my %graph;

for 0..^@arr.elems -> $y {
    for 0..^@arr[0].elems -> $x {
        my $here = @arr[$y][$x];

        if $here ~~ /\w|\@/ {
            my @walkers = [$x, $y],;
            my @grid = @arr>>.Array;
            my $steps = 1;
            
            while @walkers.elems {
                @grid[$_[1]][$_[0]] = " " for @walkers;

                my @out = @walkers.flatmap(&out);

                for @out {
                    if @grid[$_[1]][$_[0]] ~~ /\w|\@/ {
                        %graph{$here}.push((@grid[$_[1]][$_[0]], $steps + 0));
                    }
                }

                @walkers = @out.grep: {
                    @grid[$_[1]][$_[0]] eq "."
                };

                $steps++;
            }
        }
    }
}

my $keys = %graph.keys.grep(/<[a..z]>/).elems;
my %set;

class Walker {
    has $.letter;
    has %.keys;
    has @.route;
    has $.steps = 0;

    method to_state {
        "$.letter $(%.keys.keys.sort.join)"
    }

    method to_string {
        "$.to_state $.steps"
    }

    method to_sort {
        my $a = sprintf '%05d', $.steps;
        my $b = 100 - %.keys.keys.elems;

        "$a $b $.to_state"
    }
}

sub wout(Walker $walker) {
    %graph{$walker.letter}
    .grep(->($char, $distance) { $char ~~ /<[a..z]>|\@/ || $walker.keys{$char.lc} })
    .map(->($char, $distance) {
        my $new_walker = Walker.new:
            :letter($char),
            :keys($walker.keys.clone),
            :steps($walker.steps + $distance),
            :route($walker.route.clone.push($char));

        $new_walker.keys (|)= $char if $char ~~ /<[a..z]>/;
        $new_walker
    })
    .grep({ !%set{$_.to_state} })
}

my $walker = Walker.new: :letter("@");
my %walkers = $walker.to_sort => $walker;

loop {
    my $min = %walkers.min;
    %walkers{$min.key}:delete;

    my @out = wout($min.value);
    next if !@out.elems;
    say @out>>.to_string;

    if @out.any.keys.elems >= $keys {
        say @out>>.route;
        last;
    }

    my @states = @out>>.to_state;
    %set (|)= @states;

    %walkers{$_.to_sort} = $_ for @out;
}
