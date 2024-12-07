use Test;

plan 1;

my $dir = $?FILE.IO.sibling("sequence");
my $script = $dir.child("foo.raku");
my $module = $dir.child("Foo.rakumod");

#?rakudo.jvm todo "got ''"
is run($*EXECUTABLE, $script, :out).out.slurp(:close), "⎽ ⎼ ⎻ ⎺",
  "did the module get precompiled ok and return '⎽ ⎼ ⎻ ⎺'";

# vim: expandtab shiftwidth=4
