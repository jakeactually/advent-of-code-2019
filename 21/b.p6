use lib "..";
use Cpu;

my Int @program = slurp("input.txt").split(",")>>.Int;

my @script =
    "OR D J\n",
    "NOT B T\n",
    "AND T J\n",
    "NOT A T\n",
    "AND D T\n",
    "OR T J\n",
    "NOT C T\n",
    "AND D T\n",
    "AND H T\n",
    "OR T J\n",
    "RUN\n";

my @int_script = @script.join.split("", :skip-empty)>>.ord;

my $cpu = Cpu.from_array(@program, {
    @int_script.shift
}, {
    .chr.print;
});

$cpu.alloc(1000);
$cpu.run;
