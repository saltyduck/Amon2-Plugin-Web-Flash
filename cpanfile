requires 'Amon2';
requires 'Amon2::Plugin::Web::HTTPSession';

on 'test' => sub {
    requires 'Amon2::Lite';
    requires 'HTML::StickyQuery'; # needs for HTTP::Session::State::URI
    requires 'HTTP::Session::State::URI';
    requires 'Plack::Request';
    requires 'Plack::Test';
    requires 'Test::Requires';
};
