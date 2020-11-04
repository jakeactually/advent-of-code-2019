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
my ($sa, $sb, $sc, $sd) = ($a, $b, $c, $d);
my ($va, $vb, $vc, $vd) = Vec.from(0, 0, 0) xx 4;
my ($rx, $ry, $rz) = (0, 0, 0);

for 0..* {
    $va = $va plus ($a force $b) plus ($a force $c) plus ($a force $d);
    $vb = $vb plus ($b force $c) plus ($b force $d) plus ($b force $a);
    $vc = $vc plus ($c force $d) plus ($c force $a) plus ($c force $b);
    $vd = $vd plus ($d force $a) plus ($d force $b) plus ($d force $c);

    $a = $a plus $va;
    $b = $b plus $vb;
    $c = $c plus $vc;
    $d = $d plus $vd;

    $rx = $_ if $rx == 0 && $a.x == $sa.x && $b.x == $sb.x && $c.x == $sc.x && $d.x == $sd.x;
    $ry = $_ if $ry == 0 && $a.y == $sa.y && $b.y == $sb.y && $c.y == $sc.y && $d.y == $sd.y;
    $rz = $_ if $rz == 0 && $a.z == $sa.z && $b.z == $sb.z && $c.z == $sc.z && $d.z == $sd.z;

    if $rx != 0 && $ry != 0 && $rz != 0 {
        say (($rx + 2) lcm ($ry + 2) lcm ($rz + 2));
        last;
    }
}
