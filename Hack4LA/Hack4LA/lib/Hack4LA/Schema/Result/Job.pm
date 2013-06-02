use utf8;
package Hack4LA::Schema::Result::Job;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Hack4LA::Schema::Result::Job

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<jobs>

=cut

__PACKAGE__->table("jobs");

=head1 ACCESSORS

=head2 job_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 country

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 date

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 state

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 city

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 url

  data_type: 'varchar'
  is_nullable: 1
  size: 512

=head2 category

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 title

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 128

=head2 company

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 referencenumber

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 create_time

  data_type: 'integer'
  is_nullable: 1

=head2 edit_time

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "job_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "country",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "date",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "state",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "city",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "url",
  { data_type => "varchar", is_nullable => 1, size => 512 },
  "category",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "street_address",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "title",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 128 },
  "company",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "referencenumber",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "create_time",
  { data_type => "integer", is_nullable => 1 },
  "edit_time",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</job_id>

=back

=cut

__PACKAGE__->set_primary_key("job_id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-06-01 13:59:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KcOX420pll+dSUK4jO982A

sub TO_JSON {
  my ($self) = @_;
  return {
  	job_id => $self->job_id,
  	country => $self->country,
  	date => $self->date,
  	description => $self->description,
	street_address => $self->street_address,
  	state => $self->state,
  	city => $self->city,
  	url => $self->url,
  	category => $self->category,
  	title => $self->title,
  	company => $self->company,
  	referencenumber => $self->referencenumber,
  	create_time => $self->create_time,
  	edit_time => $self->edit_time,
  };
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
