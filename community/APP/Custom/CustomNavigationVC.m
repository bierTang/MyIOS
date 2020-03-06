
//  Created by GF on 2019/3/19.
//  Copyright © 2019 GF. All rights reserved.
//
#import "CustomNavigationVC.h"

@interface CustomNavigationVC ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation CustomNavigationVC

-(BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    self.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationBar.translucent = NO;
    self.navigationBar.opaque = NO;
    [self.navigationBar setTintColor:RGBColor(17, 17, 17)];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}


- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}


#pragma mark navigationViewController
-(id)initWithRootViewController:(UIViewController *)rootViewController {
    CustomNavigationVC* nvc = [super initWithRootViewController:rootViewController];
    self.interactivePopGestureRecognizer.delegate = self;
    nvc.delegate = self;
    return nvc;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.viewControllers.count == 1){
         self.currentShowVC = Nil;
    }
    else{
        self.currentShowVC = viewController;
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.childViewControllers.count == 1) {
        return NO;
    }
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;

//        if (@available(iOS 11.0, *)) {// 如果iOS 11走else的代码，系统自己的文字和箭头会出来
//            [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 1) forBarMetrics:UIBarMetricsDefault];
//
//            UIImage *backButtonImage = [[UIImage imageNamed:@"arrow_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            [UINavigationBar appearance].backIndicatorImage = backButtonImage;
//            [UINavigationBar appearance].backIndicatorTransitionMaskImage =backButtonImage;
//
//        }else{
//            [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 1) forBarMetrics:UIBarMetricsDefault];
//            UIImage *image = [[UIImage imageNamed:@"arrow_back"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
//            [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        }
       
    }
    [super pushViewController:viewController animated:animated];
}
-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    UIViewController *vc = self.topViewController;
       if ([vc isKindOfClass:[CSChatSessionVC class]]) {
           ///聊天群 界面  销毁声音播放
           [vc performSelector:@selector(controllerWillPopHandler)];
       }
    return [super popViewControllerAnimated:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
