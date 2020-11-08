class Vec {
    has $.x;
    has $.y;
    has $.z;

    method from($x, $y, $z) {
        Vec.new: :$x, :$y, :$z
    }

    method parse($str) {
        my ($x, $y, $z) = ($str ~~ m:g/\-?\d+/)>>.Int;
        Vec.new: :$x, :$y, :$z
    }
    
    method manhathan {
        abs($.x) + abs($.y) + abs($.z)
    }
}

sub infix:<plus>(Vec $v1, Vec $v2) {
    Vec.new: :x($v1.x + $v2.x), :y($v1.y + $v2.y), :z($v1.z + $v2.z)
}

sub infix:<force>(Vec $v1, Vec $v2) {
    Vec.new:
        :x(($v2.x - $v1.x).sign),
        :y(($v2.y - $v1.y).sign),
        :z(($v2.z - $v1.z).sign)
}

sub infix:<approach>(Vec $v1, Vec $v2) {
    $v1 plus ($v1 force $v2)
}

my ($a, $b, $c, $d) = open('input.txt').lines.map({ Vec.parse($_) });
my ($va, $vb, $vc, $vd) = Vec.from(0, 0, 0) xx 4;

for 0..^1000 {
    $va = $va plus ($a force $b) plus ($a force $c) plus ($a force $d);
    $vb = $vb plus ($b force $c) plus ($b force $d) plus ($b force $a);
    $vc = $vc plus ($c force $d) plus ($c force $a) plus ($c force $b);
    $vd = $vd plus ($d force $a) plus ($d force $b) plus ($d force $c);

    $a = $a plus $va;
    $b = $b plus $vb;
    $c = $c plus $vc;
    $d = $d plus $vd;
}

say
    $a.manhathan * $va.manhathan +
    $b.manhathan * $vb.manhathan +
    $c.manhathan * $vc.manhathan +
    $d.manhathan * $vd.manhathan;
