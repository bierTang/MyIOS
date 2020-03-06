//
//  NSDictionary+CNLog.m
//  NetworkTest
//
//  Created by 周超 on 2016/12/16.
//  Copyright © 2016年 周超. All rights reserved.
//

#import "xcodeCNLog.h"

@implementation NSDictionary (CNLog)
-(NSString *)descriptionWithLocale:(id)locale{
    NSMutableString * str=[NSMutableString string];
    [str appendString:@"\t{\n\t"];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [str appendString:[NSString stringWithFormat:@"\t%@:",key]];
        [str appendString:[NSString stringWithFormat:@"%@;\n\t",obj]];
    }];
    [str appendString:@"},"];
    return str;
}
@end


@implementation NSArray (CNLog)
-(NSString *)descriptionWithLocale:(id)locale{
    NSMutableString * str=[NSMutableString string];
    [str appendString:@"(\n\t"];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [str appendString:[NSString stringWithFormat:@"%@\n\t",obj]];
    }];
    
    [str appendString:@")"];
    return str;
}
@end
