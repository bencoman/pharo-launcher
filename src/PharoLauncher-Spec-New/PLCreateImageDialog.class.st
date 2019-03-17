Class {
	#name : #PLCreateImageDialog,
	#superclass : #ComposablePresenterWithModel,
	#instVars : [
		'nameInputField',
		'templateList'
	],
	#category : #'PharoLauncher-Spec-New'
}

{ #category : #specs }
PLCreateImageDialog class >> defaultSpec [

	^ SpecBoxLayout newVertical
		borderWidth: 10;
		spacing: 10;
		add: 'Select image template' expand: false fill: false padding: 0;
		add: #templateList expand: true fill: true padding: 0;
		add: (SpecBoxLayout newHorizontal
				borderWidth: 0;
				"rowSpacing: 0;"
				add: 'Image name' expand: false fill: false padding: 10;
				add: #nameInputField" at: 2 @ 1";
				yourself)
			expand: false 
			fill: false 
			padding: 0;
		yourself
]

{ #category : #actions }
PLCreateImageDialog >> doCreateNewImageThen: aBlock [

	self validate ifNotEmpty: [ :errors |
		errors do: [ :each | self window inform: each ].
		^ self ].
	
	aBlock value	
	
]

{ #category : #initialization }
PLCreateImageDialog >> initializeDialogWindow: aDialogWindowPresenter [
	"used to initialize the model in the case of the use into a dialog window.
	 Override this to set buttons other than the default (Ok, Cancel)."
	
	aDialogWindowPresenter
		addButton: 'Cancel' do: #close;
		addButton: 'Create' do: [ :presenter | 
			self doCreateNewImageThen: [ 
				presenter close ] ]
]

{ #category : #initialization }
PLCreateImageDialog >> initializeWidgets [

	templateList := self instantiate: PLTemplateList on: self model.
	nameInputField := self newTextInput autoAccept: true.
	
	self transmit 
		from: templateList;
		to: nameInputField;
		transform: [ :aTemplate | self nameSuggestionFor: aTemplate ]
]

{ #category : #initialization }
PLCreateImageDialog >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Create new image';
		initialExtent: 800@500;
		centered
]

{ #category : #private }
PLCreateImageDialog >> nameSuggestionFor: aTemplate [
	
	aTemplate ifNil: [ ^ '' ].
	^ aTemplate name
]

{ #category : #actions }
PLCreateImageDialog >> validate [
	"this should answer a list of problems but for now I stay with you one at a time"

	templateList selectedImage ifNil: [
		^ #('You need to select an image first') ].
	nameInputField text ifEmpty: [ 
		^ #('You need to add a name to your image') ].
	
	^ #()
]