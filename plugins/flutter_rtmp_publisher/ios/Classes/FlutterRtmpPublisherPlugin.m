#import "FlutterRtmpPublisherPlugin.h"
#import <UIKit/UIKit.h>
#import "LMLivePreview.h"

@interface FlutterRtmpPublisherPlugin ()

@property(strong, nonatomic) UIViewController *viewController;

@end

@implementation FlutterRtmpPublisherPlugin {
    UIViewController *_viewController;
}

// + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//   [SwiftFlutterRtmpPublisherPlugin registerWithRegistrar:registrar];
// }

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"rtmp_publisher"
                                  binaryMessenger:registrar.messenger];
  UIViewController *viewController =
      [UIApplication sharedApplication].delegate.window.rootViewController;
    
    
  FlutterRtmpPublisherPlugin *plugin =
      [[FlutterRtmpPublisherPlugin alloc] initWithViewController:viewController];
  [registrar addMethodCallDelegate:plugin channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
  self = [super init];
  if (self) {
    self.viewController = viewController;
  }
  return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  NSString *url = call.arguments[@"url"];
  if ([@"stream" isEqualToString:call.method]) {
    
    NSLog(@"Url is %@", url);
    
    NSLog(@"Url is %@", url);
    NSLog(@"Messassage ---------------");
    NSLog(@"Width :%f height:%f",self.viewController.view.bounds.size.width, self.viewController.view.bounds.size.height);
    NSLog(@"%@", NSStringFromCGRect(self.viewController.view.bounds));
    NSLog(@"Messassage ---------------");
      LMLivePreview *mainView = [[LMLivePreview alloc] initWithFrame:CGRectMake(0, 0, self.viewController.view.bounds.size.width, self.viewController.view.bounds.size.height)];
      
      mainView.streamUrl = url;
      
      [self.viewController.view addSubview:mainView];
    // _qrcodeview= [[LMLivePreview alloc] initWithFrame:CGRectMake(0, 0, width, height) ];
    // [_viewController.view addSubview:[[LMLivePreview alloc] initWithFrame:CGRectMake(0, 0, self.viewController.view.bounds.size.width, self.viewController.view.bounds.size.height) ]];
    result(@"null");
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end

