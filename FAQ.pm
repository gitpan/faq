package FAQ;

use strict;
use warnings;

use base 'Class::DBI';

sub set_table
{
    my $table = shift;
    FAQ->set_db('Main', 'dbi:mysql:faq', 'faq', 'faq' );
    FAQ->table( $table );
    FAQ->columns( Primary => qw( qid ) );
    FAQ->columns( Other => qw( submitted last_modified answered question answer ) );
}

__PACKAGE__->add_constructor( unanswered_questions => 'answer IS NULL' );

1;
