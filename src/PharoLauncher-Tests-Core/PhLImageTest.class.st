Class {
	#name : #PhLImageTest,
	#superclass : #TestCase,
	#instVars : [
		'fs',
		'image',
		'imageFileRef'
	],
	#category : #'PharoLauncher-Tests-Core'
}

{ #category : #running }
PhLImageTest >> setUp [
	fs := FileSystem memory root.
	imageFileRef := fs / 'foo.image'.
	imageFileRef binaryWriteStreamDo: [ :stream | (ZnEndianessReadWriteStream on: stream ) nextLittleEndianNumber: 4 put: 68021 ].
	image := PhLImage location: imageFileRef.
	

]

{ #category : #tests }
PhLImageTest >> testCanInitializeImageFromMetadatafile [
	| deserializedImage |
	image 
		description: 'An image for testing purpose';
		computeArchitecture;
		originTemplate: (PhLRemoteTemplate name: 'Foo test template' url: 'https://foo.bar.org/abc/foo.zip' asZnUrl).
		
	deserializedImage := PhLImage location: fs / 'foo.image'.

	self 
		assert: deserializedImage description
		equals: image description.
	self 
		assert: deserializedImage architecture
		equals: image architecture.
	self 
		assert: deserializedImage formatNumber 
		equals: image formatNumber.
	self 
		assert: deserializedImage pharoVersion
		equals: image pharoVersion.
	self 
		assert: deserializedImage originTemplate name
		equals: image originTemplate name.
	self 
		assert: deserializedImage originTemplate url asString
		equals: image originTemplate url asString.
]

{ #category : #tests }
PhLImageTest >> testCanSerializeAndDeserializeImageMetadata [
	| deserializedImage |
	image 
		description: 'An image for testing purpose';
		computeArchitecture;
		originTemplate: (PhLRemoteTemplate name: 'Foo test template' url: 'https://foo.bar.org/abc/foo.zip' asZnUrl).
		
	deserializedImage := STON fromString: image stonString.

	self 
		assert: deserializedImage description
		equals: image description.
	self 
		assert: deserializedImage architecture
		equals: image architecture.
	self 
		assert: deserializedImage formatNumber 
		equals: image formatNumber.
	self 
		assert: deserializedImage pharoVersion
		equals: image pharoVersion.
	self 
		assert: deserializedImage originTemplate name
		equals: image originTemplate name.
	self 
		assert: deserializedImage originTemplate url asString
		equals: image originTemplate url asString.
]

{ #category : #tests }
PhLImageTest >> testDescriptionIsSetWhenNoDescriptionInMetadataButDescriptionFileExists [
	| desc |
	image description: nil.
	desc := 'A description from description file description.txt'.
	fs / PhLImage descriptionFileName 
		writeStreamDo: [ :stream | stream nextPutAll: desc ].

	self 
		assert: image description
		equals: desc.
]

{ #category : #tests }
PhLImageTest >> testPharoVersionIsSetWhenNoVersionInMetadataButPharoVersionFileExists [
	| version |
	
	version := '60'.
	image versionFile 
		writeStreamDo: [ :stream | stream nextPutAll: version ].

	self 
		assert: image pharoVersion
		equals: version.
]

{ #category : #tests }
PhLImageTest >> testTemplateIsSetWhenMetadataFileInOldFormat [
	"Old metadata file was a STON file with a dictionary with only one entry:
		template -> ston representation of the template
	"
	| oldMetadataString template |
	
	image originTemplate: nil.
	oldMetadataString := '{''template'':PhLRemoteTemplate{#name:''Pharo 7.0 (development version)'',#url:ZnUrl{#scheme:#http,#host:''files.pharo.org'',#segments:OrderedCollection[''image'',''70'',''latest.zip'']}}}'.
	fs / PhLImage metadataFileName writeStreamDo: [ :stream | stream nextPutAll: oldMetadataString ].
	template := (STON fromString: oldMetadataString) at: #template.

	image := PhLImage location: fs / 'foo.image'.
	
	self 
		assert: image originTemplate class
		equals: template class.
	self 
		assert: image originTemplate name
		equals: template name.
	self 
		assert: image originTemplate url
		equals: template url.
]
