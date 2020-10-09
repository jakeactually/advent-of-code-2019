my @ins = slurp('input.txt') ~~ m:g/\d* <[12]> \,\-?\d+\,\-?\d+\,\-?\d+ | \d* <[34]> \,\-?\d+/;

.Str.say for @ins; exit;

my %ctx := {};

for @ins  {
    my ($modes, $a, $b, $c) = $_.split(',');

    $b ||= 0;
    $c ||= 0;

    my ($mc, $mb, $ma, $m_, $op) = sprintf('%05d', $modes).split('', :skip-empty);

    my $ta = (if $ma == 0 { %ctx{$a} || 0 } else { $a });
    my $tb = (if $mb == 0 { %ctx{$b} || 0 } else { $b });

    given $op {
        %ctx{$c} = $ta + $tb when 1;
        %ctx{$c} = $ta * $tb when 2;
        %ctx{$a} = prompt("Enter input: ") when 3;
        say $ta when 4;
    }
}

say %ctx;
