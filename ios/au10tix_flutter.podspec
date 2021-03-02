#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint au10tix_flutter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'au10tix_flutter'
  s.version          = '0.0.1'
  s.summary          = 'au10tix_flutter plugin for fondeadora.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://fondeadora.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Fondeadora' => 'brenda.saavedra@fondeadora.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'
  s.vendored_frameworks = 'Au10DetectorManager.framework','Au10SourceManager.framework','Au10tixBaseUI.framework','Au10tixBEKit.framework','Au10tixCore.framework','Au10tixPassiveFaceLivenessKit.framework','Au10tixPassiveFaceLivenessUI.framework', 'Au10tixSmartDocumentCaptureKit.framework', 'Au10tixSmartDocumentCaptureUI.framework'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.resources = "au10tix_flutter/*.xib"
   s.resource_bundles = {
     'au10tix_flutter' => [
         'Pod/**/*.xib'
     ]
   }
end
