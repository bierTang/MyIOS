//
//  CSLoginVC.m
//  community
//
//  Created by 蔡文练 on 2019/9/29.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CSLoginVC.h"

@interface CSLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation CSLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
   

    
    [self.mobileTF addTarget:self action:@selector(changevalue:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTF addTarget:self action:@selector(changevalue:) forControlEvents:UIControlEventEditingChanged];
    
    [self.loginBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"b5eccf"]] forState:UIControlStateDisabled];
    [self.loginBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"09c66a"]] forState:UIControlStateNormal];
    
    self.loginBtn.layer.cornerRadius = 4;
    self.loginBtn.clipsToBounds = YES;

}


-(void)changevalue:(UITextField *)textfield{
    
    if (self.mobileTF.text.length == 11 && self.passwordTF.text.length >= 6) {
        self.loginBtn.enabled = YES;
    }else{
        self.loginBtn.enabled = NO;
    }
    
}

- (IBAction)checkAction:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
}


- (IBAction)login:(id)sender {
    if(self.mobileTF.text.length != 11){
        [[MYToast makeText:@"请输入正确手机号码"]show];
        return;
    }
    
    __weak typeof(self) wself = self;
    [[AppRequest sharedInstance]requestLogin:self.mobileTF.text password:[HelpTools md5String:self.passwordTF.text] Block:^(AppRequestState state, id  _Nonnull result) {
        if (state == AppRequestState_Success) {
            [[NSNotificationCenter defaultCenter]postNotificationName:NOT_FRESHMYINFO object:nil];
            for (UIViewController *vc in wself.navigationController.viewControllers) {
               
                if ([vc isKindOfClass:NSClassFromString(@"CSMineViewController")]||[vc isKindOfClass:NSClassFromString(@"CSMainViewController")]) {
                    [wself.navigationController popToViewController:vc animated:YES];
                }
            }
        }else if(result[@"msg"]){
            [[MYToast makeText:result[@"msg"]]show];
        }else{
            [[MYToast makeText:@"登录失败，请检查网络"]show];
        }
        
    }];
//    [[AppRequest sharedInstance]doRequestWithUrl:@"/index.php/index/user/login" Params:param Callback:^(BOOL isSuccess, id result) {
//        NSLog(@"登录：：%@",result);
//
//    } HttpMethod:AppRequestPost isAni:YES];
}

@end
