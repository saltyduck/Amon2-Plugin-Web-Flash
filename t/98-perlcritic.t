use strict;
use Test::More;
eval q{ use Test::Perl::Critic (-profile => 't/perlcriticrc') };
plan skip_all => "Test::Perl::Critic is not installed." if $@;
all_critic_ok("lib");

