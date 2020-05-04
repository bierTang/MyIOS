//
//  WHCaches.h
//  WealthHo
//
//  Created by 888 on 2019/3/20.
//  Copyright © 2019 GF. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface CSCaches : NSObject

//额外存一份公共的，删除数据库的时候用
@property (nonatomic,strong)NSArray<ChatListModel *> *removeArr;

@property (nonatomic,strong)NSString *token;

@property (nonatomic,strong)NSString *refreshToken;

@property (nonatomic,strong)NSUserDefaults *userDefault;

@property (nonatomic,strong)UINavigationController *navVC;

@property (nonatomic,strong)ChatListModel *groupInfoModel;

@property (nonatomic,strong)NSArray *lunboArr;

@property (nonatomic,strong)NSString *webUrl;
@property (nonatomic,assign)NSInteger webId;


@property (nonatomic,strong)NSString *fileWebUrl;

@property (nonatomic,strong)NSString *liveDescString;
@property (nonatomic,strong)NSString *live_url;
@property (nonatomic,strong)NSString *anchor_url;
@property (nonatomic,strong)LiveModel *currentLiveModel;

+(CSCaches *)shareInstance;


///存本地
-(void)saveUserDefalt:(NSString *)key value:(NSString *)value;
-(void)saveUserDefaltFloat:(NSString *)key value:(CGFloat)value;

///取本地
-(NSString *)getValueForKey:(NSString *)key;

-(void)saveModel:(NSString *)key value:(nonnull id)obj;
-(UserModel *)getUserModel:(NSString *)key;


-(void)removeDefaultValueKey:(NSString *)key;
//+(NSString *)getUserID;

@end

NS_ASSUME_NONNULL_END
