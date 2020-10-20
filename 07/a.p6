use lib "..";
use Cpu;

my $max = 0;

for (0, 1, 2, 3, 4).permutations {
    my $output = 0;

    for $_ {
        my @input = [$_, $output];
        my $cpu = Cpu.from_file("input.txt", { @input.shift }, { $output = $_; });
        $cpu.run;
    }

    $max = max($max, $output);
}

say $max;
