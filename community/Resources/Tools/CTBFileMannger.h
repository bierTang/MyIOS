

#import <Foundation/Foundation.h>
/**
 文件基础管理类
 */
#define PathAppend(strA,strB) [strA stringByAppendingPathComponent:strB]

@interface CTBFileMannger : NSObject
/**
 获取单例
 */
+ (CTBFileMannger *)sharedInstance;

/**
 获取制定沙盒下得路径
 */
+ (NSString *)AppFilePath:(NSUInteger)path;

/**
 document沙盒路径
 */
+ (NSString *)DocumentPath;

/**
 获取Caches目录路径
 */
+ (NSString *)CachePath;

/**
 获取tmp目录路径
 */
+ (NSString *)tmpPath;

/**
 获取配置文件路径
 */
+ (NSString *)configFilePath;
/**
 *Library/Application Support目录
 */
+(NSString *)LibraryPath;
@end
