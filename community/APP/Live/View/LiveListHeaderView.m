//
//  LiveListHeaderView.m
//  community
//
//  Created by MAC on 2020/2/20.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "LiveListHeaderView.h"

@implementation LiveListHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    [self initScrollAds:[CSCaches shareInstance].lunboArr];
    
    UIView *greenView = [[UIView alloc]init];
    //    greenView.backgroundColor = RGBColor(86, 211, 95);
        [self addSubview:greenView];
        UIImageView *greenImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"greenShadow"]];
        [greenView addSubview:greenImg];
        [greenImg makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.bottom.equalTo(0);
        }];
        
        [greenView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(125*K_SCALE);
            make.left.right.equalTo(0);
            make.height.equalTo(98*K_SCALE);
        }];
        
        
        UILabel *titleLabe = [UILabel labelWithTitle:[CSCaches shareInstance].currentLiveModel.userName font:18*K_SCALE textColor:@"ffffff" textAlignment:NSTextAlignmentLeft];
        titleLabe.font = [UIFont boldSystemFontOfSize:18*K_SCALE];
        [greenView addSubview:titleLabe];
        
        [titleLabe makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.top.equalTo(0);
            make.height.equalTo(50*K_SCALE);
        }];
        
        UIView *introBgView = [[UIView alloc]init];
        introBgView.backgroundColor = [UIColor whiteColor];
        introBgView.layer.cornerRadius = 8;
    //    introBgView.clipsToBounds = YES;
        [self addSubview:introBgView];
        
        [introBgView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.height.equalTo(75*K_SCALE);
            make.top.equalTo(titleLabe.bottom);
        }];
        
            introBgView.layer.shadowOffset = CGSizeMake(2, 2);
            introBgView.layer.shadowColor = [UIColor colorWithHexString:@"efefef"].CGColor;
            introBgView.layer.shadowRadius = 3;
            introBgView.layer.shadowOpacity = 1;
        
        
        UIImageView *img0 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headImg_base_3"]];
        [introBgView addSubview:img0];
        img0.layer.cornerRadius = 20*K_SCALE;
        img0.clipsToBounds = YES;
        [img0 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.centerY.equalTo(introBgView.centerY);
            make.height.width.equalTo(40*K_SCALE);
        }];
        NSString *strImg = [CSCaches shareInstance].currentLiveModel.imgUrl;
        if (strImg.length < 5) {
            strImg = [CSCaches shareInstance].currentLiveModel.imgUrl;
        }
        [img0 sd_setImageWithURL:[NSURL URLWithString:strImg] placeholderImage:[UIImage imageNamed:@"headImg_base_3"]];
        
        UILabel *lab0 = [UILabel labelWithTitle:@"平台介绍" font:14*K_SCALE textColor:@"222222" textAlignment:NSTextAlignmentLeft];
        lab0.font = [UIFont boldSystemFontOfSize:16*K_SCALE];
        [introBgView addSubview:lab0];
        [lab0 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(img0.right).offset(6);
            make.top.equalTo(img0.top);
            make.height.equalTo(20*K_SCALE);
        }];
        
        NSString *desc = [CSCaches shareInstance].liveDescString;
        if (desc.length < 1) {
            desc = @"暂无介绍";
        }
        UILabel *labintro = [UILabel labelWithTitle:desc font:12*K_SCALE textColor:@"666666" textAlignment:NSTextAlignmentLeft];
        [introBgView addSubview:labintro];
        [labintro makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(img0.right).offset(6);
            make.bottom.equalTo(img0.bottom);
            make.height.equalTo(20*K_SCALE);
        }];
}

//轮播图
-(void)initScrollAds:(NSArray *)arr{
    
    self.ylScrollview = [YLLoopScrollView loopScrollViewWithTimer:3 customView:^NSDictionary *{
        return @{@"YLCustomView" : @"model"};
    }];
    
    self.ylScrollview.clickedBlock = ^(NSInteger index) {
        YLCustomViewModel *mod = arr[index];
        if (mod == nil) {
            return ;
        }
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:mod.link] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:mod.link]];
        }
        
    };
    self.ylScrollview.dataSourceArr = arr;
    
    self.ylScrollview.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];//RGBColor(245, 162, 0);
    self.ylScrollview.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.ylScrollview.frame = CGRectMake(0,0,SCREEN_WIDTH,125*K_SCALE);
    [self addSubview:self.ylScrollview];
    

}

@end
