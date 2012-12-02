use utf8;
package Remainder::Schema::Result::RemainderMemo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Remainder::Schema::Result::RemainderMemo

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

=head1 TABLE: C<RemainderMemo>

=cut

__PACKAGE__->table("RemainderMemo");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 userid

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 memo

  data_type: 'text'
  is_nullable: 0

=head2 tag

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 rm

  data_type: 'integer'
  is_nullable: 0

=head2 fromtime

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 totime

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 days

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 notification

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 importance

  data_type: 'integer'
  is_nullable: 1

=head2 created

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 updated

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "userid",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "memo",
  { data_type => "text", is_nullable => 0 },
  "tag",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "rm",
  { data_type => "integer", is_nullable => 0 },
  "fromtime",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "totime",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "days",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "notification",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "importance",
  { data_type => "integer", is_nullable => 1 },
  "created",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "updated",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-02 11:20:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1U7aNN1M+k3uv5eIj+etBQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
