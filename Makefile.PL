use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Amon2::Plugin::Web::Flash',
    VERSION_FROM      => 'lib/Amon2/Plugin/Web/Flash.pm', # finds $VERSION
    PREREQ_PM         => { # e.g., Module::Name => 1.1
        'Test::Base' => 0,
        'Amon2::Util' => 0,
    },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Amon2/Plugin/Web/Flash.pm', # retrieve abstract from module
       AUTHOR         => 'Yoshimasa Ueno') : ()),
    # EXE_FILES => [ 'bin/my-script.pl' ], # scripts to be installed.
);

