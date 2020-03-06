//
//  DownVideoTool.m
//  community
//
//  Created by 蔡文练 on 2019/11/20.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "DownVideoTool.h"

@implementation DownVideoTool

//-----下载视频--
- (void)downloadVideo:(NSString *)url{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *name = [HelpTools getCurrentStringTime];
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory,name];
     [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullPath error:nil];
    NSURL *urlNew = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
//    /var/mobile/Containers/Data/Application/97EC2D0A-FA11-4BF3-924A-ECF44D396822/Documents/2020-01-02.mp4
//    /var/mobile/Containers/Data/Application/BDA48A29-0836-4E98-9ADC-6388A0B739E6/Documents/2020-01-02.mp4
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //
//        NSLog(@"进度：：%@--%f",downloadProgress,downloadProgress.fractionCompleted);
        if (self.progressBlock) {
            self.progressBlock(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //
        NSLog(@"ERROR::%@",error);
        if (!error) {
           
            [self saveVideo:fullPath];
        }else{
            [[MYToast makeText:@"保存失败"]show];
        }
        
    }];

    [task resume];
    
}

//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo:(NSString *)videoPath{
    
    if (videoPath) {
        NSURL *url = [NSURL URLWithString:videoPath];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible)
        {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}


//保存视频完成之后的回调
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
       [[MYToast makeText:@"视频保存失败"]show];
    }
    else {
        NSLog(@"保存视频成功");
        [[MYToast makeText:@"视频保存成功"]show];
        if (self.completBlock) {
            self.completBlock();
        }
    }
}


@end
