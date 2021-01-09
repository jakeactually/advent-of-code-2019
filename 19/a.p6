use lib "..";
use Cpu;

my @coords = flat(0..49 X 0..49);
my $count = 0;
my Int @program = slurp("input.txt").split(",")>>.Int;

for 1..50 * 50 {
    my $cpu = Cpu.from_array(@program.clone, { my $x = @coords.shift; say $x; $x }, {
        $count += $_;
    });

    $cpu.alloc(1000);
    $cpu.run;
}

say $count;
