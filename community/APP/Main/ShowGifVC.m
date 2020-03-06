//
//  ShowGifVC.m
//  community
//
//  Created by 蔡文练 on 2019/10/30.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "ShowGifVC.h"

@interface ShowGifVC ()

@property(nonatomic,strong)FLAnimatedImageView *gifImg;

@end

@implementation ShowGifVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.gifImg = [[FLAnimatedImageView alloc]init];
    [self.view addSubview:self.gifImg];
       
    __block MBProgressHUD *hud =[[MBProgressHUD alloc]init];
    [self.view addSubview:hud];
    hud.label.text=@"动图加载中";
    [hud showAnimated:YES];
        
        [self.gifImg makeConstraints:^(MASConstraintMaker *make) {
            make.width.lessThanOrEqualTo(SCREEN_WIDTH);
            make.height.lessThanOrEqualTo(SCREEN_HEIGHT);
            make.centerY.equalTo(self.view.centerY);
            make.centerX.equalTo(self.view.centerX);

        }];
    
    __block FLAnimatedImage *animatedImage = nil;
    NSData *savedata =[[NSUserDefaults standardUserDefaults] dataForKey:[NSString stringWithFormat:@"GIF_%@",self.gifid]];
    if (savedata) {
        [hud hideAnimated:YES];
        animatedImage = [FLAnimatedImage animatedImageWithGIFData:savedata];
        self.gifImg.animatedImage = animatedImage;
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mainHost,self.gifString]]];
            
            if (data != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
                    self.gifImg.animatedImage = animatedImage;
                 });
            }
        });
    }
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
