//
//  LoadingVC.m
//  community
//
//  Created by 蔡文练 on 2019/11/29.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "LoadingVC.h"
#import "CSTabBarVC.h"
#import "BGFMDB.h"
#import "SimplePingHelper.h"
#import "WebModel.h"
@interface LoadingVC ()

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,assign)NSInteger timeCount;

@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)MBProgressHUD *mbHud;
@property (nonatomic,strong)UIView *circle;
@property (nonatomic,copy)NSString *linkString;
//有多少个地址
@property (nonatomic,copy)NSArray<WebModel *> *webUrls;

//p到第多少个了
@property (nonatomic,assign)NSInteger indexP;
@property (nonatomic,strong) UIImageView *adImage;
@end

@implementation LoadingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indexP = 0;
    self.timeCount = 5;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *qidong = [[UIImageView alloc]initWithFrame:self.view.bounds];
    qidong.image = [UIImage imageNamed:@"qidong.png"];
    [self.view addSubview:qidong];
    
    
    if ([[CSCaches shareInstance]getValueForKey:@"isFirstLogin"].length > 0) {
        
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
        
        
       
//        NSArray *arrModel = [WebModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
//
//
//        for (WebModel *i in arrModel){
//            i.bg_tableName = @"WEBLINE";
//            if (![i.url containsString:@"http://"]&&![i.url containsString:@"https://"]) {
//                i.url = [NSString stringWithFormat:@"%@%@",@"https://",i.url];
//            }
//
//        }
//
//        [WebModel bg_saveOrUpdateArray:arrModel];
        
        
        
    }
    
    
    self.adImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.adImage.contentMode = UIViewContentModeScaleToFill;
    self.adImage.hidden = YES;
    self.adImage.image = [UIImage imageNamed:@"qidong.jpg"];
    [self.view addSubview:self.adImage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAdsLink)];
    [self.adImage addGestureRecognizer:tap];
    self.adImage.userInteractionEnabled = YES;
    
    self.circle = [[UIView alloc]init];
    self.circle.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.circle];
    
    self.circle.layer.cornerRadius = 18;
    self.circle.clipsToBounds = YES;
    
    [self.circle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(TopLiuHai+40);
        make.right.equalTo(-25);
        make.height.width.equalTo(36);
    }];
    
    
    self.timeLab = [UILabel labelWithTitle:@"5" font:15 textColor:@"ffffff" textAlignment:NSTextAlignmentCenter];
    self.timeLab.hidden = YES;
    self.circle.hidden = YES;
    [self.circle addSubview:self.timeLab];
    [self.timeLab makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.circle.center);
    }];
    if ([[CSCaches shareInstance]getValueForKey:@"isFirstLogin"].length == 0) {
        self.adImage.hidden = YES;
        self.circle.hidden = YES;
        self.timeLab.hidden = YES;
    }
    self.mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.mbHud.label.text = @"线路选择中";


    
    /**
       同步查询所有数据.
              */
    NSArray* Array = [WebModel bg_findAll:@"WEBLINE"];
    
    
    // 排序key, 某个对象的属性名称，是否升序, YES-升序, NO-降序
           NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO];
           // 排序结果
           NSMutableArray *tArr = [NSMutableArray new];
          
           [tArr addObjectsFromArray:[Array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]];
    
    self.webUrls = tArr;
    
    if (self.webUrls.count > 0) {
        NSString *strUrl = [self.webUrls[self.indexP].url stringByReplacingOccurrencesOfString:@"http:" withString:@""];  //去掉http:测试
        NSString *strUrl1 = [strUrl stringByReplacingOccurrencesOfString:@"https:" withString:@""];  //去掉https:测试
        NSString *strUrl2 = [strUrl1 stringByReplacingOccurrencesOfString:@"/" withString:@""];  //去掉/测试
        NSLog(@"ping地址 %@",strUrl2);
        // ping
        [self tapPingTo:strUrl2];
    }else{
       //如果没有线路的话就再走一次默认的选择线路，超时好进入
        [self oneLine];
  
    }
    
    
   
    
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
-(void)oneLine{
    [[AppRequest sharedInstance]doRequestWithUrl:@"https://app-api.vqapi.com" Params:@"" Callback:^(BOOL isSuccess, id result) {
        
        if (isSuccess) {
            if (result[@"data"]) {
                NSLog(@"线路：%@",result[@"data"]);
                NSArray *arr = result[@"data"];
                NSArray *arrModel = [WebModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
                if (arr[0]) {
                    WebModel *i = arrModel[0];
                    [CSCaches shareInstance].webUrl = i.url;
                    mainHost = i.url;
                }

                for (WebModel *i in arrModel){
                    i.bg_tableName = @"WEBLINE";
                    if (![i.url containsString:@"http://"]&&![i.url containsString:@"https://"]) {
                        i.url = [NSString stringWithFormat:@"%@%@",@"https://",i.url];
                    }
                    
                }
                
                [WebModel bg_saveOrUpdateArray:arrModel];

              
            }
          
                    if ([[CSCaches shareInstance]getValueForKey:@"isFirstLogin"].length > 0) {
                        NSLog(@"线路：%@",@"直接跳过启动图");
                        [self tapToNextVC];
                    }
            
            
            self.mbHud.removeFromSuperViewOnHide = YES;
            [self.mbHud hideAnimated:YES];
            [[CSCaches shareInstance]saveUserDefalt:@"isFirstLogin" value:@"yes"];
            
            
        }else{
            [self oneLine1];
        }
        

    } HttpMethod:AppRequestGet isAni:NO];
}


-(void)oneLine1{
    [[AppRequest sharedInstance]doRequestWithUrl:@"https://app-api.vqapi.net" Params:@"" Callback:^(BOOL isSuccess, id result) {
        
        if (isSuccess) {
            if (result[@"data"]) {
                NSLog(@"线路：%@",result[@"data"]);
                NSArray *arr = result[@"data"];
                NSArray *arrModel = [WebModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
                if (arr[0]) {
                    WebModel *i = arrModel[0];
                    [CSCaches shareInstance].webUrl = i.url;
                    mainHost = i.url;
                }

                for (WebModel *i in arrModel){
                    i.bg_tableName = @"WEBLINE";
                    if (![i.url containsString:@"http://"]&&![i.url containsString:@"https://"]) {
                        i.url = [NSString stringWithFormat:@"%@%@",@"https://",i.url];
                    }
                    
                }
                
                [WebModel bg_saveOrUpdateArray:arrModel];

              
            }
          
        }else{
             NSLog(@"线路：%@",@"请求错误啊啊啊");
            if ([[CSCaches shareInstance]getValueForKey:@"isFirstLogin"].length > 0) {
                NSLog(@"线路：%@",@"直接跳过启动图");
                [self tapToNextVC];
            }
        }
        self.mbHud.removeFromSuperViewOnHide = YES;
        [self.mbHud hideAnimated:YES];
        [[CSCaches shareInstance]saveUserDefalt:@"isFirstLogin" value:@"yes"];

    } HttpMethod:AppRequestGet isAni:NO];
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

- (void)tapPingTo:(NSString *)host {
    NSLog(@"-----------");
    NSLog(@"Tapped Ping");
    [SimplePingHelper ping:host target:self sel:@selector(pingResult:)];
}

- (void)pingResult:(NSNumber*)success {

    if (success.boolValue) {
        NSLog(@"Ping SUCCESS");
        if (self.indexP < 1) {
            self.indexP = 1;
        }
        [CSCaches shareInstance].webUrl = self.webUrls[self.indexP-1].url;
        
        
        [[AppRequest sharedInstance]requestADSforType:@"11" Block:^(AppRequestState state, id  _Nonnull result) {
               NSLog(@"首页广告：：%@",result);
               if (state == AppRequestState_Success) {
                               if (result[@"data"] && [[CSCaches shareInstance]getValueForKey:@"isFirstLogin"].length > 0) {
                                   if(result[@"data"]){
                                       NSArray * arr = result[@"data"];
                                       if (arr.count > 0) {
                                           [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goNextVC:) userInfo:nil repeats:YES];
                                           self.timeLab.hidden = NO;
                                            self.adImage.hidden = NO;
                                           self.circle.hidden = NO;
                                           NSString *url = [NSString stringWithFormat:@"%@",result[@"data"][0][@"logo"]];
                                            [self.adImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"qidong.png"]];
                                           self.linkString = result[@"data"][0][@"link"];
                                       }else{
                                           //错误的话直接去首页
                                          [self tapToNextVC];
                                       }
                                   }
                                  
                               }

               }else{
                   //错误的话直接去首页
                   [self tapToNextVC];
               }
           }];
        
        
        [[AppRequest sharedInstance]doRequestWithUrl:[self.webUrls[self.indexP-1].url stringByAppendingString: @"/index.php"] Params:@"" Callback:^(BOOL isSuccess, id result) {
               
               if (isSuccess) {

                   [CSCaches shareInstance].webUrl = self.webUrls[self.indexP-1].url;
                   if (result[@"data"]) {
                       NSLog(@"线路：%@",result[@"data"]);
                       NSArray *arrModel = [WebModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
                       for (WebModel *i in arrModel){
                           i.bg_tableName = @"WEBLINE";
                       }
                       [WebModel bg_saveOrUpdateArray:arrModel];
                     
                   }
                 
               }
            self.mbHud.removeFromSuperViewOnHide = YES;
                   [self.mbHud hideAnimated:YES];
           } HttpMethod:AppRequestGet isAni:NO];
        
        
        
    } else {
        NSLog(@"Ping FAILURE");
       
        for (WebModel *i in self.webUrls){
            NSLog(@"地址 %@",i.url);
        }
        if (self.webUrls.count > self.indexP) {
            
            NSString *strUrl = [self.webUrls[self.indexP].url stringByReplacingOccurrencesOfString:@"http:" withString:@""];  //去掉http:测试
            NSString *strUrl1 = [strUrl stringByReplacingOccurrencesOfString:@"https:" withString:@""];  //去掉https:测试
            NSString *strUrl2 = [strUrl1 stringByReplacingOccurrencesOfString:@"/" withString:@""];  //去掉/测试
            NSLog(@"ping地址 %@",strUrl2);
            // ping
            [self tapPingTo:strUrl2];
            self.indexP++;
        }else{
            //所有的线路请求完了，再去试试q默认的请求线路
            [self oneLine];
        }
    }
}

@end
