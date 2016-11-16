package DataObj;

use warnings;
use strict;
use version; our $VERSION = qv('0.0.1');
use Readonly;
use Carp;
use Class::Std::Utils;
use List::MoreUtils qw(any);
use Log::Log4perl qw(:easy);
use Log::Log4perl::CommandLine qw(:all);
use MyX::Generic 0.0.3;
use UtilSY 0.0.2 qw(:all);


# set up the logging environment
my $logger = get_logger();

{
	# Usage statement
	Readonly my $NEW_USAGE => q{ new() };

	# Attributes #
	my %data_href_of;
	
	# Getters #
	sub get_feature;
	sub get_feature_names;
	sub get_data_href;

	# Setters #
	sub set_feature;
	sub set_data_href;

	# Others #
	sub to_string;



	###############
	# Constructor #
	###############
	sub new {
		my ($class, $arg_href) = @_;

		# Croak if calling new on already blessed reference
		croak 'Constructor called on existing object instead of class'
			if ref $class;

		# Make sure the required parameters are defined
		if ( any {!defined $_}

			) {
			MyX::Generic::Undef::Param->throw(
				error => 'Undefined parameter value',
				usage => $NEW_USAGE,
			);
		}

		# Bless a scalar to instantiate an object
		my $new_obj = bless \do{my $anon_scalar}, $class;

		# Set Attributes

		return $new_obj;
	}

	###########
	# Getters #
	###########
	sub get_feature {
		my ($self, $feature) = @_;
		
		# make sure the argument is defined
		check_defined($feature, "feature");
		
		return $data_href_of{ident $self}->{$feature};
	}
	
	sub get_feature_names {
		my ($self) = @_;
		
		my @arr = keys %{$data_href_of{ident $self}};
		
		return( \@arr );
	}
	
	sub get_data_href {
		my ($self) = @_;
		
		return $data_href_of{ident $self};
	}

	###########
	# Setters #
	###########
	sub set_feature {
		my ($self, $feature, $value) = @_;
		
		# check if the parameters are defined
		check_defined($feature, "feature");
		check_defined($value, "value");
		
		$data_href_of{ident $self}->{$feature} = $value;
		
		return 1;
	}
	
	sub set_data_href {
		my ($self, $href) = @_;
		
		# check if the parameter is defined
		check_defined($href, "href");
		
		$data_href_of{ident $self} = $href;
		
		return 1;
	}

	##########
	# Others #
	##########
	sub to_string {
		my ($self, $delim) = @_;
		
		if ( ! is_defined($delim, "delim") ) {
			$delim = ": ";
		}
		
		my $str = "";
		my $href = $self->get_data_href();
		
		foreach my $feat ( keys %{$href} ) {
			$str .= $feat . $delim . $href->{$feat} . "\n";
		}
		
		return $str;
	}
}

1; # Magic true value required at end of module
__END__

=head1 NAME

DataObj - A generic data container


=head1 VERSION

This document describes DataObj version 0.0.1


=head1 SYNOPSIS

    use DataObj;
	my $data = DataObj->new();

	# add data
	$data->set_feature("new_feature", "new_value");
	
	# get data
	$data->get_feature("new_feature");
	
	# get the names of all the features in the DataObj
	$data->get_feature_names();
  
  
=head1 DESCRIPTION

This is a generic data container (ie glorified hash).  I frequently use this
object to make a quick and dirty child object.  The child object will inherit
the functionality of the the DataObj, but it usually includes a few specific
methods.

For example, and object SummaryCounts can inherit DataObj.  A method "incrament"
can be added to increment a certain feature.

To implement Perl inheritance add the following line to the use statements:

use base qw(<PARENT CLASS>);

And add the following line in the constructor to bless the new object

my $new_obj = $class->SUPER::new($arg_href);


=head1 CONFIGURATION AND ENVIRONMENT
  
DataObj requires no configuration files or environment variables.


=head1 DEPENDENCIES

version
Readonly
Carp
Class::Std::Utils
List::MoreUtils qw(any)
Log::Log4perl qw(:easy)
Log::Log4perl::CommandLine qw(:all)
MyX::Generic
UtilSY 0.0.2 qw(:all)


=head1 INCOMPATIBILITIES

None reported.


=head1 METHODS

=over
	
	new
	get_feature
	get_feature_names
	get_data_href
	set_feature
	set_data_href
	to_string

=back

=head1 METHODS DESCRIPTION

=head2 new

	Title: new
	Usage: DataObj->new();
	Function: Build a DataObj
	Returns: DataObj
	Args: NA
	Throws: NA
	Comments: NA
	See Also: NA
	
=head2 get_feature

	Title: get_feature
	Usage: $obj->get_feature($feature)
	Function: Gets the value of a given feature
	Returns: Value of the given feature.  Could be any type.
	Args: -feature => feature name
	Throws: MyX::Generic::Undef::Param
	Comments: NA
	See Also: NA
	
=head2 get_feature_names

	Title: get_feature_names
	Usage: $obj->get_feature_names()
	Function: Returns aref of all features in the DataObj
	Returns: aref
	Args: NA
	Throws: NA
	Comments: NA
	See Also: NA
	
=head2 get_data_href

	Title: get_data_href
	Usage: $obj->get_data_href()
	Function: Returns href stored in the DataObj
	Returns: href
	Args: NA
	Throws: NA
	Comments: NA
	See Also: NA

=head2 set_feature

	Title: set_feature
	Usage: $obj->set_feature($feature, $value)
	Function: Set the value of a feature
	Returns: 1 on success
	Args: -feature => feature name
	      -value => feature value
	Throws: MyX::Generic::Undef::Param
	Comments: NA
	See Also: NA
	
=head2 set_data_href

	Title: set_data_href
	Usage: $obj->set_data_href($href)
	Function: Reset the data objec with the given href
	Returns: 1 on success
	Args: -href => href with new features and their values
	Throws: MyX::Generic::Undef::Param
	Comments: NA
	See Also: NA
	
=head2 to_string

	Title: to_string
	Usage: $obj->to_string($delimiter)
	Function: Returns the obect data in a string
	Returns: str
	Args: -delimiter => string delimiter between the name and value
	Throws: NA
	Comments: The default delimiter is ": "
	See Also: NA


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head1 TO DO

None

=head1 AUTHOR

Scott Yourstone  C<< scott.yourstone81@gmail.com >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2013, Scott Yourstone
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies, 
either expressed or implied, of the FreeBSD Project.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

