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

sub out(Mol $c) {
    my $reaction = @data.first({
        .key.kind eq $c.kind && .key.amount % $c.amount == 0
    });

    $reaction.value.map: { $_ xx ($reaction.key.amount div .amount) }
}

my $start = Mol.new: :kind("FUEL"), :amount(1);

say out($start);
