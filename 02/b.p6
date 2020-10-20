use lib "..";
use Cpu;

for 0..100 -> $i {
    for 0..100 -> $j {
        my $cpu = Cpu.from_file("input.txt", {0}, -> {});

        $cpu.memory[1] = $i;
        $cpu.memory[2] = $j;
        $cpu.run;

        say $cpu.memory[0];

        if $cpu.memory[0] == 19690720 {
            say (100 * $i + $j);
            exit;
        }
    }
}
