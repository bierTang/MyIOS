//
//  CSAlertView.m
//  community
//
//  Created by 蔡文练 on 2019/10/18.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CSAlertView.h"

@implementation CSAlertView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        [self addGestureRecognizer:gesture];
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    UIView *alertView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    alertView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    [self addSubview:alertView];
    
    UIButton *saveBtn = [UIButton buttonWithTitle:@"保存到相册" font:14 titleColor:@"000000" backgroundColor:@"ffffff" cornerRadius:0];
    saveBtn.frame = CGRectMake(0, SCREEN_HEIGHT-102-KBottomSafeArea, SCREEN_WIDTH, 50);
    [saveBtn addTarget:self action:@selector(confirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:saveBtn];
    saveBtn.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消" font:14 titleColor:@"000000" backgroundColor:@"ffffff" cornerRadius:0];
    cancelBtn.frame = CGRectMake(0, SCREEN_HEIGHT-50-KBottomSafeArea, SCREEN_WIDTH, 50);
    [cancelBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:cancelBtn];
    saveBtn.backgroundColor = [UIColor whiteColor];
    
}
-(void)confirmBtn{
    if (self.backBlock) {
        self.backBlock();
    }
    [self dismissView];
}
-(void)dismissView{
    NSLog(@"取消");
//    [self.bgView removeFromSuperview];
    [self removeFromSuperview];
}

@end
