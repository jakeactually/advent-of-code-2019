my %stores := {};

class Dependency {
    has Int $.amount = 0;
    has Str $.label  = "";

    method parse(Str $str) {
        my ($amount, $label) = $str.words;
        Dependency.new: :amount($amount.Int), :$label
    }
}

class Store {
    has Int $.production = 0;
    has Int $!produced = 0;
    has Int $!current = 0;
    has Dependency @.dependencies = [];

    method ask(Int $n) {
        if $n > $!current {
            my $required = $n - $!current;
            my $times = ceiling($required / $.production);

            %stores{.label}.ask(.amount * $times) for @.dependencies;

            $!current += $times * $.production;
            $!produced += $times * $.production;
        }

        $!current -= $n;
    }

    method get_produced {
        $!produced
    }
}

%stores{"ORE"} = Store.new: :production(1);

for open('input.txt').lines {
    my ($v, $k) = .split(" => ");
    my ($production, $label) = $k.words;
    my @dependencies = $v.split(", ").map({ Dependency.parse($_) });

    %stores{$label} = Store.new: :production($production.Int), :@dependencies;
}

%stores{"FUEL"}.ask(6216589);
say %stores{"ORE"}.get_produced >= 1000000000000;
