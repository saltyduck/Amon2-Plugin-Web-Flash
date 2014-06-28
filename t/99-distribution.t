use Test::More;
eval q{ use Test::Distribution not => [ qw/description podcover/ ]; };
if ($@) {
  plan skip_all => "Test::Distribution required for testing distribution";
}
