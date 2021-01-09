use lib "..";
use Cpu;

my Int @program = slurp("input.txt").split(",")>>.Int;
my $last_x = 0;

Y_LOOP:
for 100..* -> $y {
    X_LOOP:
    for $last_x..* -> $x {
        my @coords = $x, $y;
        say @coords;

        my $cpu = Cpu.from_array(@program.clone, { @coords.shift }, {
            if $_ {
                $last_x = $x;
                my @opposite = $x + 99, $y - 99;

                my $cpu2 = Cpu.from_array(@program.clone, { @opposite.shift }, {
                    if $_ {
                        last Y_LOOP;
                    } else {
                        last X_LOOP;
                    }
                });

                $cpu2.alloc(1000);
                $cpu2.run;
            }
        });

        $cpu.alloc(1000);
        $cpu.run;
    }
}
