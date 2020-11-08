use lib "..";
use Cpu;

my @grid = [[0 xx 38] xx 21];
my ($x, $y) = (0, 0);
my $bx = 0;
my $px = 0;
my $i = 0;
my $score = 0;

sub render {
    print "\e[2J\e[H";

    for @grid {
        for .list {
            print ' ' when 0;
            print '|' when 1;
            print '#' when 2;
            print '-' when 3;
            print 'o' when 4;
        }

        say '';
    }

    say '';
    say $score;
}

my $cpu = Cpu.from_file("input.txt", {
    when $px > $bx { -1 };
    when $px < $bx { 1 };
    default { 0 }
}, {
    given $_ {
        $x = $_ when $i % 3 == 0;
        $y = $_ when $i % 3 == 1;

        when $i % 3 == 2 {
            if $x == -1 && $y == 0 {
                $score = $_;
            } else {
                @grid[$y][$x] = $_;
                $bx = $x if $_ == 4;
                $px = $x if $_ == 3;
            }

            render;
        }
    }
    
    $i++;
});

$cpu.alloc(1000);
$cpu.memory[0] = 2;
$cpu.run;
