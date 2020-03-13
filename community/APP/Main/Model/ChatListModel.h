//
//  ChatListModel.h
//  community
//
//  Created by 蔡文练 on 2019/10/9.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatListModel : NSObject
@property (nonatomic,copy)NSString *update_time;    //" = 1570435365;
@property (nonatomic,copy)NSString *create_time;    //" = 1570435365;
@property (nonatomic,copy)NSString *idss;    // = 7;
@property (nonatomic,copy)NSString *introduce;    // = 66666666;
@property (nonatomic,assign)BOOL is_allow;    //" = 1;
@property (nonatomic,copy)NSString *logo;    // = 16;
@property (nonatomic,copy)NSString *message;    // = "/uploads/images/20191007/d9efdbde8af6041ce77725587f6820bc.gif";
@property (nonatomic,copy)NSString *name;    // = "\U957f\U6c991\U7fa4";
@property (nonatomic,copy)NSString *path;    // =                 (
//                        "uploads/images/20190925/1113e9f821d27780a350098be59b80aa.jpeg"
//                        );
@property (nonatomic,assign)NSInteger type;    // = 0;  0图片 1视频   2文字


@property (nonatomic,assign)NSInteger need_coin;  

@property (nonatomic,assign)BOOL group_allow;
@property (nonatomic,assign)NSInteger group_expiration;

@property (nonatomic,copy)NSString *life_expiration;

@property (nonatomic,assign)BOOL isFreeGroup;


@end

NS_ASSUME_NONNULL_END
