use lib "..";
use Cpu;

my $max = 0;

for (9, 8, 7, 6, 5).permutations {
    my $output = 0;
    my ($f1, $f2, $f3, $f4, $f5) = (False, False, False, False, False);

    my $cpu1 = Cpu.from_file("input.txt", { if $f1 { $output } else { $f1 = True; $_[0] } }, -> {});
    my $cpu2 = Cpu.from_file("input.txt", { if $f2 { $output } else { $f2 = True; $_[1] } }, -> {});
    my $cpu3 = Cpu.from_file("input.txt", { if $f3 { $output } else { $f3 = True; $_[2] } }, -> {});
    my $cpu4 = Cpu.from_file("input.txt", { if $f4 { $output } else { $f4 = True; $_[3] } }, -> {});
    my $cpu5 = Cpu.from_file("input.txt", { if $f5 { $output } else { $f5 = True; $_[4] } }, -> {});
    
    $cpu1.output = { $output = $_; $cpu1.halt; $cpu2.run; };
    $cpu2.output = { $output = $_; $cpu2.halt; $cpu3.run; };
    $cpu3.output = { $output = $_; $cpu3.halt; $cpu4.run; };
    $cpu4.output = { $output = $_; $cpu4.halt; $cpu5.run; };
    $cpu5.output = { $output = $_; $cpu5.halt; $cpu1.run; };

    $cpu1.run;

    # say $output;

    $max = max($max, $output);
}

say $max;
