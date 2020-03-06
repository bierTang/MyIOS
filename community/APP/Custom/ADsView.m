//
//  ADsView.m
//  community
//
//  Created by 蔡文练 on 2019/11/5.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "ADsView.h"

@implementation ADsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    self.bgImage = [[UIImageView alloc]init];
    [self addSubview:self.bgImage];
    
    [self.bgImage makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.right.equalTo(-10);
        make.bottom.left.equalTo(0);
    }];
    
    self.bgImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlTapAction)];
    [self.bgImage addGestureRecognizer:tap];
   
    
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setImage:[UIImage imageNamed:@"deleteItem"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(deleteItem) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delBtn];
    
    [delBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(0);
    }];
    
}
-(void)handlTapAction{
    
    if (self.linkUrl.length > 5) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.linkUrl] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.linkUrl]];
        }
    }
    
}
-(void)deleteItem{
//    if (self.backBlock) {
//        self.backBlock(@"");
//    }
    [self removeFromSuperview];
}

-(void)handleAction{
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@""] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@""]];
        // Fallback on earlier versions
    }
}

-(void)setImageUrl:(NSString *)url{
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:url]];
}

@end
