my @g := [];

for open("input.txt").lines {
    my ($a, $b) = .split(")");
    @g.push([$a, $b]);
    @g.push([$b, $a]);
}

sub out($node) {
    @g.grep(*[0] eq $node)
}

my @ws = ["YOU"];
my %visited = "YOU" => True;

for 1..* {
    say @ws;

    @ws = @ws.flatmap(&out)>>[1].grep({ ! %visited{$_} });
    %visited (|)= @ws;

    if @ws.any eq "SAN" {
        .say;
        last;
    }
}

say @g;
