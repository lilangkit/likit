//
//  LKFileUtil.m
//  likit
//
//  Created by 李浪 on 2021/3/3.
//

#import "LKFileUtil.h"

@implementation LKFileUtil

#pragma mark 获取沙盒文件路径
/**
 * 获取沙盒根路径
 *
 * @return 根路径
 */
+ (NSString *)getHomeFilePath {
    NSString *homeFilePath = NSHomeDirectory();
    return homeFilePath;
}

/**
 * 获取沙盒Document路径
 *
 * @return Document路径
 */
+ (NSString *)getDocumentFilePath {
    NSString *documentFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return documentFilePath;
}

/**
 * 获取沙盒library路径
 *
 * @return library路径
 */
+ (NSString *)getLibraryFilePath {
    NSString *libraryFilePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    return libraryFilePath;
}

/**
 * 获取沙盒cache路径
 *
 * @return cache路径
 */
+ (NSString *)getCacheFilePath {
    NSString *cacheFilePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return cacheFilePath;
}

/**
 * 获取沙盒Preference路径
 *
 * @return Preference路径
 */
+ (NSString *)getPreferenceFilePath {
    NSString *preferenceFilePath = [self getLibraryFilePath];
    preferenceFilePath = [preferenceFilePath stringByAppendingPathComponent:@"Preferences"];
    return preferenceFilePath;
}

/**
 * 获取沙盒tmp路径
 *
 * @return tmp路径
 */
+ (NSString *)getTmpFilePath {
    NSString *tmpFilePath = NSTemporaryDirectory();
    return tmpFilePath;
}

@end
