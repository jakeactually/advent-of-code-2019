use lib "..";
use Cpu;

my @chars;

my $cpu = Cpu.from_file("input.txt", { 0 }, {
    @chars.push($_);
});

$cpu.alloc(1000);
$cpu.run;

spurt "map.txt", @chars>>.chr.join;
