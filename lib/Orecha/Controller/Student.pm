package Orecha::Controller::Student;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use String::Util qw(trim);

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Orecha::Controller::Student - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Orecha::Controller::Student in Student.');
}

=encoding utf8

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

=head2 base 
Can place common logic to start chained dispatch here 
=cut
 
sub base :Chained('/') :PathPart('student') :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash(resultset => $c->model('DB::Student'));
}

=head2 list
Fetch all student objects and pass to student_list.tt2
=cut

sub list :Chained('base') :PathPart('list') :Args(0) {
    my ($self, $c) = @_;

    $c->stash(title => 'Student List');
    $c->stash(students => [$c->model('DB::Student')->all]);

    $c->stash(template => 'students/student_list.tt2');
}

=head2 create_form
Display form
=cut

sub create_form :Local :Args(0){
    my ($self, $c) = @_;

    $c->stash(title => 'Create Student');
    $c->stash(template => 'students/create_form.tt2');
}

=head2 create_form
Take information from form and add to database
=cut

sub create_form_do :Chained('base') :PathPart('create_form_do') :Args(0) {
    my ($self, $c) = @_;
    $c->stash(title => 'Create Student');
    $c->stash(template => 'students/create_form.tt2');
    
    my $error_check = 0;
    my %error_list = (
        'full_name'    => 'none',
        'day_of_birth' => 'none',
        'gender'       => 'none',
        'school'       => 'none',
        'college'      => 'none'
    );

    my $full_name    = $c->request->params->{full_name};
    my $day_of_birth = $c->request->params->{day_of_birth}; #date of birth
    my $gender       = $c->request->params->{gender};
    my $school       = $c->request->params->{school};
    my $college      = $c->request->params->{college};

    if ($full_name eq '') {
        $error_list{'full_name'} = 'empty';
        $error_check = 1;
    }
    if ($day_of_birth eq '') {
        $error_list{'day_of_birth'} = 'empty';
        $error_check = 1;
    }
    if ($gender eq '') {
        $error_list{'gender'} = 'empty';
        $error_check = 1;
    }
    if ($school eq '') {
        $error_list{'school'} = 'empty';
        $error_check = 1;
    }
    if ($college eq '') {
        $error_list{'college'} = 'empty';
        $error_check = 1;
    }
    
    if ($error_check == 1) {  #error
        $c->stash(
            full_name_err    => $error_list{'full_name'},
            day_of_birth_err => $error_list{'day_of_birth'},
            gender_err       => $error_list{'gender'},
            school_err       => $error_list{'school'},
            college_err      => $error_list{'college'}
        );

        $c->stash(  #temporary
            full_name_temp    => $full_name,
            day_of_birth_temp => $day_of_birth,
            gender_temp       => $gender,
            school_temp       => $school,
            college_temp      => $college
        );
    } else {
        my $student = $c->model('DB::Student')->create({
            full_name    => $full_name,
            day_of_birth => $day_of_birth,
            gender       => $gender,
            school       => $school,
            college      => $college
        });

        $c->response->redirect($c->uri_for($c->controller('student')->action_for('list'), {status_msg => "Student has been created"}));
    }
}

=head2 object
Fetch the specified student object based on the student ID
=cut

sub id :Chained('base') :PathPart('') :CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->stash(student => $c->model('DB::Student')->find($id));
}

=head2 update
Display update form with student's details
=cut

sub update :Chained('id') :PathPart('update') :Args(0) {
    my ($self, $c) = @_;

    $c->stash(title => 'Update Student');
    $c->stash(template => 'students/update.tt2');

    my $id = $c->request->captures->[0];
    
    my $error_check = 0;
    my %error_list = (
        'full_name'    => 'none',
        'day_of_birth' => 'none',
        'gender'       => 'none',
        'school'       => 'none',
        'college'      => 'none'
    );
    
    my $full_name    = $c->request->params->{full_name};
    my $day_of_birth = $c->request->params->{day_of_birth};
    my $gender       = $c->request->params->{gender};
    my $school       = $c->request->params->{school};
    my $college      = $c->request->params->{college};
        
    # open(my $LOG, '>>', 'C:/TEMP/cat.log') || die print "Can not open file $!";
    # print $LOG Dumper($full_name);
    # close($LOG);

    #View details before update
    if (defined $full_name) {
        $full_name    = $c->request->params->{full_name};
        $day_of_birth = $c->request->params->{day_of_birth};
        $gender       = $c->request->params->{gender};
        $school       = $c->request->params->{school};
        $college      = $c->request->params->{college};
    } else {
        my $student = $c->model('DB::Student')->find($id);
        
        $c->stash(
            full_name_temp    => $student->get_column('full_name'),
            day_of_birth_temp => $student->get_column('day_of_birth'),
            gender_temp       => $student->get_column('gender'),
            school_temp       => $student->get_column('school'),
            college_temp      => $student->get_column('college')
        );
        return;
    }
    
    if ($full_name eq '') {
        $error_list{'full_name'} = 'empty';
        $error_check = 1;
    }
    if ($day_of_birth eq '') {
        $error_list{'day_of_birth'} = 'empty';
        $error_check = 1;
    }
    if ($gender eq '') {
        $error_list{'gender'} = 'empty';
        $error_check = 1;
    }
    if ($school eq '') {
        $error_list{'school'} = 'empty';
        $error_check = 1;
    }
    if ($college eq '') {
        $error_list{'college'} = 'empty';
        $error_check = 1;
    }

    if ($error_check == 1) {        
        $c->stash(
            full_name_err    => $error_list{'full_name'},
            day_of_birth_err => $error_list{'day_of_birth'},
            gender_err       => $error_list{'gender'},
            school_err       => $error_list{'school'},
            college_err      => $error_list{'college'}
        );
        $c->stash(
            full_name_temp    => $full_name,
            day_of_birth_temp => $day_of_birth,
            gender_temp       => $gender,
            school_temp       => $school,
            college_temp      => $college
        );
        return;
    } else {
        $c->stash->{student}->update({
            'full_name'    => $full_name,
            'day_of_birth' => $day_of_birth,
            'gender'       => $gender,
            'school'       => $school,
            'college'      => $college
        });

        $c->response->redirect($c->uri_for($self->action_for('list'), {status_msg => "Student updated"}));
    }
}

=head2 delete
Delete a student
=cut

sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{student}->delete;
    $c->response->redirect($c->uri_for($self->action_for('list'), {status_msg => "Student deleted"}));
}

__PACKAGE__->meta->make_immutable;

1;
