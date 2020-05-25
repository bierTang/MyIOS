//
//  VideoModel.m
//  community
//
//  Created by MAC on 2020/1/13.
//  Copyright © 2020 cwl. All rights reserved.
//

#import "VideoModel.h"
NSInteger const SJMediaCoverTag = 101;
@implementation VideoModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"idss":@"id",@"descriptions":@"description"};
}


@end
