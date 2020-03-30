//
//  SessionModel.m
//  community
//
//  Created by 蔡文练 on 2019/10/9.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "WebModel.h"

@implementation WebModel


/**
 如果需要指定“唯一约束”字段, 在模型.m文件中实现该函数,这里指定 id 为“唯一约束”.
 */
+(NSArray *)bg_uniqueKeys{
    return @[@"id"];
}

/**
 自定义“联合主键” ,这里指定 name和age 为“联合主键”.
 */
+(NSArray *)bg_unionPrimaryKeys{
    return @[@"id"];
}


@end
