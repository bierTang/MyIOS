//
//  CSDataBase.h
//  community
//
//  Created by MAC on 2019/12/25.
//  Copyright © 2019 cwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "CTBFileMannger.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSDataBase : NSObject

#pragma mark  ---------------支持层-----------------
/**
 获取单例
 */
+ (CSDataBase *)sharedInstance;

/**
 创建数据库
 */
+(FMDatabaseQueue *)creatDataBaseQueue;
+(FMDatabase *)creatDataBase;

/**
 关闭数据库
 */
+(void)closeDataBase;


/**
 创建数据库表格
 */
+(void)creatTableWithsql:(NSString *)sqlStr tableName:(NSString *)tableName;

/**
 创建数据库此app下所有表格
 */
+(void)creatAppDataBaseTable;

/**
 *插入或者更新
 */
+ (void)insertCacheDataByIdentify:(NSString *)identify CacheType:(NSString *)cacheType versionCode:(NSString *)versionCode data:(id)data;

/**
 *删除表中数据
 */
+ (void)deleteCacheDataByCacheType:(NSString *)cacheType Identify:(NSString *)identify VersionCode:(NSString *)versionCode;

/**
 *查询表
 */
+(NSString *)cacheDataOnlyByCacheType:(NSString *)cacheType;
/**
 *查询表获取数组
 */
+(NSMutableArray *)cacheArrayDataByCacheType:(NSString *)cacheType;

#pragma mark -- common 存储
/**
 *查询
 */
+(id)cacheDataByCacheType:(NSString *)cacheType Identify:(NSString *)identify;
/**
 *删除表中所有数据
 */
+ (void)deleteCacheDataByCacheType:(NSString *)cacheType;

/**
 *按条件查询
 */
+(NSString *)cacheDataByCacheType:(NSString *)cacheType Identify:(NSString *)identify versionCode:(NSString *)versionCode;

/**
 *条件查询表 获取数组
 */
+(NSMutableArray *)cacheArrayDataByCacheType:(NSString *)cacheType Identify:(NSString *)identify;


@end

NS_ASSUME_NONNULL_END
