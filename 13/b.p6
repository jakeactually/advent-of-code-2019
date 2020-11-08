use lib "..";
use Cpu;

my @grid = [[0 xx 200] xx 200];
my ($x, $y) = (0, 0);
my $i = 0;

my $cpu = Cpu.from_file("input.txt", { 0 }, {
    given $_ {
        $x = $_ when $i % 3 == 0;
        $y = $_ when $i % 3 == 1;
        @grid[$y][$x] = $_ when $i % 3 == 2;
    }
    
    $i++;
});

$cpu.alloc(1000);
$cpu.run;

say @grid>>.list.flat.grep(2).elems;
