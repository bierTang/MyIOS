//
//  IntroImgView.m
//  community
//
//  Created by MAC on 2020/1/14.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "IntroImgView.h"

#import "YBImageBrowser.h"
#import "YBIBVideoData.h"
#if __has_include("YBIBDefaultWebImageMediator.h")
#import "YBIBDefaultWebImageMediator.h"
#endif
@implementation IntroImgView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ImagesArr = [NSMutableArray new];
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.26];
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearBtn];
    [clearBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(690);
    }];
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.cornerRadius = 16;
    view1.clipsToBounds = YES;
    [self addSubview:view1];
    [view1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(200);
        make.top.equalTo(self.bottom).offset(-357*K_SCALE);
    }];
    self.viewBg = view1;
    self.titleLab = [UILabel labelWithTitle:@"标题" font:14*K_SCALE textColor:@"161616" textAlignment:NSTextAlignmentLeft];
    [view1 addSubview:self.titleLab];
    [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.height.equalTo(40*K_SCALE);
        make.width.equalTo(SCREEN_WIDTH-80);
        make.top.equalTo(0);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"closeIcon"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:closeBtn];
    [closeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.centerY.equalTo(self.titleLab.centerY);
        make.height.equalTo(55);
        make.width.equalTo(55);
    }];
    
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor whiteColor];
    [self addSubview:view2];
    
    [view2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(500);
        make.top.equalTo(view1.top).offset(40*K_SCALE);
    }];
    
    for (int i=0; i<6; i++) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(16+176*K_SCALE*(i%2), 104*K_SCALE*(i/2), 166*K_SCALE, 94*K_SCALE)];
        img.image = [UIImage imageNamed:@"videoOccupIcon"];
        img.layer.cornerRadius = 4;
        img.clipsToBounds = YES;
        img.hidden = YES;
        [view2 addSubview:img];
        [self.ImagesArr addObject:img];
        img.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImage:)];
        [img addGestureRecognizer:tap];
    }
    
    self.noImgView = [[UIView alloc]init];
    self.noImgView.backgroundColor = [UIColor whiteColor];
    [view2 addSubview:self.noImgView];
    [self.noImgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.right.equalTo(0);
    }];
    
    UIImageView *noImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noVideoImg"]];
    [self.noImgView addSubview:noImg];
    [noImg makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view2.centerX);
        make.top.equalTo(view2.top);
    }];
}
-(void)showBigImage:(UITapGestureRecognizer *)tap{
    NSLog(@"大图：%ld",tap.view.tag);
//    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    NSInteger tag = tap.view.tag;
    if (!tag) {
        tag = 0;
    }
    
    //添加图片数据集合
                 NSMutableArray *datass = [NSMutableArray array];
               
                   [self.allImgsArr enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         
                                  YBIBImageData *data = [YBIBImageData new];
                                   data.imageURL = [NSURL URLWithString:obj];
    //                                              data.projectiveView = cell.bgImg;
                                      

                                     [datass addObject:data];
                                                    
                                   
                                     }];
                                       YBImageBrowser *browser = [YBImageBrowser new];
                                      //                    // 调低图片的缓存数量
                                      //                    browser.ybib_imageCache.imageCacheCountLimit = 100;
                                      //                    // 预加载数量设为 0
    //                                                      browser.preloadCount = 10;
                                                            browser.webImageMediator = [YBIBDefaultWebImageMediator new];
                                                              browser.dataSourceArray = datass;
                                                              browser.currentPage = tag;
                                                              // 只有一个保存操作的时候，可以直接右上角显示保存按钮
                                                              browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
                                                              [browser show];
    
    
    
//    browser.currentImageIndex = tag;
//    browser.sourceImagesContainerView = self.ImagesArr[0].superview;
//    browser.imageCount = self.allImgsArr.count;
//    browser.delegate = self;
//    [browser show];
}
#pragma mark - SDPhotoBrowserDelegate
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageUrl = [NSString stringWithFormat:@"%@",self.allImgsArr[index]];
    NSURL *url = [NSURL URLWithString:imageUrl];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.ImagesArr[index];
    return imageView.image;
}


-(void)setIntroData:(VideoModel *)model{
    self.titleLab.text = model.descriptions;
    self.allImgsArr = model.images_array;
    for (int i=0; i<model.images_array.count; i++) {
//        [self.ImagesArr[i] sd_setImageWithURL:[NSURL URLWithString:model.images_array[i]] placeholderImage:[UIImage imageNamed:@"videoOccupIcon"]];
        
        [self.ImagesArr[i] sd_setImageWithURL:[NSURL URLWithString:model.images_array[i]] placeholderImage:[UIImage imageNamed:@"img_default"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            self.ImagesArr[i].userInteractionEnabled = YES;
        }];
        self.ImagesArr[i].hidden = NO;
    }
    self.noImgView.hidden = model.images_array.count;
    
    CGFloat offY = 0;
    if (model.images_array.count > 0) {
        offY = (6 - model.images_array.count)/2 * 104*K_SCALE;
    }else{
        offY = 100*K_SCALE;
    }
    
    [self.viewBg updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottom).offset(-357*K_SCALE + offY - 44);
    }];
}

-(void)closeView:(UIButton *)sender{
    self.titleLab.text = @"";
//    self.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        [self.viewBg updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottom).offset(0);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
    self.allImgsArr = nil;
    
    for (UIImageView *img in self.ImagesArr) {
        img.image = [UIImage imageNamed:@"videoOccupIcon"];
        img.userInteractionEnabled = NO;
    }
}

@end
