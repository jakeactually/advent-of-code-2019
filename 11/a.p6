use lib "..";
use Cpu;

my @grid = [[0 xx 200] xx 200];
my @track = [[False xx 200] xx 200];

my ($x, $y) = (100, 100);

my $oi = 0;
my $dir = 0;

my $cpu = Cpu.from_file("input.txt", { @grid[$y][$x] }, {
    if $oi % 2 == 0 {
        @grid[$y][$x] = $_;
        @track[$y][$x] = True;
    } else {
        if $_ == 0 {
            $dir = ($dir + 3) % 4;
        } else {
            $dir = ($dir + 1) % 4;
        }

        given $dir {
            $x++ when 0;
            $y++ when 1;
            $x-- when 2;
            $y-- when 3;
        }
    }

    $oi++;
});

$cpu.alloc(1000);
$cpu.run;

say @track>>.list.flat.grep({ $_ }).elems;
