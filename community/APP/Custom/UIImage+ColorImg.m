//
//  UIImage+ColorImg.m
//  community
//
//  Created by 蔡文练 on 2019/9/23.
//  Copyright © 2019 cwl. All rights reserved.
//

#import "UIImage+ColorImg.h"

@implementation UIImage (ColorImg)

+(UIImage *)createImageWithColor:(UIColor*)color{
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();UIGraphicsEndImageContext();
    return theImage;
    
}


+ (UIImage *)getImage:(NSString *)filePath {
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}

#pragma mark --
//生成最原始的二维码
+ (CIImage *)qrCodeImageWithContent:(NSString *)content{
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [qrFilter setValue:contentData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *image = qrFilter.outputImage; return image;
    
}
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
/**
 *改变二维码尺寸大小
 */
+ (UIImage *)qrCodeImageWithContent:(NSString *)content codeImageSize:(CGFloat)size{
    
    CIImage *image = [self qrCodeImageWithContent:content];
    
    CGRect integralRect = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(integralRect), size/CGRectGetHeight(integralRect));
    
    size_t width = CGRectGetWidth(integralRect)*scale;
    
    size_t height = CGRectGetHeight(integralRect)*scale;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:integralRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, integralRect, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}
//改变二维码颜色
+ (UIImage *)qrCodeImageWithContent:(NSString *)content codeImageSize:(CGFloat)size red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    UIImage *image = [self qrCodeImageWithContent:content codeImageSize:size];
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t *rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpaceRef, kCGBitmapByteOrder32Little|kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    //遍历像素, 改变像素点颜色
    int pixelNum = imageWidth * imageHeight;
    
    uint32_t *pCurPtr = rgbImageBuf;
    
    for (int i = 0; i<pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            uint8_t* ptr = (uint8_t*)pCurPtr; ptr[3] = red; ptr[2] = green; ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr; ptr[0] = 0;
        } }
    //取出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpaceRef, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider); UIImage *resultImage = [UIImage imageWithCGImage:imageRef]; CGImageRelease(imageRef);
    CGContextRelease(context); CGColorSpaceRelease(colorSpaceRef);
    return resultImage;
    
}
+ (UIImage *)qrCodeImageWithContent:(NSString *)QRurl QRSize:(CGFloat)size logo:(UIImage *)logo logoFrame:(CGRect)logoFrame red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    
    UIImage *image = [UIImage qrCodeImageWithContent:QRurl codeImageSize:175*K_SCALE];
    //[self qrCodeImageWithContent:QRurl codeImageSize:size red:red green:green blue:blue];
    //有 logo 则绘制 logo
    if (logo != nil) {
        UIGraphicsBeginImageContext(image.size);
        
        [image drawInRect:CGRectMake(0, 0,size,size)]; [logo drawInRect:logoFrame];
        
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext(); UIGraphicsEndImageContext();
        
        return resultImage;
        
    }
    else{
        return image;
    }
}


//+(NSString *)saveImage:(UIImage *)image{
//    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
//                          [NSString stringWithFormat:@"%@.%@",[CustomTimeTools getCurrentTimestamp],@"png"]];  // 保存文件的名称
//    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath   atomically:YES]; // 保存成功会返回YES
//    if (result == YES) {
//        DLog(@"保存成功");
//    }
//    return filePath;
//}


@end
