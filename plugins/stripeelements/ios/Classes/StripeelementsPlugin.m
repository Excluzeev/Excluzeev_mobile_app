#import "StripeelementsPlugin.h"
#import <stripeelements/stripeelements-Swift.h>

@implementation StripeelementsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftStripeelementsPlugin registerWithRegistrar:registrar];
}
@end
