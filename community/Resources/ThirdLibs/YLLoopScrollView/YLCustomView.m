//
//  YLCustomView.m
//  YLLoopScrollView
//
//  Created by weiyulong on 2018/7/29.
//  Copyright © 2018年 WYL. All rights reserved.
//

#import "YLCustomView.h"

@interface YLCustomView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YLCustomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.imageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
   
}

- (void)setModel:(YLCustomViewModel *)model {
    _model = model;
    if ([model.logo containsString:@"http"]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.logo]]];
    }else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mainHost,model.logo]]];
    }
    
    
}


@end

@implementation YLCustomViewModel
@end
