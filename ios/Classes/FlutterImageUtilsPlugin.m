#import "FlutterImageUtilsPlugin.h"
#import <flutter_image_utils/flutter_image_utils-Swift.h>

@implementation FlutterImageUtilsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterImageUtilsPlugin registerWithRegistrar:registrar];
}
@end
