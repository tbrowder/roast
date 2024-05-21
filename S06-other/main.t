use Test;
use lib $?FILE.IO.parent(2).add("packages/Test-Helpers");
use Test::Util;

use lib $?FILE.IO.parent(2).add("packages/HasMain/lib");

plan 11;

## If this test file is fudged, then MAIN never executes because
## the fudge script introduces an C<exit(1)> into the mainline.
## This definition prevents that insertion from having any effect.  :-)
sub exit { }

# L<S06/Declaring a C<MAIN> subroutine/>

sub MAIN($a, $b, *@c) {
    ok(1, 'MAIN called correctly');
    is($a, 'a', 'first positional param set correctly');
    is($b, 'b', 'second positional param set correctly');
    is(~@c, 'c d e', 'slurpy param set correctly');
}

@*ARGS = <a b c d e>;

ok( @*ARGS == 5, '@*ARGS has correct elements');

# https://github.com/Raku/old-issue-tracker/issues/2844
lives-ok { require HasMain }, 'MAIN in a module did not get executed';

# https://github.com/Raku/old-issue-tracker/issues/4527
is_run 'sub MAIN() { map { print "ha" }, ^3 }',
    {
        out => "hahaha",
    },
    'MAIN return value is sunk';


# https://github.com/Raku/old-issue-tracker/issues/5808
subtest 'MAIN can take type-constraint using Enums' => {
    plan 3;

    my $code = Q:to/END/;
        enum Hand <Rock Paper Scissors>;
        sub MAIN (Hand $hand, Hand :$pos-hand) {
            print "pass";
        }
    END
    is_run $code, :args[<Rock>                    ], { :out<pass>, :err('') }, 'positional works';
    is_run $code, :args[<--pos-hand=Scissors Rock>], { :out<pass>, :err('') }, 'positional + named works';
    is_run $code, :args[<Hand>                    ], { :out{not .contains: 'pass'}, :err(/'=<Hand>'/) },
        'name of enum itself is not valid and usage message prints the name of the enum';
}

subtest 'MAIN can take type-constraint using Enums that contain values that shadow CORE types' => {
    plan 3;

    my $code = Q:to/END/;
        enum Shadow <Label Hash Lock>;
        sub MAIN (Shadow $shadow, Shadow :$pos-shadow) {
            print "pass";
        }
    END
    is_run $code, :args[<Lock>                   ], { :out<pass>, :err('') }, 'positional works';
    is_run $code, :args[<--pos-shadow=Label Lock>], { :out<pass>, :err('') }, 'positional + named works';
    is_run $code, :args[<Shadow>                 ], { :out{not .contains: 'pass'}, :err(/'=<Shadow>'/) },
        'name of enum itself is not valid and usage message prints the name of the enum';
}

subtest '%*SUB-MAIN-OPTS<named-anywhere>', {
    plan 3;

    is_run ｢
        sub MAIN ($a, $b, :$c, :$d) { print "fail" }
        sub GENERATE-USAGE(|) { "pass" }
    ｣, :args[<1 --c=2 3 --d=4>], {:out(''), :err("pass\n"), :2status},
    'no opts set does not allow named args anywhere';

    is_run ｢
        (my %*SUB-MAIN-OPTS)<named-anywhere> = False;
        sub MAIN ($a, $b, :$c, :$d) { print "fail" }
        sub GENERATE-USAGE(|) { "pass" }
    ｣, :args[<1 --c=2 3 --d=4>], {:out(''), :err("pass\n"), :2status},
    '<named-anywhere> set to false does not allow named args anywhere';

    is_run ｢
        (my %*SUB-MAIN-OPTS)<named-anywhere> = True;
        sub MAIN ($a, $b, :$c, :$d) { print "pass" }
        sub GENERATE-USAGE(|) { print "fail" }
    ｣, :args[<1 --c=2 3 --d=4>], {:out<pass>, :err(''), :0status},
    '<named-anywhere> set to true allows named args anywhere';
}

# https://github.com/rakudo/rakudo/issues/3929
{
    is_run 'sub MAIN($a is rw) { }; sub GENERATE-USAGE(|) { print "usage" }', :args[],
      { :out<usage>, :err{ .contains("'is rw'") }, :2status },
      'Worry about "is rw" on parameters of MAIN';
}

# vim: expandtab shiftwidth=4
