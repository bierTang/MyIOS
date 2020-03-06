//
//  AppRequest+Search.h
//  community
//
//  Created by 蔡文练 on 2019/10/14.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "AppRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppRequest (Search)


-(void)requestSearchList:(NSString *)words showAll:(NSString *)isAll Block:(void(^)(AppRequestState state,id result))callBack;


-(void)requestHotWordsListBlock:(void(^)(AppRequestState state,id result))callBack;

@end

NS_ASSUME_NONNULL_END
