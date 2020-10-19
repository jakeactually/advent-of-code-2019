my @layer := slurp("input.txt").split("", :skip-empty).rotor(25 * 6).min({ $_.grep(0).elems });

say @layer.grep(1).elems * @layer.grep(2).elems;
