//
//  LoadingVC.m
//  community
//
//  Created by 蔡文练 on 2019/11/29.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "LoadingVC.h"
#import "CSTabBarVC.h"

@interface LoadingVC ()

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,assign)NSInteger timeCount;

@property (nonatomic,strong)UILabel *timeLab;


@property (nonatomic,copy)NSString *linkString;

@end

@implementation LoadingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeCount = 5;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *qidong = [[UIImageView alloc]initWithFrame:self.view.bounds];
    qidong.image = [UIImage imageNamed:@"qidong.jpg"];
    [self.view addSubview:qidong];
    
    
    if ([[CSCaches shareInstance]getValueForKey:@"isFirstLogin"].length > 0) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goNextVC:) userInfo:nil repeats:YES];
    }else{
        ///加载启动广告
        [qidong removeFromSuperview];
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:self.scrollView];
        
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT);
        self.scrollView.pagingEnabled = YES;
        for (int i = 0; i<3; i++) {
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"qidong_Ads_%d.jpg",i]];
            [self.scrollView addSubview:imgView];
            if (i==2) {
                imgView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToNextVC)];
                [imgView addGestureRecognizer:tap];
            }
        }
    }
    
    
    UIImageView *adImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    adImage.contentMode = UIViewContentModeScaleAspectFill;
    adImage.hidden = YES;
    adImage.image = [UIImage imageNamed:@"qidong.jpg"];
    [self.view addSubview:adImage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAdsLink)];
    [adImage addGestureRecognizer:tap];
    adImage.userInteractionEnabled = YES;
    
    UIView *circle = [[UIView alloc]init];
    circle.backgroundColor = [UIColor grayColor];
    [self.view addSubview:circle];
    
    circle.layer.cornerRadius = 18;
    circle.clipsToBounds = YES;
    
    [circle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(TopLiuHai+40);
        make.right.equalTo(-25);
        make.height.width.equalTo(36);
    }];
    
    
    self.timeLab = [UILabel labelWithTitle:@"5" font:15 textColor:@"ffffff" textAlignment:NSTextAlignmentCenter];
    [circle addSubview:self.timeLab];
    [self.timeLab makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(circle.center);
    }];
    if ([[CSCaches shareInstance]getValueForKey:@"isFirstLogin"].length == 0) {
        adImage.hidden = YES;
        circle.hidden = YES;
        self.timeLab.hidden = YES;
    }
    MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHud.label.text = @"线路选择中";
    
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]doRequestWithUrl:@"http://vq.v-qun.com" Params:@"/index.php/index/common/choice_line" Callback:^(BOOL isSuccess, id result) {
        NSLog(@"线路：%@",result);
        if (isSuccess) {
            if (result[@"data"] && [[CSCaches shareInstance]getValueForKey:@"isFirstLogin"].length > 0) {
                adImage.hidden = NO;
                NSString *url = [NSString stringWithFormat:@"%@",result[@"data"][@"ad_lists"][@"logo"]];
                [adImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"qidong.jpg"]];
                wself.linkString = result[@"data"][@"ad_lists"][@"link"];
            }
            if (result[@"data"][@"file_url"]) {
                [CSCaches shareInstance].fileWebUrl = result[@"data"][@"file_url"];
            }
            if (result[@"data"][@"url"]) {
                NSArray *arr = result[@"data"][@"url"];
                if (arr[0]) {
                    [CSCaches shareInstance].webUrl = @"http://vq.v-qun.com";
                }
            }
        }
        mbHud.removeFromSuperViewOnHide = YES;
        [mbHud hideAnimated:YES];
        [[CSCaches shareInstance]saveUserDefalt:@"isFirstLogin" value:@"yes"];

    } HttpMethod:AppRequestGet];
    
}
-(void)goAdsLink{
    if (![self.linkString hasPrefix:@"http"]) {
        self.linkString = [NSString stringWithFormat:@"http://%@",self.linkString];
    }
    if (self.linkString.length > 5 && ([self.linkString containsString:@"www"]||[self.linkString containsString:@"http"])) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.linkString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.linkString]];
        }
    }
}
-(void)goNextVC:(NSTimer *)timer{
    self.timeCount --;
    
    if (self.timeCount == 0) {
        [timer invalidate];
        timer = nil;
        [self tapToNextVC];
    }else{
        self.timeLab.text = [NSString stringWithFormat:@"%ld",self.timeCount];
    }
    
}
-(void)tapToNextVC{
    CSTabBarVC *tabbarvc = [[CSTabBarVC alloc]init];
    tabbarvc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:tabbarvc animated:NO completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
