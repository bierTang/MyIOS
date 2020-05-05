//
//  AppRequest+upLoad.m
//  community
//
//  Created by 蔡文练 on 2019/9/23.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "AppRequest+upLoad.h"

@implementation AppRequest (upLoad)


-(void)uploadVideo:(id)video backBlock:(void(^)(AppRequestState state,id result))callBack{
    
    
    [self.manager POST:[NSString stringWithFormat:@"%@/index.php/index/common/upl",mainHost] parameters:@{@"images":video} headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"progress is %@",uploadProgress);
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        NSLog(@"message = %@",[responseObject valueForKey:@"msg"]);
        callBack(AppRequestState_Success,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@",error);
        callBack(AppRequestState_Fail,error);
    }];
    
    
}



-(void)uploadImage:(UIImage *)image backBlock:(void(^)(AppRequestState state,id result))callBack{
    
    NSData *datass = UIImageJPEGRepresentation(image, 1.0);
    [self.manager POST:[NSString stringWithFormat:@"%@/index.php/index/common/upload",mainHost] parameters:@{@"images":datass} headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
            // 图片经过等比压缩后得到的二进制文件
        
//        NSData *imageData =UIImageJPEGRepresentation(image, 1.f);
//            // 默认图片的文件名, 若fileNames为nil就使用
//            
////            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
////            formatter.dateFormat = @"yyyyMMddHHmmss";
////            NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *imageFileName = @"IMG_0871.jpg";//[NSString stringWithFormat:@"%@.%@",str,@"jpg"];
////            NSLog(@"imageData = %@",imageData);
//        
//            [formData appendPartWithFileData:imageData
//                                        name:@"file"
//                                    fileName:imageFileName
//                                    mimeType:[NSString stringWithFormat:@"image/%@",@"jpg"]];
                
//        NSData *data = UIImageJPEGRepresentation(image, 1.0);
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        // 设置时间格式
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
//        [formData appendPartWithFileData:data name:@"img1" fileName:fileName mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"progress is %@",uploadProgress);
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        NSLog(@"message = %@",[responseObject valueForKey:@"msg"]);
        callBack(AppRequestState_Success,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@",error);
        callBack(AppRequestState_Fail,error);
    }];
    
    
}


-(void)requstPostContent:(NSDictionary *)param Block:(void(^)(AppRequestState state,id result))callBack{
    NSString *url = @"/index.php/index/discover/discover_post";
    
    [[AppRequest sharedInstance]doRequestWithUrl:url Params:param Callback:^(BOOL isSuccess, NSDictionary *result) {
        AppRequestState state = [self requestStateFromStatusCode:result[AppRequestStateName]];
        
        callBack(state,result);
    } HttpMethod:AppRequestPost isAni:YES];
}



@end
