//
//  SessionModel.h
//  community
//
//  Created by 蔡文练 on 2019/10/9.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SessionModel : NSObject


@property (nonatomic,assign)NSInteger ad_type;  //" = 1;
@property (nonatomic,strong)NSString *content;  // = "/uploads/files/20191009/dfa134000cc06b6d21ebc79ef61c9d1d.mp4";
@property (nonatomic,strong)NSString *create_time;  //" = 1570610823;
@property (nonatomic,strong)NSString *descriptions;  // = xxxxxxxxxx;
@property (nonatomic,assign)NSInteger end_time;  //" = 0;
@property (nonatomic,assign)NSInteger group_id;  //" = 7;
@property (nonatomic,assign)NSInteger id;  //" = 7;
@property (nonatomic,strong)NSString *idss;  // = 17;
@property (nonatomic,strong)NSString *images;  // = "uploads/images/20190922/92ae8a166cdfa36920ada5a3ecb48fd9.jpg";
@property (nonatomic,strong)NSString *logo;  // = 7;
@property (nonatomic,strong)NSString *name;  // = "";
@property (nonatomic,assign)NSInteger sort;  // = 0;
@property (nonatomic,assign)NSInteger start_time;  //" = 0;
@property (nonatomic,assign)NSInteger status;  // = 0;
@property (nonatomic,assign)NSInteger timeset;  // = 0;
@property (nonatomic,assign)NSInteger update_time;  //" = 0;

@property (nonatomic,strong)NSString *story_id;  // = 17;

@property (nonatomic,strong)NSArray *images_array;  //" = 0;


@property (nonatomic,strong)NSString *user_name;
@property (nonatomic,strong)NSString *nick_name;
@property (nonatomic,strong)NSString *user_avatar;  

@property (nonatomic,assign)BOOL mp3isPlaying;  

@property (nonatomic,assign)BOOL gifLoaded;

@property (nonatomic,assign)BOOL hadLoaded;

@end

NS_ASSUME_NONNULL_END
