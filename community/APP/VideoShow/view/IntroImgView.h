//
//  IntroImgView.h
//  community
//
//  Created by MAC on 2020/1/14.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPhotoBrowser.h"

NS_ASSUME_NONNULL_BEGIN

@interface IntroImgView : UIView <SDPhotoBrowserDelegate>

@property (nonatomic,strong)UILabel *titleLab;
///存放当前的图片容器
@property (nonatomic,strong)NSMutableArray<UIImageView *> *ImagesArr;

///存放所有图片地址
@property (nonatomic,strong)NSArray *allImgsArr;

@property (nonatomic,strong)UIView *noImgView;


@property (nonatomic,strong)UIView *viewBg;

-(void)setIntroData:(VideoModel *)model;

@end

NS_ASSUME_NONNULL_END
