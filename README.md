# NAME

Amon2::Plugin::Web::Flash - Ruby on Rails flash for Amon2

# SYNOPSIS

    # In your Web.pm
    __PACKAGE__->load_plugins(
         'Web::Flash', # must be loaded *BEFORE* HTTP Session
         'Web::HTTPSession',
    );

    # In your controller
    $c->flash(success => 'ok'); # Set a data exposed in the next request

    # At the controller of the next request
    $c->flash('success') # You got 'ok'

# DESCRIPTION

This plugin provides a way to pass data between request. Anything
placed in flash is exposed in the next request and then deleted.

This is a clone of Ruby on Rails flash.

# METHODS

## flash

    $c->flash(key => 'value'); # set
    $c->flash('key') # get
    my $hashref = $c->flash; # get all key-value pair

The data you set can be retrieved during the processing of the next
request.

## flash\_now

    $c->flash_now(key => 'value');

Unlike flash, the set data can be retrieved during the processing of
the current request.

## flash\_discard

    $c->flash_discard('key');
    $c->flash_discard; # discard all

Delete the flash data set in the current request.

# AUTHOR

Yoshimasa Ueno

# COPYRIGHT

Copyright 2014- Yoshimasa Ueno

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# NO WARRANTY

This software is provided "as-is," without any express or implied
warranty. In no event shall the author be held liable for any damages
arising from the use of the software.

# SEE ALSO

[Amon2](https://metacpan.org/pod/Amon2)
