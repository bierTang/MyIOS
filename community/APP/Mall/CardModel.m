//
//  CardModel.m
//  community
//
//  Created by 蔡文练 on 2019/11/11.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "CardModel.h"

@implementation CardModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"idss":@"id",@"descriptions":@"description"};
}

@end
