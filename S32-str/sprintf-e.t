use v6.e.PREVIEW;
#BEGIN %*ENV<PERL6_TEST_DIE_ON_FAIL> = True;
use Test;

# Test combinations of flags for "%e" and "%E".  The @info array is intialized
# with the flags (as a string), the size/precision specification (either a
# string or a # number), and the expected strings for the values 0, 27.1 and
# -2.71.  The flags values will be expanded to all possible permutations to
# ensure that the order of the flags is irrelevant.  Each flag permutation is
# combined with the size/permutation value to create a proper format string.
# Each test will be done twice, once for "e" and once for "E".

#                             0 ,           27.1 ,          -2.71 ;
my @info = ( # |----------------|----------------|----------------|
             # no size or size explicitely 0
       '',   '',  "0.000000e+00",  "2.710000e+01", "-2.710000e+00",
      ' ',   '', " 0.000000e+00", " 2.710000e+01", "-2.710000e+00",
      '0',   '',  "0.000000e+00",  "2.710000e+01", "-2.710000e+00",
     '0 ',   '', " 0.000000e+00", " 2.710000e+01", "-2.710000e+00",
      '+',   '', "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
     '+ ',   '', "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
     '+0',   '', "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
    '+0 ',   '', "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
      '-',   '',  "0.000000e+00",  "2.710000e+01", "-2.710000e+00",
     '-+',   '', "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
     '- ',   '', " 0.000000e+00", " 2.710000e+01", "-2.710000e+00",
    '-+ ',   '', "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
     '-0',   '',  "0.000000e+00",  "2.710000e+01", "-2.710000e+00",
    '-+0',   '', "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
    '-0 ',   '', " 0.000000e+00", " 2.710000e+01", "-2.710000e+00",
   '-+0 ',   '', "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",

             # no size, precision 0
       '', '.0',         "0e+00",         "3e+01",        "-3e+00",
      ' ', '.0',        " 0e+00",        " 3e+01",        "-3e+00",
      '0', '.0',         "0e+00",         "3e+01",        "-3e+00",
     '0 ', '.0',        " 0e+00",        " 3e+01",        "-3e+00",
      '+', '.0',        "+0e+00",        "+3e+01",        "-3e+00",
     '+ ', '.0',        "+0e+00",        "+3e+01",        "-3e+00",
     '+0', '.0',        "+0e+00",        "+3e+01",        "-3e+00",
    '+0 ', '.0',        "+0e+00",        "+3e+01",        "-3e+00",
      '-', '.0',         "0e+00",         "3e+01",        "-3e+00",
     '-+', '.0',        "+0e+00",        "+3e+01",        "-3e+00",
     '- ', '.0',        " 0e+00",        " 3e+01",        "-3e+00",
    '-+ ', '.0',        "+0e+00",        "+3e+01",        "-3e+00",
     '-0', '.0',         "0e+00",         "3e+01",        "-3e+00",
    '-+0', '.0',        "+0e+00",        "+3e+01",        "-3e+00",
    '-0 ', '.0',        " 0e+00",        " 3e+01",        "-3e+00",
   '-+0 ', '.0',        "+0e+00",        "+3e+01",        "-3e+00",

             # 2 positions, usually doesn't fit
       '',    2,  "0.000000e+00",  "2.710000e+01", "-2.710000e+00",
      ' ',    2, " 0.000000e+00", " 2.710000e+01", "-2.710000e+00",
      '0',    2,  "0.000000e+00",  "2.710000e+01", "-2.710000e+00",
     '0 ',    2, " 0.000000e+00", " 2.710000e+01", "-2.710000e+00",
      '+',    2, "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
     '+ ',    2, "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
     '+0',    2, "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
    '+0 ',    2, "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
      '-',    2,  "0.000000e+00",  "2.710000e+01", "-2.710000e+00",
     '-+',    2, "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
     '- ',    2, " 0.000000e+00", " 2.710000e+01", "-2.710000e+00",
    '-+ ',    2, "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
     '-0',    2,  "0.000000e+00",  "2.710000e+01", "-2.710000e+00",
    '-0 ',    2, " 0.000000e+00", " 2.710000e+01", "-2.710000e+00",
    '-+0',    2, "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
   '-+0 ',    2, "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",

             # 8 positions, should always fit
       '',    8,  "0.000000e+00",  "2.710000e+01", "-2.710000e+00",
      ' ',    8, " 0.000000e+00", " 2.710000e+01", "-2.710000e+00",
      '0',    8,  "0.000000e+00",  "2.710000e+01", "-2.710000e+00",
     '0 ',    8, " 0.000000e+00", " 2.710000e+01", "-2.710000e+00",
      '+',    8, "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
     '+ ',    8, "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
     '+0',    8, "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
    '+0 ',    8, "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
      '-',    8,  "0.000000e+00",  "2.710000e+01", "-2.710000e+00",
     '-+',    8, "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
     '- ',    8, " 0.000000e+00", " 2.710000e+01", "-2.710000e+00",
    '-+ ',    8, "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
     '-0',    8,  "0.000000e+00",  "2.710000e+01", "-2.710000e+00",
    '-0 ',    8, " 0.000000e+00", " 2.710000e+01", "-2.710000e+00",
    '-+0',    8, "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",
   '-+0 ',    8, "+0.000000e+00", "+2.710000e+01", "-2.710000e+00",

             # 8 positions with precision, precision fits sometimes
       '',  8.2,      "0.00e+00",      "2.71e+01",     "-2.71e+00",
      ' ',  8.2,     " 0.00e+00",     " 2.71e+01",     "-2.71e+00",
      '0',  8.2,      "0.00e+00",      "2.71e+01",     "-2.71e+00",
     '0 ',  8.2,     " 0.00e+00",     " 2.71e+01",     "-2.71e+00",
      '+',  8.2,     "+0.00e+00",     "+2.71e+01",     "-2.71e+00",
     '+ ',  8.2,     "+0.00e+00",     "+2.71e+01",     "-2.71e+00",
     '+0',  8.2,     "+0.00e+00",     "+2.71e+01",     "-2.71e+00",
    '+0 ',  8.2,     "+0.00e+00",     "+2.71e+01",     "-2.71e+00",
      '-',  8.2,      "0.00e+00",      "2.71e+01",     "-2.71e+00",
     '-+',  8.2,     "+0.00e+00",     "+2.71e+01",     "-2.71e+00",
     '- ',  8.2,     " 0.00e+00",     " 2.71e+01",     "-2.71e+00",
    '-+ ',  8.2,     "+0.00e+00",     "+2.71e+01",     "-2.71e+00",
     '-0',  8.2,      "0.00e+00",      "2.71e+01",     "-2.71e+00",
    '-+0',  8.2,     "+0.00e+00",     "+2.71e+01",     "-2.71e+00",
    '-0 ',  8.2,     " 0.00e+00",     " 2.71e+01",     "-2.71e+00",
   '-+0 ',  8.2,     "+0.00e+00",     "+2.71e+01",     "-2.71e+00",

).map: -> $flags, $size, $r0, $r4, $rm {
    my @flat;
    @flat.append(
      '%' ~ $_ ~ $size ~ 'e',
      ($r0 => 0, $r4 => 27.1, $rm => -2.71)
    ) for $flags.comb.permutations>>.join;
    @flat.append(
      '%' ~ $_ ~ $size ~ 'e',
      ($r0 => 0, $r4 => 27.1, $rm => -2.71)
    ) for "#$flags".comb.permutations>>.join;
    |@flat
}

