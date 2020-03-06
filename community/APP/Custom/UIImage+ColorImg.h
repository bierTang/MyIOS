//
//  UIImage+ColorImg.h
//  community
//
//  Created by 蔡文练 on 2019/9/23.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ColorImg)


+(UIImage *)createImageWithColor:(UIColor*)color;

/**
 *保存图片
 */
//+(NSString *)saveImage:(UIImage *)image;
/**
 *获取图片
 */
+ (UIImage *)getImage:(NSString *)filePath;


/**
 *改变二维码尺寸大小
 */
+ (UIImage *)qrCodeImageWithContent:(NSString *)content codeImageSize:(CGFloat)size;

///带logo二维码
+ (UIImage *)qrCodeImageWithContent:(NSString *)QRurl QRSize:(CGFloat)size logo:(UIImage *)logo logoFrame:(CGRect)logoFrame red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@end

NS_ASSUME_NONNULL_END
