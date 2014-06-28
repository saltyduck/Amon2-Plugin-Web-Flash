use strict;
use warnings;
use Test::More;

use Plack::Request;
use Plack::Test;
use Test::Requires 'Amon2::Lite';

use HTTP::Session::State::URI;

my ($session_id, $session_key) = (undef, 'sid');
my $state = HTTP::Session::State::URI->new(
    session_id_name => $session_key,
);

my $app = do {
    package MyApp::Web;
    use Amon2::Lite;

    sub load_config { +{} }

    __PACKAGE__->template_options(
        syntax => 'Kolon',
    );

    __PACKAGE__->load_plugins(
        'Web::Flash',
        'Web::HTTPSession' => {
            state => $state,
            store => 'OnMemory',
        },
    );

    get '/set' => sub {
        my $c = shift;
        $session_id = $c->session->{session_id};
        $c->flash(honey => "Honey");
        $c->render('index.tx', +{
            flash => $c->flash,
        });
    };

    get '/use' => sub {
        my $c = shift;
        $session_id = $c->session->{session_id};
        $c->render('index.tx', +{
            flash => $c->flash,
        });
    };

    get '/after' => sub {
        my $c = shift;
        $session_id = $c->session->{session_id};
        $c->render('index.tx', +{
            flash => $c->flash,
        });
    };

    get '/now' => sub {
        my $c = shift;
        $session_id = $c->session->{session_id};
        $c->flash_now(honey => "Honey");
        $c->render('index.tx', +{
            flash => $c->flash,
        });
    };

    get '/discard' => sub {
        my $c = shift;
        $session_id = $c->session->{session_id};
        $c->flash_now(honey => "Honey");
        $c->flash_discard;
        $c->render('index.tx', +{
            flash => $c->flash,
        });
    };

    __PACKAGE__->to_app;
};


subtest 'set and get and turn' => sub {
    test_psgi
        app => $app,
        client => sub {
            my $cb = shift;
            {
                my $res = $cb->(HTTP::Request->new(GET => "http://localhost/set"));
                note $res->content;
                unlike $res->content, qr/honey is Honey/;
            }

            {
                my $res = $cb->(HTTP::Request->new(GET => "http://localhost/use?$session_key=$session_id"));
                note $res->content;
                like $res->content, qr/honey is Honey/;
            }

            {
                my $res = $cb->(HTTP::Request->new(GET => "http://localhost/after?$session_key=$session_id"));
                note $res->content;
                unlike $res->content, qr/honey is Honey/;
            }
        };
};

subtest 'now' => sub {
    test_psgi
        app => $app,
        client => sub {
            my $cb = shift;
            {
                my $res = $cb->(HTTP::Request->new(GET => "http://localhost/now"));
                note $res->content;
                like $res->content, qr/honey is Honey/;
            }
        };
};

subtest 'discard' => sub {
    test_psgi
        app => $app,
        client => sub {
            my $cb = shift;
            {
                my $res = $cb->(HTTP::Request->new(GET => "http://localhost/discard"));
                note $res->content;
                unlike $res->content, qr/honey is Honey/;
            }
        };
};


done_testing;

package MyApp::Web;
__DATA__

@@ index.tx
: for $flash.keys() -> $k {
<: $k :> is <: $flash[$k] :>
: }