# tests using variable precision
@info.append( (
             # no size, precision 0
       '', '.*',         "0e+00",         "3e+01",        "-3e+00",
      ' ', '.*',        " 0e+00",        " 3e+01",        "-3e+00",
      '0', '.*',         "0e+00",         "3e+01",        "-3e+00",
     '0 ', '.*',        " 0e+00",        " 3e+01",        "-3e+00",
      '+', '.*',        "+0e+00",        "+3e+01",        "-3e+00",
     '+ ', '.*',        "+0e+00",        "+3e+01",        "-3e+00",
     '+0', '.*',        "+0e+00",        "+3e+01",        "-3e+00",
    '+0 ', '.*',        "+0e+00",        "+3e+01",        "-3e+00",
      '-', '.*',         "0e+00",         "3e+01",        "-3e+00",
     '-+', '.*',        "+0e+00",        "+3e+01",        "-3e+00",
     '- ', '.*',        " 0e+00",        " 3e+01",        "-3e+00",
    '-+ ', '.*',        "+0e+00",        "+3e+01",        "-3e+00",
     '-0', '.*',         "0e+00",         "3e+01",        "-3e+00",
    '-+0', '.*',        "+0e+00",        "+3e+01",        "-3e+00",
    '-0 ', '.*',        " 0e+00",        " 3e+01",        "-3e+00",
   '-+0 ', '.*',        "+0e+00",        "+3e+01",        "-3e+00",

).map: -> $flags, $size, $r0, $r1, $rm {
    my @flat;
    @flat.append(
      '%' ~ $_ ~ $size ~ 'e',
      ($r0 => (0,0), $r1 => (0,27.1), $rm => (0,-2.71))
   ) for $flags.comb.permutations>>.join;
    @flat.append(
      '%' ~ $_ ~ $size ~ 'e',
      ($r0 => (0,0), $r1 => (0,27.1), $rm => (0,-2.71))
   ) for "#$flags".comb.permutations>>.join;
   |@flat
} );

