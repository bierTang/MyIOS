//
//  TextReaderVC.m
//  community
//
//  Created by MAC on 2019/12/28.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "TextReaderVC.h"

@interface TextReaderVC () <UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *txtScroll;

@property (nonatomic,strong)UILabel *contentLab;
@end

@implementation TextReaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.txtScroll = [[UIScrollView alloc]init];
    [self.view addSubview:self.txtScroll];
    self.txtScroll.delegate = self;
    
    [self.txtScroll makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(10);
        make.right.equalTo(-1);
        make.bottom.equalTo(-KBottomSafeArea);
    }];
    
    self.contentLab = [UILabel labelWithTitle:@"" font:16 textColor:@"181818" textAlignment:NSTextAlignmentLeft];
    self.contentLab.numberOfLines = 0;
    
    [self.txtScroll addSubview:self.contentLab];
    
    
    [self.contentLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.width.equalTo(SCREEN_WIDTH-32);
        make.top.equalTo(0);
        make.bottom.equalTo(0);
    }];
    
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/chitchat/story_info" Params:@{@"story_id":self.txtId} Callback:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            if ([result[@"code"] intValue] == 200) {
                wself.contentLab.text = result[@"data"][@"content"];
                CGFloat offy = [[[CSCaches shareInstance].userDefault valueForKey:[NSString stringWithFormat:@"TEXT_Offsety_%@",wself.txtId]] floatValue];
                if (offy > 0) {
                    [wself.txtScroll setContentOffset:CGPointMake(0, offy)];
                }
            }else{
                wself.contentLab.text = @"请求出错，请稍后再试";
            }
        }
    } HttpMethod:AppRequestPost];
    
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"拖拽结束：：%f",scrollView.contentOffset.y);
    [[CSCaches shareInstance]saveUserDefaltFloat:[NSString stringWithFormat:@"TEXT_Offsety_%@",self.txtId] value:scrollView.contentOffset.y];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"拖拽f结束：：%f",scrollView.contentOffset.y);
    [[CSCaches shareInstance]saveUserDefaltFloat:[NSString stringWithFormat:@"TEXT_Offsety_%@",self.txtId] value:scrollView.contentOffset.y];
}
@end
