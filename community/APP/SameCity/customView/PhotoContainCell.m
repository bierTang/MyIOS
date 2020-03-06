//
//  PhotoContainCell.m
//  community
//
//  Created by 蔡文练 on 2019/11/1.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "PhotoContainCell.h"

@implementation PhotoContainCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self makeUI];
        //        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)makeUI{
//    self.backgroundColor = [UIColor grayColor];
    self.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loadNormal"]];
    self.image.clipsToBounds=YES;
    self.image.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.image];
    
    [self.image makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(0);
        make.top.equalTo(0);
        make.right.equalTo(0);
    }];
        
}
-(void)refreshImage:(NSString *)imagePath{
    [self.image sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"loadNormal"]];
}
@end
