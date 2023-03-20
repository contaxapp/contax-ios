# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'
project './Contax.xcodeproj'

target 'Contax' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Contax
  pod 'RealmSwift', '=10.12.0'
  pod 'TrueSDK'
  pod 'TesseractOCRiOS', '=4.0.0'

  target 'ContaxTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ContaxUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'TesseractOCRiOS'
            target.build_configurations.each do |config|
                config.build_settings['ENABLE_BITCODE'] = 'NO'
            end
            header_phase = target.build_phases().select do |phase|
                phase.is_a? Xcodeproj::Project::PBXHeadersBuildPhase
            end.first

            duplicated_header_files = header_phase.files.select do |file|
                file.display_name == 'config_auto.h'
            end

            duplicated_header_files.each do |file|
                header_phase.remove_build_file file
            end
        end
    end
end
