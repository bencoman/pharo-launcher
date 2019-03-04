Class {
	#name : #PhLMockImage,
	#superclass : #Object,
	#instVars : [
		'name',
		'architecture',
		'modified'
	],
	#category : #'PharoLauncher-Spec-Tests'
}

{ #category : #'instance creation' }
PhLMockImage class >> named: aName arch: anArch modified: aModified [
	
	^ self new
		name: aName;
		architecture: anArch;
		modified: aModified;
		yourself
]

{ #category : #accessing }
PhLMockImage >> arch [
	
	^ architecture
]

{ #category : #accessing }
PhLMockImage >> architecture: aString [ 
	
	architecture := aString
]

{ #category : #accessing }
PhLMockImage >> lastModification [
	
	^ modified
]

{ #category : #accessing }
PhLMockImage >> modified: aDateAndTime [ 
	
	modified:= aDateAndTime 

]

{ #category : #accessing }
PhLMockImage >> name [
	^ name
]

{ #category : #accessing }
PhLMockImage >> name: aString [ 
	
	name := aString
]