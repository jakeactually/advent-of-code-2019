use lib "..";
use Cpu;

my $cpu = Cpu.from_file("input.txt", { prompt("Enter input: ") }, { .say; });

$cpu.run;
