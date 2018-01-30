use v6.c;
use lib <t/spec/packages>;
use Test;
use Test::Util;

# This file is for random bugs that don't really fit well in other places.
# Feel free to move the tests to more appropriate places.

plan 5;

subtest '.count-only/.bool-only for iterated content' => {
    plan 2;

    sub iters {                                    # values / desc
        <a b c>.iterator                        => [3, 'List.iterator'],
        <a b c>.reverse.iterator                => [3, 'List.reverse.iterator'],
        [<a b c>].iterator                      => [3, 'Array.iterator'],
        Buf.new(1, 2, 3).iterator               => [3, 'Buf.iterator'],
        %(:42foo, :70bar, :2meow).keys.iterator => [3, 'Hash.keys.iterator'],
        %(:42foo, :70bar).kv.iterator           => [4, 'Hash.kv.iterator'],
        combinations(4,1).iterator              => [4, '&combinations'],
        permutations(2).iterator                => [2, '&permutations'],
        4.combinations(1).iterator              => [4, '.combinations'],
        ^2 .permutations.iterator               => [2, '.permutations'],
        :42foo.iterator                         => [1, 'Pair.iterator'],
        :42foo.kv.iterator                      => [2, 'Pair.kv.iterator'],
    }

    subtest '.count-only' => {
        plan +my @iters = iters;
        for @iters -> (:key($iter), :value(($count, $desc))) {
            unless $iter.^can: 'count-only' {
                skip '.count-only is not implemented';
                next;
            }

            subtest $desc => {
                plan 2 + $count;
                cmp-ok $iter.count-only, '==', $count, 'before iterations';
                for 1..$count -> $iteration {
                    $iter.pull-one;
                    cmp-ok $iter.count-only, '==', $count - $iteration,
                        "iteration $iteration";
                }
                $iter.pull-one;
                cmp-ok $iter.count-only, '==', 0,
                    "one more pull, after all iterations";
            }
        }
    }

    subtest '.bool-only' => {
        plan +my @iters = iters;
        for @iters -> (:key($iter), :value(($count, $desc))) {
            unless $iter.^can: 'bool-only' {
                skip '.bool-only is not implemented';
                next;
            }

            subtest $desc => {
                plan 2 + $count;
                ok $iter.bool-only, 'before iterations';
                for 1..$count -> $iteration {
                    $iter.pull-one;
                    is-deeply $iter.bool-only, so($count - $iteration),
                        "iteration $iteration";
                }
                $iter.pull-one;
                nok $iter.count-only, "one more pull, after all iterations";
            }
        }
    }
}

# https://github.com/rakudo/rakudo/issues/1407
subtest 'enums with names of core types do not blow things up unexpectedly' => {
    plan 3;
    my enum Foo «:Map<foo> :Positional<ber> :Callable<meow>»;
    my %h = :42foo, :70bar;
    my &foo = *.self;
    my @a = <a b c>;
    is-deeply %h,      %(:42foo, :70bar), 'Hash works';
    is-deeply foo(42), 42,                'Callable works';
    is-deeply @a,      [<a b c>],         'Array works';
}

# https://github.com/rakudo/rakudo/issues/1411
-> Positional:D[Int] \z {
    is-deeply z, (1, 2, 3),
    'parametarization of a DefiniteHOW does not complain about complex coercers'
}((1, 2, 3));