@info.append( (
             # 8 positions with precision, precision fits sometimes
       '', "8.*",      "0.00e+00",      "2.71e+01",     "-2.71e+00",
      ' ', "8.*",     " 0.00e+00",     " 2.71e+01",     "-2.71e+00",
      '0', "8.*",      "0.00e+00",      "2.71e+01",     "-2.71e+00",
     '0 ', "8.*",     " 0.00e+00",     " 2.71e+01",     "-2.71e+00",
      '+', "8.*",     "+0.00e+00",     "+2.71e+01",     "-2.71e+00",
     '+ ', "8.*",     "+0.00e+00",     "+2.71e+01",     "-2.71e+00",
     '+0', "8.*",     "+0.00e+00",     "+2.71e+01",     "-2.71e+00",
    '+0 ', "8.*",     "+0.00e+00",     "+2.71e+01",     "-2.71e+00",
      '-', "8.*",      "0.00e+00",      "2.71e+01",     "-2.71e+00",
     '-+', "8.*",     "+0.00e+00",     "+2.71e+01",     "-2.71e+00",
     '- ', "8.*",     " 0.00e+00",     " 2.71e+01",     "-2.71e+00",
    '-+ ', "8.*",     "+0.00e+00",     "+2.71e+01",     "-2.71e+00",
     '-0', "8.*",      "0.00e+00",      "2.71e+01",     "-2.71e+00",
    '-+0', "8.*",     "+0.00e+00",     "+2.71e+01",     "-2.71e+00",
    '-0 ', "8.*",     " 0.00e+00",     " 2.71e+01",     "-2.71e+00",
   '-+0 ', "8.*",     "+0.00e+00",     "+2.71e+01",     "-2.71e+00",

).map: -> $flags, $size, $r0, $r1, $rm {
    my @flat;
    @flat.append(
      '%' ~ $_ ~ $size ~ 'e',
      ($r0 => (2,0), $r1 => (2,27.1), $rm => (2,-2.71))
   ) for $flags.comb.permutations>>.join;
    @flat.append(
      '%' ~ $_ ~ $size ~ 'e',
      ($r0 => (2,0), $r1 => (2,27.1), $rm => (2,-2.71))
   ) for "#$flags".comb.permutations>>.join;
   |@flat
} );

plan @info/2;

for @info -> $format, @tests {
    subtest {
        plan 2 * @tests;

        for @tests {
            is-deeply sprintf($format, |.value), .key,
              qq/sprintf("$format",{.value.list.join(",")}) eq '{.key}'/;
            is-deeply sprintf($format.uc, |.value), .key.uc,
              qq/sprintf("{$format.uc}",{.value.list.join(",")}) eq '{.key.uc}'/;
        }
    }, "Tested '$format'";
}

# vim: expandtab shiftwidth=4
