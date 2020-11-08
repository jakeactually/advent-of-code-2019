my @data := [];

class Mol {
    has $.kind;
    has $.amount;

    method parse($str) {
        my ($amount, $kind) = $str.split(" ");
        Mol.new: :amount($amount.Int), :$kind
    }
}

for open('input.txt').lines {
    my ($v, $k) = .split(" => ");
    @data.push: Mol.parse($k) => $v.split(", ").map({ Mol.parse($_) });
}

my %req := {};

for @data {
    for .value {
        %req{.kind} += .amount;
    }
}

say %req;
