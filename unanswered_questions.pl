#!/bin/env perl -w

use strict;
use warnings;

use Template;
use lib '.';
use FAQ;
use DBI;
use FindBin qw( $Bin );
use Mail::Mailer;
use Getopt::Long;
use Pod::Usage;

my ( %opts );
GetOptions( 
    \%opts, 
    qw( 
        help
        man
        email=s
        faq=s
    ) 
) or pod2usage( verbose => 0 );
$opts{help} && pod2usage( verbose => 1 );
$opts{man} && pod2usage( verbose => 2 );
my ( $faq ) = $opts{faq} || pod2usage( verbose => 0 );
FAQ::set_table( $faq );
my @unanswered_questions = FAQ->unanswered_questions;
exit unless @unanswered_questions;
my $subject = "UNANSWERED QUESTIONS IN $faq FAQ";
my ( $email ) = $opts{email};
if ( $email )
{
    my $mailer = Mail::Mailer->new() or die "Can't create Mail::Mailer object\n";
    $mailer->open( {
        'To'              => $email,
        'Subject'         => $subject,
    } ) or die "Can't open Mail::Mailer object\n";
    select( $mailer );
}
print "$subject\n", "-" x length( $subject ), "\n";
for ( @unanswered_questions )
{
    print "'", $_->question, "': submitted ", $_->submitted, "\n";
}

#------------------------------------------------------------------------------
#
# Start of POD
#
#------------------------------------------------------------------------------

=head1 NAME

    unanswered_questions.pl - a perl script for notifying unanswered questions from a FAQ

=head1 SYNOPSIS

unanswered_questions.pl
    --help
    --man
    --email [ email address ]
    --faq [ FAQ name ]

=head1  OPTIONS

=head2 email

Specify e-mail address or (comma / semicolon seperated) email addresses to notify of unanswered questions.

=head2 faq

Specify name of FAQ to check for unanswered questions.

Display

=head1 DESCRIPTION

=head1 AUTHOR

Ave Wrigley <Ave.Wrigley@itn.co.uk>

=head1 COPYRIGHT

Copyright (c) 2001 Ave Wrigley. All rights reserved. This program is free
software; you can redistribute it and/or modify it under the same terms as Perl
itself.

=cut

#------------------------------------------------------------------------------
#
# End of POD
#
#------------------------------------------------------------------------------

