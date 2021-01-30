use lib "..";
use Cpu;

my @buffer;

my $cpu = Cpu.from_file("input.txt", {
    if !@buffer.elems {
        @buffer = prompt.split("", :skip-empty)>>.ord.Array.push(10);
    }

    @buffer.shift
}, {
    .chr.print
});

$cpu.alloc(1000);

$cpu.run;
