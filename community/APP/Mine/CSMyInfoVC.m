//
//  CSMyInfoVC.m
//  community
//
//  Created by 蔡文练 on 2019/10/28.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CSMyInfoVC.h"
#import "CSEditVC.h"
#import "HeadImgSelectVC.h"

@interface CSMyInfoVC ()<TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *mobileName;

@property (nonatomic,copy)NSString *nameStr;
@property (nonatomic,copy)NSString *imagePath;

@end

@implementation CSMyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    
    self.imagePath = [UserTools avatar];
    if (self.imagePath.length == 0) {
        self.imagePath = @" ";
    }
    self.nameStr = [UserTools nickName];
    self.nickName.text = self.nameStr;
    
//    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",mainHost,self.imagePath]] placeholderImage:[UIImage imageNamed:@"headImg_base"]];
    NSString *img = [UserTools avatar];
    if (img.integerValue <= 0) {
        img = @"1";
    }
    self.headImage.image = [UIImage imageNamed:img];
    
    self.mobileName.text = [[CSCaches shareInstance]getUserModel:USERMODEL].mobile;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (IBAction)changeImage:(id)sender {
     NSLog(@"改头像");
//    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
//        // 是否显示可选原图按钮
//        imagePicker.allowPickingOriginalPhoto = NO;
//        // 是否允许显示视频
//        imagePicker.allowPickingVideo = NO;
//        // 是否允许显示图片
//        imagePicker.allowPickingImage = YES;
//        //只能present
//        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:imagePicker animated:YES completion:nil];
//
//        imagePicker.allowCrop = YES;
//        imagePicker.showSelectBtn = NO;
    HeadImgSelectVC *vc = [[HeadImgSelectVC alloc]init];
    vc.ImgSelectBlock = ^(NSString * _Nonnull data) {
        self.headImage.image = [UIImage imageNamed:data];
        self.imagePath = data;
        [self requstChange];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)changeNickname:(id)sender {
    NSLog(@"改名");
    CSEditVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CSEditVC"];
    
    __weak typeof(self) wself = self;
    vc.block = ^(NSString * _Nonnull name) {
        wself.nameStr = name;
        wself.nickName.text = name;
        [wself requstChange];
    };
    
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

///选择图片后的回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    NSLog(@"ppp1111::::%@",assets);
    
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    self.headImage.image = photos[0];
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]uploadImage:photos[0] backBlock:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"上传：%@",result);
        if (state == AppRequestState_Success) {
            wself.imagePath = result[@"data"][@"filePath"];
            [wself requstChange];
        }
        
    }];
}


-(void)requstChange{
    if (self.imagePath.integerValue == 0) {
        self.imagePath = @"1";
    }
    NSDictionary *param = @{@"avatar":self.imagePath,@"user_id":[UserTools userID],@"nickname":self.nameStr};
//    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]requestchangeMyinfo:param Block:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"修改:%@",result);
        if (state == AppRequestState_Success) {
            [[NSNotificationCenter defaultCenter]postNotificationName:NOT_FRESHMYINFO object:nil];
        }else{
            [[MYToast makeText:@"修改失败"]show];
        }
    }];
    
}


@end
