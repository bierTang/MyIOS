//
//  MomnetView.m
//  community
//
//  Created by 蔡文练 on 2019/9/19.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "MomentView.h"
#import "SDPhotoBrowser.h"

@interface MomentView () <SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *imageViewsArray;

@end


@implementation MomentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.cellImgArr = [NSMutableArray new];
    for (int i=0; i<9; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(16*K_SCALE+118*i*K_SCALE, 0, 113*K_SCALE, 113*K_SCALE)];
        imageview.clipsToBounds = YES;
        imageview.contentMode = UIViewContentModeScaleAspectFill;
//        imageview.image = [UIImage imageNamed:@"cityImage"];
        [self addSubview:imageview];
        imageview.userInteractionEnabled = YES;
        imageview.tag = i;
        if (i<3) {
            [self.cellImgArr addObject:imageview];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAllImages:)];
            [imageview addGestureRecognizer:tap];
            
            
            if (i==2) {
                self.addMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.addMoreBtn.frame = imageview.bounds;
                self.addMoreBtn.userInteractionEnabled = NO;
                self.addMoreBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
                [self.addMoreBtn setImage:[UIImage imageNamed:@"addMoreImage"] forState:UIControlStateNormal];
                [imageview addSubview:self.addMoreBtn];
                self.addMoreBtn.hidden = YES;
            }
        }else{
            imageview.hidden = YES;
        }
        
    }
    
}
-(void)setPicPathStringsArray:(NSArray *)picPathStringsArray{
    _picPathStringsArray = picPathStringsArray;
    if (picPathStringsArray.count > 3) {
        self.addMoreBtn.hidden = NO;
    }else{
        self.addMoreBtn.hidden = YES;
    }
    for (int i=0; i<3; i++) {
        self.cellImgArr[i].hidden = YES;
        if (i<picPathStringsArray.count) {
            self.cellImgArr[i].hidden = NO;
            [self.cellImgArr[i] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mainHost,picPathStringsArray[i]]]];
        }
    }
}
-(void)showAllImages:(UITapGestureRecognizer *)sender{
    NSLog(@"显示所有图片");
    
    UIView *imageView = sender.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.picPathStringsArray.count;
    browser.delegate = self;
    [browser show];
}



#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",mainHost,self.picPathStringsArray[index]];
//    NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568977678481&di=a87049fb35fb44322144281bbe465441&imgtype=0&src=http%3A%2F%2Fhiphotos.baidu.com%2Fdoc%2Fpic%2Fitem%2Ffc1f4134970a304e100ced34d8c8a786c8175cd5.jpg"];
     NSURL *url = [NSURL URLWithString:imageUrl];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}


@end
