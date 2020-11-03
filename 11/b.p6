use lib "..";
use Cpu;

my @grid = [[0 xx 100] xx 100];
my @track = [[False xx 100] xx 100];

my ($x, $y) = (50, 50);

my $oi = 0;
my $dir = 0;

@grid[$y][$x] = 1;
@track[$y][$x] = True;

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

for @grid {
    say $_.map({
        when 0 { ' ' }
        when 1 { '#' }
    });
}
