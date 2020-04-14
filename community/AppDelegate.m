//
//  AppDelegate.m
//  community
//
//  Created by 蔡文练 on 2019/9/2.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "AppDelegate.h"
#import "LoadingVC.h"
//#import "EMDemoHelper.h"
#import "OpenInstallSDK.h"
//#import "FMDataBase.h"
#import <Bugly/Bugly.h>
@interface AppDelegate ()<OpenInstallDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //在线异常奔溃处理
    [Bugly startWithAppId:@"98fafb4749"];
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    NSLog(@"版本号：：%@", [HelpTools getAPPVersion]);
//    if ([UserTools isLogin]) {
        [self.window makeKeyAndVisible];
        self.window.rootViewController = [[LoadingVC alloc]init];
//    }
    [self creatDB];
    [self setNavigationBarAppearance];
    ////环信 初始化
//    EMOptions *options = [EMOptions optionsWithAppkey:@"1107190911036138#testapp"];
//    // apnsCertName是证书名称，可以先传nil，等后期配置apns推送时在传入证书名称
//    options.apnsCertName = nil;
//    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    
//    [[EMClient sharedClient]loginWithUsername:@"test3" password:@"111111" completion:^(NSString *aUsername, EMError *aError) {
//        NSLog(@"环信登录：%@--%@",aUsername,aError);
//        if (!aError) {
//            [EMDemoHelper shareHelper];
//            [EMNotificationHelper shared];
//        }
//    }];
    
    [OpenInstallSDK initWithDelegate:self];
//    [[OpenInstallSDK defaultManager] getInstallParmsCompleted:^(OpeninstallData*_Nullable appData) {
//        //在主线程中回调
//        if (appData.data) {//(动态安装参数)
//           //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
//        }
//        if (appData.channelCode) {//(通过渠道链接或二维码安装会返回渠道编号)
//            //e.g.可自己统计渠道相关数据等
//        }
//        NSLog(@"vvvOpenInstallSDK:\n动态参数：%@;\n渠道编号：%@",appData.data,appData.channelCode);
//    }];
    
    return YES;
}
-(void)getWakeUpParams:(OpeninstallData *)appData{
    if (appData.data) {//(动态唤醒参数)
        //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
    }
    if (appData.channelCode) {//(通过渠道链接或二维码唤醒会返回渠道编号)
        //e.g.可自己统计渠道相关数据等
    }
    NSLog(@"OpenInstallSDK:\n动态参数：%@;\n渠道编号：%@",appData.data,appData.channelCode);
}

- (void)creatDB {
    FMDatabase *fmdb = [CSDataBase creatDataBase];
    if (fmdb) {
        [CSDataBase creatAppDataBaseTable];
    }
}


- (void)setNavigationBarAppearance {
    //统一导航条样式
//    UIFont *font = [UIFont systemFontOfSize:19.f];
//    NSDictionary *textAttributes = @{NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor whiteColor]};
//    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"E6E6E6" alpha:1.0f]];
//
//
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1.5, 0)
//                                                         forBarMetrics:UIBarMetricsDefault];
//    UIImage *tmpImage = [UIImage imageNamed:@"back"];
//
//    CGSize newSize = CGSizeMake(12, 20);
//    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
//    [tmpImage drawInRect:CGRectMake(2, -2, newSize.width, newSize.height)];
//    UIImage *backButtonImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [[UINavigationBar appearance] setBackIndicatorImage:backButtonImage];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backButtonImage];
    
    [UINavigationBar appearance].translucent = NO;
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
