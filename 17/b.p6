use lib "..";
use Cpu;

my @console;
my $path = "A,B,A,C,A,B,C,B,C,B\n";
my $a = "L,10,R,8,L,6,R,6\n";
my $b = "L,8,L,8,R,8\n";
my $c = "R,8,L,6,L,10,L,10\n";
my $video = "n\n";
my @input = ($path, $a, $b, $c, $video).join.split("", :skip-empty)>>.ord;

my $cpu = Cpu.from_file("input.txt", { @input.shift }, {
    .say
});

$cpu.memory[0] = 2;
$cpu.alloc(4000);
$cpu.run;

# spurt "map2.txt", @console>>.chr.join;
