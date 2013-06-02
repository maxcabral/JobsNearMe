package Hack4LA::Controller::Jobs;

use Moose;
use namespace::autoclean;

use Hack4LA::Util::Api;

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

sub create : Local{
	my ( $self, $c ) = @_;

	$c->response->body("INSERTED");
}

sub job_list : Path('/jobs/job_list') : Args(0) : ActionClass('REST') {}

sub job_list_GET {
	my ( $self, $c ) = @_;

	my %job_list;
	my @jobs = $c->model("DB::Job")->search()->all;

	$self->status_ok($c, entity => \@jobs );
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
				job_id => $job->job_id,
				country => $job->country,
				date => $job->date,
				description => $job->description,
				state => $job->state,
				url => $job->url,
				category => $job->category,
				title => $job->title,
				company => $job->company,
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

	my $job = $c->model("DB::Job")->update_or_create(
		job_id => $new_job_data->{'job_id'},
		description => $new_job_data->{'description'},
		title => $new_job_data->{'title'},
	);

	my $return_entity = {
		job_id => $job->job_id,
		description => $job->description,
		title => $job->title,
	};

	if ( $c->stash->{'job'} ) {
		$self->status_ok( $c, entity => $return_entity, );
	} else {
		$self->status_created(
			$c,
			location => $c->req->uri->as_string,
			entity => $return_entity,
		);
	}
}

sub single_job_DELETE {
	my ( $self, $c, $job_id ) = @_;

	my $job = $c->stash->{'job'};

	if( defined($job) ) {
		$job->delete;
		$self->status_ok(
			$c,
			message => "Job has been deleted.",
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
