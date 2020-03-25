//
//  CSMyverifyVC.m
//  community
//
//  Created by 蔡文练 on 2019/9/24.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CSMyverifyVC.h"
#import "HeadImgSelectVC.h"
#import "CSLoginVC.h"
@interface CSMyverifyVC ()<TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UITextField *nickName;

@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

@property (weak, nonatomic) IBOutlet UIButton *completeBtn;

@property (nonatomic,copy)NSString *imageStr;
@end

@implementation CSMyverifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self.nickName addTarget:self action:@selector(changevalue:) forControlEvents:UIControlEventEditingChanged];
    [self.account addTarget:self action:@selector(changevalue:) forControlEvents:UIControlEventEditingChanged];
    [self.password addTarget:self action:@selector(changevalue:) forControlEvents:UIControlEventEditingChanged];
    [self.confirmPassword addTarget:self action:@selector(changevalue:) forControlEvents:UIControlEventEditingChanged];
    
    [self.completeBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"b5eccf"]] forState:UIControlStateDisabled];
    [self.completeBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"09c66a"]] forState:UIControlStateNormal];
    
    self.completeBtn.layer.cornerRadius = 4;
    self.completeBtn.clipsToBounds = YES;
    
    self.imageStr = [UserTools avatar];
    if (self.imageStr.integerValue == 0) {
        self.imageStr = @"1";
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)chooseImage:(UITapGestureRecognizer *)sender {
    NSLog(@"选择图片");
//    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
//
//    // 是否显示可选原图按钮
//    imagePicker.allowPickingOriginalPhoto = NO;
//    // 是否允许显示视频
//    imagePicker.allowPickingVideo = NO;
//    // 是否允许显示图片
//    imagePicker.allowPickingImage = YES;
//
//    //只能present
//    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:imagePicker animated:YES completion:nil];
//
//    imagePicker.allowCrop = YES;
////    imagePicker.cropRect = CGRectMake(0, imagePicker.cropRect.origin.y-50, self.view.bounds.size.width, SCREEN_WIDTH);
//    imagePicker.showSelectBtn = NO;
    HeadImgSelectVC *vc = [[HeadImgSelectVC alloc]init];
    vc.ImgSelectBlock = ^(NSString * _Nonnull data) {
        self.imageStr = data;
        self.headImg.image = [UIImage imageNamed:data];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)changevalue:(UITextField *)textfield{
    
    if (self.nickName.text.length > 0 && self.account.text.length == 11 && self.password.text.length >= 6) {
        self.completeBtn.enabled = YES;
    }else{
        self.completeBtn.enabled = NO;
    }
    
}


- (IBAction)completeAction:(id)sender {
    
    
    if(self.account.text.length != 11){
        [[MYToast makeText:@"请输入正确手机号码"]show];
        return;
    }
    if(self.password.text.length < 6){
        [[MYToast makeText:@"请输入6位以上密码"]show];
        return;
    }
    if(self.nickName.text.length < 1){
        [[MYToast makeText:@"请输入昵称"]show];
        return;
    }
    if (![self.confirmPassword.text isEqualToString:self.password.text]) {
        [[MYToast makeText:@"两次密码输入不一致"]show];
        return;
    }
//    if(self.imageStr.length < 5){
//        [[MYToast makeText:@"请先上传头像"]show];
//        return;
//    }
    
    NSString *agentid = @"0";
    if ([UserTools AgentID].length > 0) {
        agentid = [UserTools AgentID];
    }
    
    NSMutableDictionary *params = @{@"nickname":self.nickName.text,@"mobile":self.account.text,@"password":[HelpTools md5String:self.password.text],@"agent_code":agentid,@"device_id":[HelpTools getDeviceIDInKeychain]}.mutableCopy;
    if ([UserTools AgentID]) {
        [params setObject:[UserTools AgentID] forKey:@"agent_code"];
    }
    if ([UserTools ShareUserId]) {
        [params setObject:[UserTools ShareUserId] forKey:@"user_code"];
    }
    if (self.imageStr.intValue > 0) {
        [params setObject:self.imageStr forKey:@"avatar"];
//        params = @{@"nickname":self.nickName.text,@"mobile":self.account.text,@"password":[HelpTools md5String:self.password.text],@"avatar":self.imageStr,@"agent_id":agentid};
    }else{
        
    }
    [[AppRequest sharedInstance]requestRegister:params Block:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"注册：：%@",result);
        
        if (state == AppRequestState_Success) {
            [[MYToast makeText:@"注册成功"]show];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOT_FRESHMYINFO object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if (result[@"msg"]) {
                [[MYToast makeText:result[@"msg"]]show];
            }else
            [[MYToast makeText:@"注册失败"]show];
        }
    }];
    
}

- (IBAction)agreeOrNot:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

- (IBAction)seeProtocal:(id)sender {
    NSLog(@"许可协议");
}

///选择图片后的回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    NSLog(@"ppp1111::::%@",assets);
    
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    self.headImg.image = photos[0];
    NSLog(@"ppp222:::%@---%@",assets,infos);
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]uploadImage:photos[0] backBlock:^(AppRequestState state, id  _Nonnull result) {
        NSLog(@"上传：%@",result);
        if (state == AppRequestState_Success) {
            wself.imageStr = result[@"data"][@"filePath"];
        }
        
    }];
}
- (IBAction)toLogin:(id)sender {
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"登录";
    CSLoginVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CSLoginVC"];

    [self.navigationController pushViewController:vc animated:YES];
}





@end
