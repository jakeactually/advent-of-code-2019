use lib "..";
use Cpu;

my @grid = [["!" xx 41] xx 41];
my ($x, $y) = (21, 21);
my $dir = 1;
my @stack := [];
my $is_pop = False;

my %opposites =
    1 => 2,
    2 => 1,
    3 => 4,
    4 => 3;

@grid[$y][$x] = "A";

sub maybe_coords {
    do given $dir {
        when 1 { ($x, $y - 1) }
        when 2 { ($x, $y + 1) }
        when 3 { ($x - 1, $y) }
        when 4 { ($x + 1, $y) }
    }
}

my $cpu = Cpu.from_file("input.txt", sub {
    loop {
        if $dir > 4 {
            $dir = %opposites{@stack.pop};
            $is_pop = True;
            return $dir;
        }

        my ($mx, $my) = maybe_coords;
        return $dir if @grid[$my][$mx] eq "!";
        $dir++;
    }
}, {
    my ($mx, $my) = maybe_coords;

    if $is_pop {
        ($x, $y) = ($mx, $my);
        $dir = 1;

        $is_pop = False;
    } else {
        if $_ == 0 {
            @grid[$my][$mx] = "#";
            $dir++;
        } else {
            @stack.push($dir);

            ($x, $y) = ($mx, $my);
            $dir = 1;

            @grid[$y][$x] = " ";
            @grid[$y][$x] = "B" if $_ == 2;
        }
    }

    $cpu.halt;
 });

$cpu.alloc(1000);

for 1..2450 {
    $cpu.run;
}

spurt "maze.txt", @grid.join("\n");
