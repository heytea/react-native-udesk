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

RCT_EXPORT_METHOD(startChat:(NSDictionary *)data
                  :(RCTPromiseResolveBlock)resolve
                  :(RCTPromiseRejectBlock)reject){

  //初始化公司（appKey、appID、domain都是必传字段）
   UdeskOrganization *organization = [[UdeskOrganization alloc] initWithDomain:data[@"domain"] appKey:data[@"appKey"] appId:data[@"appId"]];

   UdeskCustomer *customer = [UdeskCustomer new];
   customer.sdkToken = data[@"sdkToken"];
   customer.nickName = data[@"nickname"];

   //初始化sdk
   [UdeskManager initWithOrganization:organization customer:customer];

  //使用push
  UdeskSDKManager *sdkManager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle customStyle] sdkConfig:[UdeskSDKConfig customConfig]];
//  [sdkManager pushUdeskInViewController:self completion:nil];

  //使用present
  [sdkManager presentUdeskInViewController:[ReactNativeUdesk getCurrentVC] completion:nil];

  resolve(@(YES));
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
