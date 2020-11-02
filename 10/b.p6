my @arr = open('input.txt').lines>>.split('', :skip-empty)>>.Array;
my $hashes = @arr>>.list.flat.grep("#").elems;
my $h = @arr.elems;
my $w = @arr[0].elems;

class Vec {
    has $.x;
    has $.y;

    method from($x, $y) {
        Vec.new: :$x, :$y
    }

    method norm {
        if $.x == 0 || $.y == 0 {
            Vec.new: :x($.x.sign), :y($.y.sign)
        } else {
            my $gcd = $.x gcd $.y;
            Vec.new: :x($.x div $gcd), :y($.y div $gcd)
        }
    }

    method WHICH {
        "$.x, $.y"
    }

    method manhathan {
        abs($.x) + abs($.y)
    }
}

sub infix:<minus>(Vec $v1, Vec $v2) {
    Vec.new: :x($v1.x - $v2.x), :y($v1.y - $v2.y)
}

sub infix:<plus>(Vec $v1, Vec $v2 --> Vec) {
    Vec.new: :x($v1.x + $v2.x), :y($v1.y + $v2.y)
}

sub infix:<same>(Vec $v1, Vec $v2 --> Bool) {
    $v1.x == $v2.x && $v1.y == $v2.y
}

sub infix:<diff>(Vec $v1, Vec $v2 --> Bool) {
    $v1.x != $v2.x || $v1.y != $v2.y
}

#my $station = Vec.from(28, 29);
my $station = Vec.from(5, 5);

my @vecs = (0..^$h X 0..^$w)
    .grep(-> ($y, $x) { @arr[$y][$x] eq '#' })
    .map(-> ($y, $x) { Vec.from($x, $y) minus $station });

my @data = @vecs.classify(*.norm).pairs
    #.map({ $_.key => $_.value.sort(*.manhathan) })
    .map({ atan2($_.key.y, $_.key.x) * 360 / pi });

for @data {
    .say;
}
