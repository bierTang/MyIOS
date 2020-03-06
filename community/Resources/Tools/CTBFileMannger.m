
#import "CTBFileMannger.h"

#define configFile @"WealthHo.plist"

static CTBFileMannger * sharedInstance = nil;

@implementation CTBFileMannger

//获取单例
+ (CTBFileMannger *)sharedInstance
{
    @synchronized(self)
    {
        if (!sharedInstance)
            sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

//获取制定沙盒下得路径
+ (NSString *)AppFilePath:(NSUInteger)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(path, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}

// 获取Documents目录路径
+ (NSString *)DocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}

// 获取Caches目录路径
+ (NSString *)CachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return cachesDir;
}

// 获取tmp目录路径
+ (NSString *)tmpPath
{
    NSString *tmpDir = NSTemporaryDirectory();
    return tmpDir;
}

#pragma mark config
//获取配置文件路径
+ (NSString *)configFilePath
{
    return PathAppend([self CachePath], configFile);
}
+(NSString *)LibraryPath{
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask,YES)[0] stringByAppendingPathComponent:@"CaiHo"];
    return libraryPath;
}
@end
