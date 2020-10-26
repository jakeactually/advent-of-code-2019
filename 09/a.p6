use lib "..";
use Cpu;

my $cpu = Cpu.from_file("input.txt", { prompt("Enter input: ") }, { .say });

$cpu.alloc(200);
$cpu.run;
