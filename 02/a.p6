use lib "..";
use Cpu;

my $cpu = Cpu.from_file("input.txt", {0}, -> {});

$cpu.memory[1] = 12;
$cpu.memory[2] = 2;
$cpu.run;

say $cpu.memory[0];
