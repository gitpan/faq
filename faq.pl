#!/usr/local/bin/perl

$VERSION = '0.002';

use strict;
use warnings;

use Template;
use FAQ;
use DBI;
use CGI::Lite;
use POSIX qw( strftime );
use File::Spec;

$| = 1; 
print "Content-Type: text/html\n\n"; 
my $tmpdir = File::Spec->tmpdir();
open( STDERR, ">>$tmpdir/faq.log" );
my %params = CGI::Lite->new()->parse_form_data();
warn "PARAMS:\n\n", map "\t$_ = $params{$_}\n", keys %params;
my $script = $ENV{SCRIPT_NAME};
warn "SCRIPT_NAME: $script\n";
my $path_info = $ENV{PATH_INFO};
my $dbh = DBI->connect( 'dbi:mysql:faq', 'faq', 'faq' );
my $user = $script =~ /admin/ ? 'admin' : '';
my $action = $params{action};
warn "ACTION: $action\n" if $action;
my $table = $params{table};
my $qid = $params{qid};
if ( $action and $action eq 'New FAQ' and $table )
{
    $dbh->do( <<SQL );
CREATE TABLE `$table` (
`question` text NOT NULL,
`answer` text,
`submitted` datetime NOT NULL default '0000-00-00 00:00:00',
`answered` datetime NOT NULL default '0000-00-00 00:00:00',
`last_modified` datetime NOT NULL default '0000-00-00 00:00:00',
`qid` int(11) NOT NULL auto_increment,
PRIMARY KEY  (`qid`)
) TYPE=MyISAM; 
SQL
}
if ( $action and $action eq 'Delete FAQ' and $table )
{
    $dbh->do( "DROP TABLE IF EXISTS $table" );
}
my @tables = $dbh->tables();
warn "tables: @tables\n";
my ( $curr_table );
( undef, $curr_table ) = split( '/', $path_info ) if $path_info;
warn "current table: $curr_table\n" if $curr_table;
my @questions;
if ( $curr_table )
{
    FAQ::set_table( $curr_table );
    if ( my $new_question = $params{new_question} )
    {
        FAQ->create( 
            { 
                question => $new_question,
                submitted => strftime( '%Y-%m-%d %H:%M:%S', localtime ),
            } 
        );
    }
    eval {
        die "no action" unless $action;
        die "no qid" unless $qid;
        my $question = FAQ->retrieve( qid => $qid );
        die "no question" unless $question;
        $question->delete if $action eq 'Delete Question';
        my $now = strftime( '%Y-%m-%d %H:%M:%S', localtime );
        if ( $action eq "Update Answer" )
        {
            unless ( $question->answer )
            {
                $question->answered( $now );
            }
            $question->answer( $params{answer} );
        }
        $question->question( $params{question} ) if $action eq "Update Question";
        $question->last_modified( $now );
        $question->update;
    };
    @questions = FAQ->retrieve_all();
}
my $template = Template->new();
my $template_file = "faq.tmpl";
$template->process( 
    $template_file, 
    { 
        questions => \@questions,
        tables => \@tables,
        table => $curr_table,
        script => $script,
        user => $user 
    } 
) || die $template->error(); 

=head1 NAME

faq - a web based FAQ builder

=head1 SYNOPSIS

        # create a database called 'faq' in mysql

        > mysqladmin create faq

        # if you like ... create the faq FAQ
        
        > mysql faq < faq.sql

        # in apache httpd.conf

        ScriptAlias /faq /path/to/faq/faq.pl
        ScriptAlias /faqadmin /path/to/faq/faq.pl
        <Location /faqadmin>
            AuthType Basic
            AuthUserFile /path/to/faq/faq.auth
            AuthName "FAQ Administration"
            require admin
        </Location>

        # if you want to have a seperate authorisation for the foo FAQ ...

        <Location /faqadmin/foo>
            AuthType Basic
            AuthUserFile /path/to/faq/faq.auth
            AuthName "Foo FAQ Administration"
            require foo
        </Location>

        # if you want to be notified of any unanswered questions ...
        # in crontab

        0 9 * * 1-5 unanswered_questions.pl --email you@company.com --faq foo

=head1 DESCRIPTION

This is a simple CGI script for managing a web based FAQ. It uses mysql to
store the questions and answers in the FAQ. It is pretty staightforward -
basically, anyone can submit a new question through the "Add Question" form.
There is also an admin user, that you should set up using HTTP authentication
(see L<"SYNOPIS">). 

You login as admin user by clicking on the "Login" button,
and entering the authentication details that you have set up. The admin
interface allows FAQ administrators to add or delete FAQs, answer questions,
edit answers, or delete questions. If you want to set up different
administrators on a per FAQ basis, you can do this because of the URL structure
of the interface (see example in L<"SYNOPSIS">).

Included in the distribution is a utility script, L<unanswered_questions.pl>, which you can use - for example using cron - to alert you of any unanswered questions in a particular FAQ.

=head1 SCRIPT CATEGORIES

CGI

=head1 PREREQUISITES

C<Template>
C<DBI>
C<DBD::Mysql>
C<CGI::Lite>
C<POSIX>
C<File::Spec>

=head1 AUTHOR

Ave Wrigley <Ave.Wrigley@itn.co.uk>

=head1 COPYRIGHT

Copyright (c) 2004 Ave Wrigley. All rights reserved. This program is free
software; you can redistribute it and/or modify it under the same terms as Perl
itself.

=cut
