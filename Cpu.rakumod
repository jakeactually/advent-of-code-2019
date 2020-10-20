unit module Intcode;

class Cpu is export {
    has Int @.memory;
    has Int $!ip = 0;
    has &.input;
    has &.output;

    method create(Int @memory, &input, &output --> Cpu) {
        Cpu.new: :@memory, :&input, :&output
    }

    method from_file(Str $path, &input, &output --> Cpu) {
        my @data := slurp("input.txt").split(",")>>.Int;
        self.create(Array[Int].new(@data), &input, &output)
    }

    method run {
        loop {
            my $modes = @.memory[$!ip];
            my ($mc, $mb, $ma, $op1, $op2) = sprintf("%05d", $modes).split("", :skip-empty);
            my $op = $op1 ~ $op2;

            my $size = (given $op {
                when $_ == 99 { 1 }
                when $_ == (3, 4).any { 2 }
                when $_ == (5, 6).any { 3 }
                when $_ == (1, 2, 7, 8).any { 4 }
            });

            my ($m, $a, $b, $c) = @.memory[$!ip..^$!ip + $size];

            # dummies
            $a ||= 0;
            $b ||= 0;
            
            my $ta = (if $ma == 0 { @.memory[$a] } else { $a });
            my $tb = (if $mb == 0 { @.memory[$b] } else { $b });

            my $pip = $!ip;

            given $op {
                @.memory[$c] = $ta + $tb when 1;
                @.memory[$c] = $ta * $tb when 2;
                @.memory[$a] = &.input.() when 3;
                &.output.($ta) when 4;
                $!ip = $tb when $_ == 5 && $ta != 0;
                $!ip = $tb when $_ == 6 && $ta == 0;
                @.memory[$c] = ($ta < $tb).Int when 7;
                @.memory[$c] = ($ta == $tb).Int when 8;
                last when 99;
            }

            $!ip += $size if $pip == $!ip;
        }
    }
}
