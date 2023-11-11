// https://github.com/mcpower/adventofcode/blob/501b66084b0060e0375fc3d78460fb549bc7dfab/2019/22/a-improved.py

my $cards = 119315717514047;
my $repeats = 101741582076661;

sub inv($n) {
    return expmod($n, $cards - 2, $cards);
}

sub get($offset, $increment, $i) {
    return ($offset + $i * $increment) % $cards;
}

my $increment-mul = 1;
my $offset-diff = 0;

for open('input.txt').lines() -> $line {
    given $line {
        when "deal into new stack" {
            $increment-mul *= -1;
            $increment-mul %= $cards;
            $offset-diff += $increment-mul;
            $offset-diff %= $cards;
        }
        when /^"cut" \s+ (\-?\d+)/ {
            my $q = $0.Int;
            $offset-diff += $q * $increment-mul;
            $offset-diff %= $cards;
        }
        when /^"deal with increment " (\d+)/ {
            my $q = $0.Int;
            $increment-mul *= inv($q);
            $increment-mul %= $cards;
        }
    }
}

sub get-sequence($iterations) {
    my $increment = expmod($increment-mul, $iterations, $cards);
    my $offset =
      $offset-diff *
      (1 - $increment) *
      inv((1 - $increment-mul) % $cards) %
      $cards;
    return $increment, $offset;
}

my ($increment, $offset) = get-sequence($repeats);
say get($offset, $increment, 2020);
