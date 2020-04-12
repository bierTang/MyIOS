//
//  WebServeVC.m
//  community
//
//  Created by 蔡文练 on 2019/11/13.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "WebServeVC.h"
 #import <WebKit/WebKit.h>
@interface WebServeVC ()

@end

@implementation WebServeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebView *webview = [[WKWebView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:webview];
    [webview makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(-KBottomSafeArea);
    }];
    
    NSURL *fileURL=[NSURL URLWithString:serveHost];
    NSURLRequest *request=[NSURLRequest requestWithURL:fileURL];
    [webview loadRequest:request];
    
//    [webview scalesPageToFit];
//
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    back.frame = CGRectMake(SCREEN_WIDTH-40, 7*K_SCALE, 19*K_SCALE, 19*K_SCALE);
//    [back addTarget:self action:@selector(viewback) forControlEvents:UIControlEventTouchUpInside];
//    [back setImage:[UIImage imageNamed:@"white_close"] forState:UIControlStateNormal];
//    [self.view addSubview:back];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
//-(void)viewback{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}


@end
