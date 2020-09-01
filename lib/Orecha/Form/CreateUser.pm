package Orecha::Form::CreateUser;

use Moo;
use Data::MuForm::Meta;

extends 'Data::MuForm::Model::DBIC';

has_field 'full_name' => (
	type => 'Text',
	unique => 1,
	minlength => 3,
    maxlength => 30,
	render_args => {
		element_attr => {
			class => 'form-control'
		},
		error_class => 'field-validation-error'
	},	
);

has_field 'day_of_birth' => (
	type => 'Date',
	minlength => 10,
    maxlength => 10,
	render_args => {
		element_attr => {
			class => 'form-control'
		},
		error_class => 'field-validation-error'
	},	
);

has_field 'gender' => (
	type => 'Text',
	minlength => 4,
    maxlength => 6,
	render_args => {
		element_attr => {
			class => 'form-control'
		},
		error_class => 'field-validation-error'
	},	
);

has_field 'school' => (
	type => 'Text',
	minlength => 3,
    maxlength => 30,
	render_args => {
		element_attr => {
			class => 'form-control'
		},
		error_class => 'field-validation-error'
	},	
);

has_field 'college' => (
	type => 'Text',
	minlength => 3,
    maxlength => 30,
	render_args => {
		element_attr => {
			class => 'form-control'
		},
		error_class => 'field-validation-error'
	},	
);

has_field 'submit' => (
	type=>'Button',
	render_args => {
		element_attr => {
			class=>'btn btn-primary ',
			type => 'submit'
		},
		
	},
	label => 'Submit'
);

1;