//
//  CSEditVC.m
//  community
//
//  Created by 蔡文练 on 2019/10/28.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CSEditVC.h"

@interface CSEditVC ()
@property (weak, nonatomic) IBOutlet UIButton *confirnBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@end

@implementation CSEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.confirnBtn.layer.cornerRadius = 4;
    self.confirnBtn.clipsToBounds = YES;
}

- (IBAction)cancelAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)confirmAction:(id)sender {
   
    if (self.nameTF.text.length > 0) {
        if (self.block) {
            self.block(self.nameTF.text);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [[MYToast makeText:@"请输入昵称"]show];
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
