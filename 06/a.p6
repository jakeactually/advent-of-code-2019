my %g := {};

for open("input.txt").lines {
    my ($a, $b) = .split(")");
    %g{$a}.push($b);
}

sub value($node, $level) {
    my @children := %g{$node} || [];
    @children.elems * $level + @children.map({ value($_, $level + 1) }).sum
}

say value("COM", 1);
