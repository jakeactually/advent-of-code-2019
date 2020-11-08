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
    has Str $.label = "";
    has Int $.production = 0;
    has Int $!produced = 0;
    has Int $!current = 0;
    has Dependency @.dependencies = [];

    method ask(Int $n) {
        if $.label eq "ORE" {
            $!produced += $n;
        } else {
            while $n > $!current {
                %stores{.label}.ask(.amount) for @.dependencies;
                $!current += $.production;
                $!produced += $.production;
            }
            
            $!current -= $n;
        }
    }

    method get_produced {
        $!produced
    }
    
    method get_current {
        $!current
    }
}

%stores{"ORE"} = Store.new: :label("ORE"), :production(1);

for open('input.txt').lines {
    my ($v, $k) = .split(" => ");
    my ($production, $label) = $k.words;
    my @dependencies = $v.split(", ").map({ Dependency.parse($_) });
    %stores{$label} = Store.new: :$label, :production($production.Int), :@dependencies;
}

for 0..* {
    %stores{"FUEL"}.ask(1);

    if %stores.all.value.get_current == 0 {
        last;
    }

    .say;
}
