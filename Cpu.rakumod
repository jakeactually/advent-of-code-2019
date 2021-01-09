unit module Intcode;

class Cpu is export {
    has Int @.memory;
    has Int $!ip = 0;
    has Int $!rb = 0;
    has &.input is rw;
    has &.output is rw;
    has Bool $!running = True;
    has Bool $!active = True;

    method create(Int @memory, &input, &output --> Cpu) {
        Cpu.new: :@memory, :&input, :&output
    }

    method from_file(Str $path, &input, &output --> Cpu) {
        my @data := slurp("input.txt").split(",")>>.Int;
        self.create(Array[Int].new(@data), &input, &output)
    }

    method from_array(Int @data, &input, &output --> Cpu) {
        self.create(Array[Int].new(@data), &input, &output)
    }

    method halt {
        $!running = False;
    }

    method get_ip {
        $!ip
    }

    method alloc(Int $n) {
        @.memory.append(0 xx $n)
    }

    method run {
        $!running = True;

        while $!running && $!active {
            my $modes = @.memory[$!ip];
            my ($mc, $mb, $ma, $op1, $op2) = sprintf("%05d", $modes).split("", :skip-empty);
            my $op = $op1 ~ $op2;

            my $size = (given $op {
                when $_ == 99 { 1 }
                when $_ == (3, 4, 9).any { 2 }
                when $_ == (5, 6).any { 3 }
                when $_ == (1, 2, 7, 8).any { 4 }
            });

            my ($m, $a, $b, $c) = @.memory[$!ip..^$!ip + $size];

            # dummies
            $a ||= 0;
            $b ||= 0;
            $c ||= 0;
            
            my $ta = (if $ma == 0 { @.memory[$a] } elsif $ma == 1 { $a } else { @.memory[$!rb + $a] });
            my $tb = (if $mb == 0 { @.memory[$b] } elsif $mb == 1 { $b } else { @.memory[$!rb + $b] });
            my $tc = (if $mc == 0 { @.memory[$c] } elsif $mc == 1 { $c } else { @.memory[$!rb + $c] });
            my $ia = (if $ma == 0 { $a } else { $!rb + $a });
            my $ib = (if $mb == 0 { $b } else { $!rb + $b });
            my $ic = (if $mc == 0 { $c } else { $!rb + $c });

            $!ip += $size;

            given $op {
                @.memory[$ic] = $ta + $tb when 1;
                @.memory[$ic] = $ta * $tb when 2;
                @.memory[$ia] = &.input.() when 3;
                &.output.($ta) when 4;
                $!ip = $tb when $_ == 5 && $ta != 0;
                $!ip = $tb when $_ == 6 && $ta == 0;
                @.memory[$ic] = ($ta < $tb).Int when 7;
                @.memory[$ic] = ($ta == $tb).Int when 8;
                $!rb += $ta when 9;

                when 99 {
                    $!active = False;
                    last;
                }
            }
        }
    }
}
