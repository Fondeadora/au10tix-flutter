#import "Au10tixFlutterPlugin.h"
#if __has_include(<au10tix_flutter/au10tix_flutter-Swift.h>)
#import <au10tix_flutter/au10tix_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "au10tix_flutter-Swift.h"
#endif

@implementation Au10tixFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAu10tixFlutterPlugin registerWithRegistrar:registrar];
}
@end