# RT #132718
subtest 'no crashes with native types in conditionals' => {;
    plan 6;
    subtest 'if' => {
        plan 12;
        ->        $x { pass 'HLL obj' if $x }(now);
        -> int8   $x { pass 'int8'    if $x }(2);
        -> int16  $x { pass 'int16'   if $x }(2);
        -> int32  $x { pass 'int32'   if $x }(2);
        -> int64  $x { pass 'int64'   if $x }(2);

        -> uint8  $x { pass 'uint8'  if $x }(2);
        -> uint16 $x { pass 'uint16' if $x }(2);
        -> uint32 $x { pass 'uint32' if $x }(2);
        -> uint64 $x { pass 'uint64' if $x }(2);

        -> num32  $x { pass 'num32'  if $x }(2e0);
        -> num64  $x { pass 'num64'  if $x }(2e0);
        -> str    $x { pass 'str'    if $x }('meow');
    }

    subtest 'unless' => {
        plan 12;
        sub (       $x) { return unless $x; pass 'HLL obj' }(now);
        sub (int8   $x) { return unless $x; pass 'int8'    }(2);
        sub (int16  $x) { return unless $x; pass 'int16'   }(2);
        sub (int32  $x) { return unless $x; pass 'int32'   }(2);
        sub (int64  $x) { return unless $x; pass 'int64'   }(2);

        sub (uint8  $x) { return unless $x; pass 'uint8'   }(2);
        sub (uint16 $x) { return unless $x; pass 'uint16'  }(2);
        sub (uint32 $x) { return unless $x; pass 'uint32'  }(2);
        sub (uint64 $x) { return unless $x; pass 'uint64'  }(2);

        sub (num32  $x) { return unless $x; pass 'num32'   }(2e0);
        sub (num64  $x) { return unless $x; pass 'num64'   }(2e0);
        sub (str    $x) { return unless $x; pass 'str'     }('meow');
    }

    subtest 'repeat while' => {
        plan 12;
        sub (       $x) { while $x { pass 'HLL obj'; return } }(now);
        sub (int8   $x) { while $x { pass 'int8';    return } }(2);
        sub (int16  $x) { while $x { pass 'int16';   return } }(2);
        sub (int32  $x) { while $x { pass 'int32';   return } }(2);
        sub (int64  $x) { while $x { pass 'int64';   return } }(2);

        sub (uint8  $x) { while $x { pass 'uint8';   return } }(2);
        sub (uint16 $x) { while $x { pass 'uint16';  return } }(2);
        sub (uint32 $x) { while $x { pass 'uint32';  return } }(2);
        sub (uint64 $x) { while $x { pass 'uint64';  return } }(2);

        sub (num32  $x) { while $x { pass 'num32';   return } }(2e0);
        sub (num64  $x) { while $x { pass 'num64';   return } }(2e0);
        sub (str    $x) { while $x { pass 'str';     return } }('meow');
    }

    subtest 'repeat until' => {
        plan 12;
        sub (       $x) { Nil until $x; pass 'HLL obj' }(now);
        sub (int8   $x) { Nil until $x; pass 'int8'    }(2);
        sub (int16  $x) { Nil until $x; pass 'int16'   }(2);
        sub (int32  $x) { Nil until $x; pass 'int32'   }(2);
        sub (int64  $x) { Nil until $x; pass 'int64'   }(2);

        sub (uint8  $x) { Nil until $x; pass 'uint8'   }(2);
        sub (uint16 $x) { Nil until $x; pass 'uint16'  }(2);
        sub (uint32 $x) { Nil until $x; pass 'uint32'  }(2);
        sub (uint64 $x) { Nil until $x; pass 'uint64'  }(2);

        sub (num32  $x) { Nil until $x; pass 'num32'   }(2e0);
        sub (num64  $x) { Nil until $x; pass 'num64'   }(2e0);
        sub (str    $x) { Nil until $x; pass 'str'     }('meow');
    }

    subtest 'repeat while' => {
        plan 12;
        sub (       $x) { repeat { pass 'HLL obj'; return } while $x }(now);
        sub (int8   $x) { repeat { pass 'int8';    return } while $x }(2);
        sub (int16  $x) { repeat { pass 'int16';   return } while $x }(2);
        sub (int32  $x) { repeat { pass 'int32';   return } while $x }(2);
        sub (int64  $x) { repeat { pass 'int64';   return } while $x }(2);

        sub (uint8  $x) { repeat { pass 'uint8';   return } while $x }(2);
        sub (uint16 $x) { repeat { pass 'uint16';  return } while $x }(2);
        sub (uint32 $x) { repeat { pass 'uint32';  return } while $x }(2);
        sub (uint64 $x) { repeat { pass 'uint64';  return } while $x }(2);

        sub (num32  $x) { repeat { pass 'num32';   return } while $x }(2e0);
        sub (num64  $x) { repeat { pass 'num64';   return } while $x }(2e0);
        sub (str    $x) { repeat { pass 'str';     return } while $x }('meow');
    }

    subtest 'repeat until' => {
        plan 12;
        sub (       $x) { repeat {} until $x; pass 'HLL obj' }(now);
        sub (int8   $x) { repeat {} until $x; pass 'int8'    }(2);
        sub (int16  $x) { repeat {} until $x; pass 'int16'   }(2);
        sub (int32  $x) { repeat {} until $x; pass 'int32'   }(2);
        sub (int64  $x) { repeat {} until $x; pass 'int64'   }(2);

        sub (uint8  $x) { repeat {} until $x; pass 'uint8'   }(2);
        sub (uint16 $x) { repeat {} until $x; pass 'uint16'  }(2);
        sub (uint32 $x) { repeat {} until $x; pass 'uint32'  }(2);
        sub (uint64 $x) { repeat {} until $x; pass 'uint64'  }(2);

        sub (num32  $x) { repeat {} until $x; pass 'num32'   }(2e0);
        sub (num64  $x) { repeat {} until $x; pass 'num64'   }(2e0);
        sub (str    $x) { repeat {} until $x; pass 'str'     }('meow');
    }
}

