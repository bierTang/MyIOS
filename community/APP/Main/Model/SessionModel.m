//
//  SessionModel.m
//  community
//
//  Created by 蔡文练 on 2019/10/9.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "SessionModel.h"

@implementation SessionModel


+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"idss":@"id",@"descriptions":@"description"};
}
@end
