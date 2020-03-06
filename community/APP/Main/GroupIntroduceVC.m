//
//  GroupIntroduceVC.m
//  community
//
//  Created by 蔡文练 on 2019/11/26.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "GroupIntroduceVC.h"

@interface GroupIntroduceVC ()

@end

@implementation GroupIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [UILabel labelWithTitle:[CSCaches shareInstance].groupInfoModel.introduce font:15 textColor:@"000000" textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:label];
    label.numberOfLines = 0;
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.top.equalTo(16);
    }];
    
    
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
