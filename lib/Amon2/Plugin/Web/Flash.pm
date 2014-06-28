package Amon2::Plugin::Web::Flash;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

use Amon2::Util;

sub init {
    my ($class, $c, $conf) = @_;
    my $webpkg = ref $c || $c;

    my $key = $conf->{session_key} || 'flash';
    my $new_key = $key . "_new";
    my $flash;
    my $new_flash;

    Amon2::Util::add_method($webpkg, flash => sub {
        my ($self, $flash_key, $value) = @_;

        # getter
        return $flash unless $flash_key;
        return $flash->{$flash_key} unless $value;

        # setter
        $new_flash->{$flash_key} = $value;
        return $value;
    });

    Amon2::Util::add_method($webpkg, flash_now => sub {
        my ($self, $flash_key, $value) = @_;
        # getter. same as flash
        return $self->flash($flash_key) unless $value;

        # setter
        $flash->{$flash_key} = $value;
        return $value;
    });

    Amon2::Util::add_method($webpkg, flash_discard => sub {
        my ($self, $flash_key, $value) = @_;
        unless ($flash_key) {
            $flash = {};
            return;
        }
        undef $flash->{$flash_key};
    });

    $c->add_trigger(BEFORE_DISPATCH => sub {
        my $c = shift;
        $c->session->remove($key);
        $flash = $c->session->get($new_key) || {};
        $new_flash = {};
    });

    $c->add_trigger(AFTER_DISPATCH => sub {
        my $c = shift;
        $c->session->set($new_key, $new_flash);
    });
}

1;

__END__

=head1 NAME

RoR like flash

=head1 SYNOPSIS

   # in your Web.pm
   __PACKAGE__->load_plugins(
        'Web::Flash', # must be loaded *BEFORE* HTTP Session
        'Web::HTTPSession', 
   );

   $c->flash(key => 'value'); # set
   $c->flash('key') # get
   my $hashref = $c->flash; # get all key-value pair

   $c->flash_now(key => 'value');

   $c->flash_discard('key');
   $c->flash_discard; # discard all


=head1 DESCRIPTION

Import from Ruby on Rails.

=head1 AUTHOR

Yoshimasa Ueno

=head1 COPYRIGHT

Copyright 2012- Yoshimasa Ueno


=head1 LICENSE

Same as Perl.

=head1 NO WARRANTY

This software is provided "as-is," without any express or implied
warranty. In no event shall the author be held liable for any damages
arising from the use of the software.

=head1 SEE ALSO

=cut
