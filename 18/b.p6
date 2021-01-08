my @arr = open("input2.txt").lines>>.split("", :skip-empty)>>.Array;

my @graphs;
my ($h, $w) = (80, 80);
my @bounds =
    (0, 0, $w / 2, $h / 2),
    (0, $h / 2, $w / 2, $h),
    ($w / 2, 0, $w, $h / 2),
    ($w / 2, $h / 2, $w, $h);

sub out([$x, $y]) {
    [
        [$x, $y - 1],
        [$x, $y + 1],
        [$x - 1, $y],
        [$x + 1, $y]
    ]
}

for @bounds -> ($x1, $y1, $x2, $y2) {
    my %graph;

    for $y1..$y2 -> $y {
        for $x1..$x2 -> $x {
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

    @graphs.push(%graph);
}

my %graph_a = @graphs[0];
my %graph_b = @graphs[1];
my %graph_c = @graphs[2];
my %graph_d = @graphs[3];

my $keys = @arr>>.list.flat.grep(/<[a..z]>/).elems;
my %set;

class Walker {
    has $.letter_a is rw;
    has $.letter_b is rw;
    has $.letter_c is rw;
    has $.letter_d is rw;
    has %.keys;
    has $.steps = 0;
    has $!the_state;

    method walk($char, $distance) {
        my $walker = Walker.new:
            :letter_a($.letter_a),
            :letter_b($.letter_b),
            :letter_c($.letter_c),
            :letter_d($.letter_d),
            :steps($.steps + $distance),
            :keys(%.keys.clone);

        $walker.keys (|)= $char if $char ~~ /<[a..z]>/;

        $walker
    }

    method to_state {
        unless $!the_state {
            $!the_state = "$.letter_a$.letter_b$.letter_c$.letter_d $(%.keys.keys.sort.join)";
        }

        $!the_state;
    }
    
    method to_string {
        "$.to_state $.steps"
    }

    method to_sort {
        my $a = sprintf '%05d', $.steps;
        my $b = 100 - %.keys.keys.elems;

        "$a $b $.to_state"
    }

    method valid($char, $distance) {
        $char ~~ /<[a..z]>|\@/ || %.keys{$char.lc}
    }

    method out_a {
        %graph_a{$.letter_a}
        .grep(->($char, $distance) { $.valid($char, $distance) })
        .map(->($char, $distance) {
            my $new_walker = $.walk($char, $distance);
            $new_walker.letter_a = $char;
            $new_walker
        })
    }
    
    method out_b {
        %graph_b{$.letter_b}
        .grep(->($char, $distance) { $.valid($char, $distance) })
        .map(->($char, $distance) {
            my $new_walker = $.walk($char, $distance);
            $new_walker.letter_b = $char;
            $new_walker
        })
    }

    method out_c {
        %graph_c{$.letter_c}
        .grep(->($char, $distance) { $.valid($char, $distance) })
        .map(->($char, $distance) {
            my $new_walker = $.walk($char, $distance);
            $new_walker.letter_c = $char;
            $new_walker
        })
    }

    method out_d {
        %graph_d{$.letter_d}
        .grep(->($char, $distance) { $.valid($char, $distance) })
        .map(->($char, $distance) {
            my $new_walker = $.walk($char, $distance);
            $new_walker.letter_d = $char;
            $new_walker
        })
    }

    method out {
        ($.out_a, $.out_b, $.out_c, $.out_d)>>.list.flat.grep({ !%set{$_.to_state} })
    }
}

my $walker = Walker.new: :letter_a("@"), :letter_b("@"), :letter_c("@"), :letter_d("@");
my %walkers = $walker.to_sort => $walker;

loop {
    my $min = %walkers.min;
    %walkers{$min.key}:delete;

    my @out = $min.value.out;
    next if (!@out.elems);
    say @out>>.to_string;

    if @out.any.keys.elems >= $keys {
        last;
    }

    my @states = @out>>.to_state;
    %set (|)= @states;

    %walkers{$_.to_sort} = $_ for @out;
}
