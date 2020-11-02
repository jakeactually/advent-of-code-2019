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
        return self if $.x == 0 || $.y == 0;

        my $gcd = $.x gcd $.y;
        Vec.new: :x($.x div $gcd), :y($.y div $gcd)
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

for 0..^$h X 0..^$w -> ($y1, $x1) {
    next if @arr[$y1][$x1] ne '#';
    my $center = Vec.from($x1, $y1);
    my $count = 0;

    for 0..^$h X 0..^$w -> ($y2, $x2) {
        next if @arr[$y2][$x2] ne '#';
        my $asteroid = Vec.from($x2, $y2);
        next if $center same $asteroid;

        my $dist = $center minus $asteroid;
        my $norm = $dist.norm;

        if $dist same $norm {
            $count++;
            next;
        }

        my $collision = False;

        repeat {
            say ($center, $asteroid, $norm);
            $asteroid = $asteroid plus $norm;
            $collision = True if @arr[$asteroid.y][$asteroid.x] eq '#' && $center diff $asteroid;
        } while $center diff $asteroid;

        $count++ if not $collision;
    }

    say $count;
}
