//
//  CSShareVC.m
//  community
//
//  Created by 蔡文练 on 2019/11/13.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CSShareVC.h"
#import "CSShareRerecordVC.h"

@interface CSShareVC ()

@property (nonatomic,strong)UIView *qrBgView;

@property (nonatomic,strong)UIImageView *qrImg;

@property (nonatomic,strong)UILabel *recomLab;
@property (nonatomic,strong)UILabel *reContentLab;


@property (nonatomic,copy)NSString *shareURL;

@end

@implementation CSShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"分享推广";
    
    [self setUpNav];
    
    
    UIImageView *bgImgview = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImgview.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImgview];
    bgImgview.image = [UIImage imageNamed:@"shareBgImg"];
    
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY);
        make.width.equalTo(284*K_SCALE);
        make.height.equalTo(280*K_SCALE);
    }];
    
    whiteView.layer.cornerRadius = 4;
    whiteView.clipsToBounds = YES;
    
    self.qrBgView = [[UIView alloc]init];
    self.qrBgView.backgroundColor = [UIColor whiteColor];
    [whiteView addSubview:self.qrBgView];
    
    [self.qrBgView makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(180*K_SCALE);
        make.top.equalTo(14*K_SCALE);
        make.centerX.equalTo(whiteView.centerX);
    }];
    
    self.qrBgView.layer.cornerRadius = 4;
    self.qrBgView.clipsToBounds = YES;
    
    
    self.qrImg = [[UIImageView alloc]init];
//    self.qrImg.image = [UIImage qrCodeImageWithContent:@"www.baidu.co" codeImageSize:175*K_SCALE];
    [self.qrBgView addSubview:self.qrImg];
    
    [self.qrImg makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(175*K_SCALE);
        make.top.equalTo(3);
        make.centerX.equalTo(self.qrBgView.centerX);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"e3e3e3"];
    [whiteView addSubview:line];
    
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(208*K_SCALE);
        make.left.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setImage:[UIImage imageNamed:@"shareLink"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 1;
    [whiteView addSubview:btn1];
    
    [btn1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.bottom.equalTo(-23);
    }];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setImage:[UIImage imageNamed:@"shareQRcode"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"shareQRcode"] forState:UIControlStateHighlighted];

    [btn2 addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = 2;
    [whiteView addSubview:btn2];
    
    [btn2 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-16);
        make.bottom.equalTo(-23);
    }];
    
    self.reContentLab = [UILabel labelWithTitle:@"" font:14 textColor:@"ffffff" textAlignment:NSTextAlignmentLeft];
    self.reContentLab.numberOfLines = 0;
    [self.view addSubview:self.reContentLab];
    
    [self.reContentLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.bottom.equalTo(self.view.bottom).offset(-KBottomSafeArea-50);
    }];
    
    self.recomLab = [UILabel labelWithTitle:@"推荐有礼" font:14 textColor:@"ffffff" textAlignment:NSTextAlignmentLeft];
    self.recomLab.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:self.recomLab];
    [self.recomLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.bottom.equalTo(self.reContentLab.top).offset(-15);
    }];
    
    [[AppRequest sharedInstance]requestQRcode:[UserTools userID] Block:^(AppRequestState state, id  _Nonnull result) {
        if (state == AppRequestState_Success) {
            self.qrImg.image = [UIImage qrCodeImageWithContent:result[@"data"][@"url"] QRSize:175*K_SCALE logo:[UIImage imageNamed:@"logo_icon"] logoFrame:CGRectMake(72.5*K_SCALE, 72.5*K_SCALE, 30*K_SCALE, 30*K_SCALE) red:255 green:255 blue:255];
            NSArray *arr = result[@"data"][@"str"];
            self.reContentLab.text = [arr componentsJoinedByString:@"\n"];
            self.shareURL = result[@"data"][@"url"];
        }
    }];
}

-(void)handleAction:(UIButton *)sender{
    NSLog(@"s:%ld",sender.tag);
    if (sender.tag == 2) {
        [self saveToAlbum];
    }else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"1、深夜看片神器微群社区App，会员免费在线观看，支持苹果和安卓双端！ 2、超快加载，海量正版高清片源，无需翻墙！ 3、使用推广码  还可以获取专属观影特权，下载请戳我 %@ ，部分浏览器打不开，请更换浏览器！",self.shareURL];
        [[MYToast makeText:@"链接复制成功，去粘贴分享吧"]show];
    }
}


-(void)setUpNav{
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 78, 44)];
    
    UIButton *corderBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 11, 60, 22)];
    [rightButtonView addSubview:corderBtn];
    
    [corderBtn setTitle:@"推广记录" forState:UIControlStateNormal];
    [corderBtn setTitleColor:[UIColor colorWithHexString:@"161616"] forState:UIControlStateNormal];
    corderBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [corderBtn addTarget:self action:@selector(sharerecord) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}

-(void)sharerecord{
    CSShareRerecordVC *vc = [[CSShareRerecordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


///保存到相册
- (void)saveToAlbum {
//    UIGraphicsBeginImageContextWithOptions(self.qrBgView.bounds.size, NO, 0);
//    CGContextRef ctx =  UIGraphicsGetCurrentContext();
//    [self.qrBgView.layer renderInContext:ctx];
//    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIImageWriteToSavedPhotosAlbum(newImage,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
    
    
    UIGraphicsBeginImageContext(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.view.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    UIImageWriteToSavedPhotosAlbum(image,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
    
}
//保存相片的回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [[MYToast makeText:@"保存失败"]show];
    } else {
        [[MYToast makeText:@"保存到相册成功，去分享吧"]show];
    }
}

@end
