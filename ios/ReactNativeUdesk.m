#import "ReactNativeUdesk.h"
#import <Udesk.h>

@implementation ReactNativeUdesk


RCT_EXPORT_MODULE(ReactNativeUdesk);

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup  {
    return YES;
}


RCT_EXPORT_METHOD(init:(NSDictionary*)data) {
  
  NSString *domain = data[@"domain"];
  NSString *appKey = data[@"appKey"];
  NSString *appId = data[@"appId"];
  NSString *sdkToken = data[@"sdkToken"];
  UdeskOrganization *organization = [[UdeskOrganization alloc] initWithDomain:domain appKey:appKey appId:appId];
  UdeskCustomer *customer = [UdeskCustomer new];
  customer.sdkToken = sdkToken;
  [UdeskManager initWithOrganization:organization customer:customer];
  
}


RCT_EXPORT_METHOD(startChat){
      
  UdeskSDKManager *sdkManager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle defaultStyle] sdkConfig:[UdeskSDKConfig customConfig]];
  
  [sdkManager pushUdeskInViewController:[ReactNativeUdesk getCurrentVC] udeskType:UdeskFAQ completion:nil];
  
}


//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

@end