use Test;
subtest 'thunking closure scoping' => {
    plan 12;

    # some canary tests to cover regressions when fixing other bugs in subtest
    is-deeply (42 andthen $_), 42, 'basic andthen';
    is-deeply gather {
        for ^2 -> \c { Nil for first { take c; 0 }, ^2; }
    }, (0, 0, 1, 1).Seq, 'nested `for`s with thunk in statement modifier';

    # https://github.com/rakudo/rakudo/issues/1212
    is-deeply <a b c>[$_ xx 2], <b b>.Seq, 'xx inside `with`' with 1;

    # RT #130575
    is-deeply gather {
        sub itcavuc ($c) { try {take $c} andthen 42 };
        itcavuc $_ for 2, 4, 6;
    }, (2, 4, 6).Seq, 'try with block and andthen';

    # RT #132337
    is-deeply gather {
        sub foo ($str) { { take $str }() orelse Nil }
        foo "cc"; foo "dd";
    }, <cc dd>.Seq, 'block in a sub with orelse';

    # RT #131548
    is-deeply gather for ^7 {
        my $x = 1;
        1 andthen $x.take andthen $x = 2 andthen $x = 3 andthen $x = 4;
    }, 1 xx 7, 'loop + lexical variable plus chain of andthens';

    # RT #132211
    is-deeply gather for <a b c> { $^v.uc andthen $v.take orelse .say },
        <a b c>.Seq, 'loop + andthen + orelse';

    # RT #126569
    is-deeply gather { (.take xx 10) given 42 }, 42 xx 10,
        'parentheses + xx + given';

    # RT #128054
    is-deeply gather { take ("{$_}") for <aa bb> }, <aa bb>.Seq,
        'postfix for + take + block in a string';

    # RT #126413
    is-deeply gather { take (* + $_)(32) given 10 }, 42.Seq,
        'given + whatever code closure execution';

    # RT #126984
    is-deeply gather {
        sub foo($x) { (* ~ $x)($_).take given $x }; foo(1); foo(2)
    }, ("11", "22").Seq, 'sub + given + whatevercode closure execution';

    # RT #132172
    is-deeply gather { sub {
        my $ver =.lines.uc with "totally-not-there".IO.open
            orelse "meow {$_ ~~ Failure}".take and return 42;
    }() }, 'meow True'.Seq, 'sub with `with` + orelse + block interpolation';
}

# vim: expandtab shiftwidth=4 ft=perl6