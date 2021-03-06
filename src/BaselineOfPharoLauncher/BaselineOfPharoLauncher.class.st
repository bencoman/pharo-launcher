Class {
	#name : #BaselineOfPharoLauncher,
	#superclass : #BaselineOf,
	#category : 'BaselineOfPharoLauncher'
}

{ #category : #baselines }
BaselineOfPharoLauncher >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec 
			baseline: #OSSubprocess
				with: [ spec repository: 'github://pharo-contributions/OSSubprocess:v1.1' ];
			baseline: #OSWinSubprocess
				with: [ spec repository: 'github://pharo-contributions/OSWinSubprocess:v1' ];
			project: 'Ston' with: [
				spec
					className: #ConfigurationOfSton;
					versionString: #'stable';
					repository: 'http://ss3.gemstone.com/ss/STON' ];
			project: 'XMLParser' with: [
				spec
					className: #ConfigurationOfXMLParser;
					versionString: #'stable';
					loads: #('Core' );
					repository: 'http://smalltalkhub.com/mc/PharoExtras/XMLParser/main/' ];
			baseline: #Icetray
				with: [ spec repository: 'github://pharo-spec/icetray/src' ];
			package: #FastTableExtentions
				with: [ spec repository: 'github://sbragagnolo/FastTableExtention/src' ].
		spec
			package: #'PharoLauncher-ZipArchive';
			package: #'PharoLauncher-70Compatibility'; 
			package: #'PharoLauncher-Core' with: [
				spec requires: #(#'XMLParser' #'Ston' #'OSSubprocess' #'OSWinSubprocess' #'PharoLauncher-ZipArchive' #'PharoLauncher-70Compatibility'). ];
			package: #'PharoLauncher-Spec' with: [ 
				spec requires: #(#'PharoLauncher-Core' ). ];
			package: #'PharoLauncher-IceTray' with: [ spec
				requires: #(#'PharoLauncher-Core' #Icetray #FastTableExtentions) ];

			package: #'PharoLauncher-Tests-Core' with: [
				spec requires: #(#'PharoLauncher-Core' ). ];
			package: #'PharoLauncher-Tests-SpecUI' with: [
				spec requires: #(#'PharoLauncher-Core' #'PharoLauncher-Spec'). ];
			package: #'PharoLauncher-Tests-Download' with: [
				spec requires: #(#'PharoLauncher-Tests-Core' ). ];
			package: #'PharoLauncher-Tests-Functional' with: [
				spec requires: #(#'PharoLauncher-Core' #'PharoLauncher-Tests-Download'). ].
		spec 
			group: 'Default' with: #(#'PharoLauncher-Tests-Core' #'PharoLauncher-Tests-Download' #'PharoLauncher-Core' #'PharoLauncher-Spec' #'PharoLauncher-Tests-SpecUI' #'PharoLauncher-Tests-Functional' #'PharoLauncher-IceTray'). ].
]
