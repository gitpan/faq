use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'faq',
    'VERSION_FROM'	=> 'FAQ.pm', # finds $VERSION
    'PREREQ_PM'		=> {
    Class::DBI => 0,
    Template => 0,
    FAQ => 0,
    DBI => 0,
    DBD::mysql => 0,
    CGI::Lite => 0,
    }, # e.g., Module::Name => 1.1
);
