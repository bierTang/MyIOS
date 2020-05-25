//
//  CSTabBarVC.m
//  community
//
//  Created by 蔡文练 on 2019/9/2.
//  Copyright © 2019年 cwl. All rights reserved.
//

#import "CSTabBarVC.h"
#import "CustomNavigationVC.h"

#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"

@interface CSTabBarVC ()

@end

@implementation CSTabBarVC
- (UIViewController *)sj_topViewController {
    if ( self.selectedIndex == NSNotFound )
        return self.viewControllers.firstObject;
    return self.selectedViewController;
}

- (BOOL)shouldAutorotate {
    return [[self sj_topViewController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self sj_topViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self sj_topViewController] preferredInterfaceOrientationForPresentation];
}
//-(BOOL)shouldAutorotate{
//    return NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"CSMainViewController",
                                   kTitleKey  : @"微群",
                                   kImgKey    : @"tab_home_hover",
                                   kSelImgKey : @"tab_home"},
                                                                  
                                 @{kClassKey  : @"CSLongVideoVC",
                                   kTitleKey  : @"视频",
                                   kImgKey    : @"tab_video",
                                   kSelImgKey : @"tab_video_hover"},
                                 
                                 @{kClassKey  : @"CSLiveVC",
                                 kTitleKey  : @"直播",
                                 kImgKey    : @"tab_live",
                                 kSelImgKey : @"tab_live_hover"},
                                 
                                 @{kClassKey  : @"CSCityListVC",
                                 kTitleKey  : @"同城",
                                 kImgKey    : @"tab_city",
                                 kSelImgKey : @"tab_city_hover"},
                                 
                                 @{kClassKey  : @"CSMineViewController",
                                   kTitleKey  : @"我的",
                                   kImgKey    : @"tab_mine",
                                   kSelImgKey : @"tab_mine_hover"} ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        vc.title = dict[kTitleKey];
        CustomNavigationVC *nav = [[CustomNavigationVC alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[kTitleKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName :RGBColor(90, 194, 115)} forState:UIControlStateSelected];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName :RGBColor(17, 17, 17)} forState:UIControlStateNormal];
        [self addChildViewController:nav];
    }];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName :RGBColor(17, 17, 17)} forState:UIControlStateNormal];
   
    if (@available(iOS 11.0, *)) {// 如果iOS 11走else的代码，系统自己的文字和箭头会出来
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 1) forBarMetrics:UIBarMetricsDefault];

        UIImage *backButtonImage = [[UIImage imageNamed:@"arrow_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [UINavigationBar appearance].backIndicatorImage = backButtonImage;
        [UINavigationBar appearance].backIndicatorTransitionMaskImage =backButtonImage;

    }else{
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 1) forBarMetrics:UIBarMetricsDefault];
        UIImage *image = [[UIImage imageNamed:@"arrow_back"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName :RGBColor(90, 194, 116)} forState:UIControlStateSelected];
    
    self.tabBar.tintColor = RGBColor(90, 194, 116);
}

@end
