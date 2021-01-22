use lib "..";
use Cpu;

my Int @program = slurp("input.txt").split(",")>>.Int;

my %input;
my %buffer;

for 0..49 -> $i {
    %input{$i} = [$i];
}

my @futures = gather {
    for 0..49 -> $i {
        my $cpu = Cpu.from_array(@program, {
            if %input{$i}.elems {
                %input{$i}.shift
            } else {
                -1
            }
        }, {
            %buffer{$i}.push($_);

            if %buffer{$i}.elems >= 3 {
                my @message := %buffer{$i};
                
                say @message;

                %input{@message[0]}.push(@message[1], @message[2]);
                %buffer{$i} = [];
            }
        });

        $cpu.alloc(1000);
        
        take start $cpu.run;
    }
};

await(@futures);
