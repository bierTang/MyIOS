//
//  ScanListController.m
//  community
//
//  Created by JackTang on 2020/5/20.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "ScanListController.h"
#import "RecommedVC.h"
@interface ScanListController ()<UITextFieldDelegate>

@property (nonatomic,strong)RecommedVC *recommedVC;
@end

@implementation ScanListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"efefef"];
 
   [self setupNav];
    self.recommedVC = [[RecommedVC alloc]init];
                self.recommedVC.scanStr = @"";
                self.recommedVC.type = @"666";
                [self addChildViewController:self.recommedVC];
                [self.view addSubview:self.recommedVC.view];
                [self.recommedVC.view makeConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.right.equalTo(0);
                    make.top.equalTo(self.searchTF.bottom).offset(15);
                }];
//    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)setupNav{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(310*K_SCALE + 16, ItemSpaceHight, 44, 30*K_SCALE);
    
    [cancelBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"53668A"] forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(16, ItemSpaceHight, 300*K_SCALE, 30*K_SCALE)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    bgView.layer.cornerRadius = 2;
    bgView.clipsToBounds = YES;
    
    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(5*K_SCALE, 7*K_SCALE, 16*K_SCALE, 16*K_SCALE)];
    searchImg.image = [UIImage imageNamed:@"searchIcon"];
    [bgView addSubview:searchImg];
    
    
    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(26*K_SCALE, 0, 300*K_SCALE, 30*K_SCALE)];
    self.searchTF.delegate = self;
    [bgView addSubview:self.searchTF];
    self.searchTF.returnKeyType = UIReturnKeyGoogle;
    self.searchTF.placeholder = @"请输入关键字";
    self.searchTF.font = [UIFont systemFontOfSize:16*K_SCALE];
    
//    [self.searchTF addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventEditingChanged];
    
    
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
////    NSLog(@"搜索1：：%@",string);
////    NSLog(@"搜索2：：%@",textField.text);
//    return YES;
//}
// 在文本框中按回车的处理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"搜索%@", textField.text);
    if (textField.text.length > 0) {
       
        [self.recommedVC setScanStr:textField.text];

        
    }
    if (![textField isExclusiveTouch]) {
        [textField resignFirstResponder];
    }
    return YES;
}



-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
