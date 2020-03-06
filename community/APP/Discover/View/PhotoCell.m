//
//  PhotoCell.m
//  community
//
//  Created by 蔡文练 on 2019/10/16.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell


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
    self.bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headImg_base"]];
    [self addSubview:self.bgImage];
    self.bgImage.clipsToBounds = YES;
    self.bgImage.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.bgImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(0);
        make.top.equalTo(10);
        make.right.equalTo(-9);
    }];
    
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtn setImage:[UIImage imageNamed:@"deleteItem"] forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteItem) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteBtn];
    
    [self.deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(0);
    }];
    
}

-(void)refreshItem:(PickerModel *)model{
//    icon_add_pic
    if (model.isAddIcon) {
        self.bgImage.image = [UIImage imageNamed:@"icon_add_pic"];
        self.deleteBtn.hidden = YES;
    }else{
        self.bgImage.image = model.image;
        self.deleteBtn.hidden = NO;
    }
}

-(void)deleteItem{
    NSLog(@"删除");
    if (self.deleteBlock) {
        self.deleteBlock(@"");
    }
}


@end
