use lib "..";
use Cpu;

my Int @program = slurp("input.txt").split(",")>>.Int;

my %input;
my %buffer;
my @nat;

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
                
                if @message[0] == 255 {
                    @nat = @message[1], @message[2];
                } else {
                    %input{@message[0]}.push(@message[1], @message[2]);
                }

                %buffer{$i} = [];
            }
        });

        $cpu.alloc(1000);
        
        take start $cpu.run;
    }

    take start {
        loop {
            await Promise.in(5);
            
            if %input.all.value.elems <= 0 {
                say @nat;
                %input{0}.push(@nat[0], @nat[1]);
                @nat = [];
            }
        }
    }
};

await(@futures);
