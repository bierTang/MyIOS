//
//  VideoModel.h
//  community
//
//  Created by MAC on 2020/1/13.
//  Copyright © 2020 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoModel : NSObject

@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *idss;

@property (nonatomic,strong)NSString *is_best;
@property (nonatomic,copy)NSString *is_diff;


@property (nonatomic,copy)NSString *category_id;    //" = 18;
@property (nonatomic,copy)NSString *create_time;    //" = 1578638494;
@property (nonatomic,copy)NSString *favorite_num;    //" = 0;
@property (nonatomic,copy)NSString *file_url;    //" = "http://199.180.102.241:2100/20200106/sMMdLkf2/mp4/sMMdLkf2.mp4";
@property (nonatomic,copy)NSString *gif_url;    //" = "http://199.180.102.241:2100/20200106/sMMdLkf2/1.gif";
@property (nonatomic,assign)CGFloat img_h;    //" = 400;
@property (nonatomic,assign)CGFloat img_w;    //" = 660;
//@property (nonatomic,copy)NSString *is_best;    //" = 0;
@property (nonatomic,strong)NSString *like_num;    //" = 0;

@property (nonatomic,assign)NSString *is_favorite;
@property (nonatomic,assign)NSString *is_like;
@property (nonatomic,copy)NSString *logo;    // = "http://199.180.102.241:2100/20200106/sMMdLkf2/1.jpg";
@property (nonatomic,copy)NSString *name;    // = 1578118887;
@property (nonatomic,copy)NSString *nick_name;    //" = "\U8d85\U7ea7\U7ba1\U7406\U5458";
@property (nonatomic,copy)NSString *sort;    // = 50;
@property (nonatomic,assign)NSInteger status;    // = 1;
@property (nonatomic,assign)NSInteger timeset;    // = 0;
@property (nonatomic,assign)NSInteger type;    // = 0;
@property (nonatomic,copy)NSString *uid;    // = 1;
@property (nonatomic,copy)NSString *update_time;    //" = 1578638494;
@property (nonatomic,copy)NSString *user_avatar;    //" = "uploads/images/20191030/023c732399c9ad553f9a40c37c7bf045.png";
@property (nonatomic,copy)NSString *user_name;    //" = admin;@property (nonatomic,copy)NSString *video_id" = p5nTDJRhAHu7SBKF;
@property (nonatomic,copy)NSString *video_url;    //" = "http://199.180.102.241:2100/20200106/sMMdLkf2/index.m3u8";
@property (nonatomic,copy)NSString *descriptions;

@property (nonatomic,strong)NSArray *images_array;
@property (nonatomic,strong)NSString *link;

@end

NS_ASSUME_NONNULL_END
