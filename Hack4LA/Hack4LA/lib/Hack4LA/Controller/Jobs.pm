package Hack4LA::Controller::Jobs;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::REST'; }


=head1 NAME

Hack4LA::Controller::Jobs - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

	$self->status_bad_request(
		$c,
		message => "I have no memory of this place."
	);
}

sub job_list : Path('/jobs/job_list') : Args(0) : ActionClass('REST') {}

sub job_location : Path('/jobs/job_location') : Args(0) : ActionClass('REST') {
	my ( $self, $c ) = @_;
	my $params = {%{$c->req->params}};
	delete $params->{'content-type'};

	my $search_params = {
		(defined $params->{street_address} ? ( street_address => { -like => '%' . $params->{street_address} . '%' } ) : ()),
		(defined $params->{city} ? ( city => { -like => '%' . $params->{city} . '%' } ) : ()),  
		(defined $params->{state} ? ( state => $params->{state} ) : ()),
		(defined $params->{country} ? ( country => $params->{country} ) : ()),
	};

	$c->stash->{'job_loc'} = $c->model("DB::Job")->search($search_params);
}

sub job_location_GET {
	my ( $self, $c ) = @_;
	
	my $job_loc = $c->stash->{job_loc};

	my @location = map { $_->street_address . " " . $_->city . " " . $_->state . ", " .$_->country } $job_loc->all;

	if( defined($job_loc) ) {
		$self->status_ok(
			$c,
			entity => {
				error => "0",
				message => {
					count => scalar @location,
					location => \@location,
				}
			}
		);
	} else {
		$self->status_not_found(
			$c,
			message => "Could not load job locations.",
		);
	}
}

sub job_list_GET {
	my ( $self, $c ) = @_;

	my $params = $c->req->params;

	my $search_params = {
		(defined $params->{street_address} ? ( street_address => { -like => '%' . $params->{street_address} . '%' } ) : ()),
		(defined $params->{city} ? ( city => { -like => '%' . $params->{city} . '%' } ) : ()),
		(defined $params->{state} ? ( state => $params->{state} ) : ()),
		(defined $params->{country} ? ( country => $params->{country} ) : ()),
		(defined $params->{title} ? ( title => { -like => '%' . $params->{title} . '%' } ) : ()),
		(defined $params->{description} ? ( description => { -like => '%' . $params->{description} . '%' } ) : ()),
	};

	my %job_list;
	my @jobs = $c->model("DB::Job")->search($search_params)->all;

	$self->status_ok($c, entity => { error => "0", results => scalar @jobs, message => \@jobs });
}

sub single_job : Path('/jobs/job_list') : Args(1) : ActionClass('REST') {
	my ($self, $c, $job_id ) = @_;

	$c->stash->{'job'} = $c->model("DB::Job")->find($job_id);
}

sub single_job_GET {
	my ( $self, $c, $job_id ) = @_;

	my $job = $c->stash->{job};

	if( defined($job) ) {
		$self->status_ok(
			$c,
			entity => {
				error => "0",
				message => {
				job_id => $job->job_id,
				country => $job->country,
				date => $job->date,
				description => $job->description,
				state => $job->state,
				url => $job->url,
				category => $job->category,
				title => $job->title,
				street_address => $job->street_address,
				company => $job->company,
				}
			}
		);
	}
	else
	{
		$self->status_not_found( $c, message => "Could not find the specified job." );
	}
}

sub single_job_POST {
	my ( $self, $c, $job_id ) = @_;

	my $new_job_data = $c->req->data;

	warn ref $new_job_data;
	use Data::Dumper;
	warn Dumper($new_job_data);

	if( !defined($new_job_data) ) {
		return $self->status_bad_request( $c, message => "You must provide a job to create or modify." );
	}

	if ( $new_job_data->{'job_id'} ne $job_id ) {
		return $self->status_bad_request(
			$c,
			message => "Cannot create of modify job "
			. $new_job_data->{'job_id'} . " at "
			. $c->req->uri->as_string
			. "; the job_id does not match!"
		);
	}

	foreach my $required (qw(job_id description title)) {
		return $self->status_bad_request( $c, message => "Missing required field: " . $required ) if !exists( $new_job_data->{$required} );
	}

	my $job = $c->model("DB::Job")->update_or_create($new_job_data);

	if ( $c->stash->{'job'} ) {
		$self->status_ok( $c, entity => { message => "Job info has been updated." }, );
	} else {
		$self->status_created(
			$c,
			location => $c->req->uri->as_string,
			entity => { message => "New job has been created." },
		);
	}
}

*single_job_PUT = *single_job_POST;

sub single_job_DELETE {
	my ( $self, $c, $job_id ) = @_;

	my $job = $c->stash->{'job'};

	if( defined($job) ) {
		$job->delete;
		$self->status_ok(
			$c,
			entity => { error => "Job has been deleted." },
		);
	} else {
		$self->status_not_found( $c, message => "Cannot delete non-existent job." );
	}
}


=head1 AUTHOR

Grigor Karavardanyan

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
