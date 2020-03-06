//
//  LiveListItem.m
//  community
//
//  Created by MAC on 2020/2/13.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "LiveListItem.h"

@implementation LiveListItem



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
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.bgImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.bgImage];
    
    self.bgImage.image = [UIImage imageNamed:@"loadNormal"];
    [self.bgImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.bottom.equalTo(0);
    }];    
    self.bgImage.layer.cornerRadius = 8;
    self.bgImage.clipsToBounds = YES;
    
    UIImageView *shaowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shadowIcon"]];
    shaowImg.layer.cornerRadius = 8;
    shaowImg.clipsToBounds = YES;
    [self.contentView addSubview:shaowImg];
    [shaowImg makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.left.right.equalTo(0);
    }];
    
   self.cityImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star_img"]];
    [self.contentView addSubview:self.cityImg];
    [self.cityImg makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(60);
        make.height.equalTo(22);
        make.left.equalTo(0);
        make.top.equalTo(0);
    }];
    
    self.cityLabel = [UILabel labelWithTitle:@"城市名" font:12*K_SCALE textColor:@"ffffff" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.cityLabel];
      [self.cityLabel makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(20);
//         make.right.equalTo(imgeStar.right).offset = 10;
          make.top.equalTo(3);
      }];
//    UIView *colorView = [[UIView alloc] init];
//    [colorView setFrame:CGRectMake(20, 160,
//            self.view.frame.size.width - 40, self.view.frame.size.height - 320)];
//    [self.view addSubview:colorView];
//        
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = colorView.bounds;
//    gradient.colors = [NSArray arrayWithObjects:
//                       (id)[UIColor colorWithRed:0 green:143/255.0 blue:234/255.0 alpha:1.0].CGColor,
//                       (id)[UIColor colorWithRed:0 green:173/255.0 blue:234/255.0 alpha:1.0].CGColor,
//                       (id)[UIColor whiteColor].CGColor, nil];
//    [colorView.layer addSublayer:gradient];
    
  
    
    self.titleLab = [UILabel labelWithTitle:@"乔碧萝" font:17*K_SCALE textColor:@"ffffff" textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleLab];
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(11);
        make.bottom.equalTo(-26);
    }];
    
    self.onlineNum = [UILabel labelWithTitle:@"999" font:11*K_SCALE textColor:@"ffffff" textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.onlineNum];
    [self.onlineNum makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.bottom.equalTo(-5);
    }];
    
    self.onlineIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"onlineIcon"]];
    [self.contentView addSubview:self.onlineIcon];
    [self.onlineIcon makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.onlineNum.left).offset(-5);
        make.centerY.equalTo(self.onlineNum.centerY);
    }];
    
}

/// 设置View任意角度为圆角
/// @param view 待设置的view
/// @param viewSize view的size
/// @param corners 设置的角，左上、左下、右上、右下，可以组合
/// 如左下和右上 (UIRectCornerBottomLeft | UIRectCornerTopRight)
/// @param radius 圆角的半径
- (void)setCornerWithView:(UIView*)view
                 viewSize:(CGSize)viewSize
                  corners:(UIRectCorner)corners
                   radius:(CGFloat)radius{
    CGRect fr = CGRectZero;
    fr.size = viewSize;
    
    UIBezierPath *round = [UIBezierPath bezierPathWithRoundedRect:fr byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *shape = [[CAShapeLayer alloc]init];
    
    [shape setPath:round.CGPath];
    view.layer.mask = shape;
}


-(void)refreshItem:(LiveModel *)model{
    
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"loadNormal"]];
    self.titleLab.text = model.userName;
    self.onlineNum.text = model.nums;
    self.cityLabel.text = model.city;
    //4.根据text的font和字符串自动算出size（重点）
    CGSize size = [model.city sizeWithAttributes:@{NSFontAttributeName:self.cityLabel.font}];
    [self.cityImg updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(size.width+30);
        make.height.equalTo(22);
        make.left.equalTo(0);
        make.top.equalTo(0);
    }];
//    self.cityImg.frame = CGRectMake(0,0,size.width+30,20);
}





@end
