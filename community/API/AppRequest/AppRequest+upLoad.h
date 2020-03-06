//
//  AppRequest+upLoad.h
//  community
//
//  Created by 蔡文练 on 2019/9/23.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "AppRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppRequest (upLoad)

-(void)uploadImage:(UIImage *)image backBlock:(void(^)(AppRequestState state,id result))callBack;

-(void)requstPostContent:(NSDictionary *)param Block:(void(^)(AppRequestState state,id result))callBack;


-(void)uploadVideo:(id)video backBlock:(void(^)(AppRequestState state,id result))callBack;
@end

NS_ASSUME_NONNULL_END
