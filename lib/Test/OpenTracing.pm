package Test::OpenTracing;

our $VERSION = '0.01_00';

package Test::OpenTracing::CanInterface;

use strict;
use warnings;

use Object::Tiny qw/interface_name interface_methods/;

use Scalar::Util qw/blessed/;

use Test::Builder;

sub run_tests{
    my $self = shift;
    my $this = shift;
    
    my $test_class_name = $self->test_class_name($this);
    
    my $Test = Test::Builder->new;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    no strict qw/refs/;
    my @failures;
    foreach my $test_method ( sort @{$self->interface_methods} ) {
        unless ( $this->can($test_method) ) {
            $Test->diag("$test_class_name->can('$test_method') failed");
            push @failures, $test_method;
        }
    }
    
    my $test_message = $self->test_message( $this );
    my $ok = scalar @failures ? 0 : 1;
    return $Test->ok( $ok, $test_message );
    
}

sub test_class_name {
    my $self = shift;
    my $this = shift;
    
    return blessed( $this ) // "$this";
}

sub test_message {
    my $self = shift;
    my $this = shift;
    
    my $test_class_name = $self->test_class_name($this);
    my $interface_name = $self->interface_name;
    
    return "${test_class_name}->can_interface( '$interface_name' )"
}



1;
