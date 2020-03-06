//
//  CSRecordModel.h
//  community
//
//  Created by 蔡文练 on 2019/11/9.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSRecordModel : NSObject

@property (nonatomic,strong) NSString *idss;

@property (nonatomic,strong) NSString *user_type;   //":3,
@property (nonatomic,strong) NSString *uid;   //":1,
@property (nonatomic,strong) NSString *user_id;   //":28,
@property (nonatomic,strong) NSString *descriptions;   //":"多送了金币1个",
@property (nonatomic,strong) NSString *user_coin;   //":"8",
@property (nonatomic,strong) NSString *content;   //":"扣除金币1个",
@property (nonatomic,strong) NSString *coin;   //":"1",
@property (nonatomic,assign) NSInteger type;   //":2,
@property (nonatomic,strong) NSString *create_time;   //":1573200448,
@property (nonatomic,strong) NSString *status;   //":0,
@property (nonatomic,strong) NSString *group_id;   //":null

@property (nonatomic,strong) NSString *exchange_type;   //":1573200448,


@property (nonatomic,strong) NSString *day_time;
@property (nonatomic,strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
