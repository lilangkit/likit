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

#pragma mark - 资源文件
/**
 * 获取主资源文件路径
 *
 * @return 主资源文件路径
 */
+ (NSString *)getMainBundlePath {
    NSString *mainBundlePath = [[NSBundle mainBundle] resourcePath];
    return mainBundlePath;
}

/**
 * 获取主资源文件URL
 *
 * @return 主资源文件URL
 */
+ (NSString *)getMainBundleUrl {
    NSString *mainBundleUrl = [[[NSBundle mainBundle] resourceURL] absoluteString];
    return mainBundleUrl;
}

/**
 * 获取资源文件路径
 *
 * @param bundleName 资源文件名
 * @return 资文件路径
 */
+ (NSString *)getBundlePathWithBundleName:(NSString *)bundleName {
    NSString *path = [[NSBundle mainBundle] pathForResource:bundleName ofType:@".bundle"];
    return path;
}

/**
 * 获取资源文件URL
 *
 * @param bundleName 资源文件名
 * @return 资源文件URL
 */
+ (NSString *)getBundleUrlWithBundleName:(NSString *)bundleName {
    NSString *url = [[[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"] absoluteString];
    return url;
}

#pragma mark - 文件工具
/**
 * 文件拷贝
 *
 * @param sourcePath 文件路径
 * @param filePath 复制文件路径
 * @return 结果
 */
+ (BOOL)copyFilePath:(NSString *)sourcePath toPath:(NSString *)filePath {
    // 源文件不存在
    if (![self isExistAtFilePath:sourcePath]) {
        return NO;
    }
    NSString *directoryPath = [filePath stringByDeletingLastPathComponent];
    // 目标文件夹不存在
    if (![self isExistAtFilePath:directoryPath]) {
        [self createDirectoryPath:directoryPath];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL flag = [fileManager copyItemAtPath:sourcePath toPath:filePath error:nil];
    return flag;
}

/**
 * 文件剪切
 *
 * @param sourcePath 文件路径
 * @param filePath 复制文件路径
 * @return 结果
 */
+ (BOOL)moveFilePath:(NSString *)sourcePath toPath:(NSString *)filePath {
    // 源文件不存在
    if (![self isExistAtFilePath:sourcePath]) {
        return NO;
    }
    NSString *directoryPath = [filePath stringByDeletingLastPathComponent];
    // 目标文件夹不存在
    if (![self isExistAtFilePath:directoryPath]) {
        [self createDirectoryPath:directoryPath];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL flag = [fileManager moveItemAtPath:sourcePath toPath:filePath error:nil];
    return flag;
}

/**
 * 删除文件
 *
 * @param filePath 路径
 * @return 结果
 */
+ (BOOL)removeFilePath:(NSString *)filePath {
    // 未传参
    if( filePath == nil || filePath.length == 0) {
        return YES;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    BOOL deleteFlag = NO;
    // 文件存在
    if (isExist) {
        deleteFlag = [fileManager removeItemAtPath:filePath error:nil];
    } else {
        // 文件不存在
        deleteFlag = YES;
    }
    return deleteFlag;
}

/**
 * 文件是否存在
 *
 * @param filePath 路径
 * @return 结果
 */
+ (BOOL)isExistAtFilePath:(NSString *)filePath {
    // 未传参
    if (filePath == nil || filePath.length == 0) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    return isExist;
}

/**
 * 创建文件
 *
 * @param filePath 路径
 * @param data 文件
 * @return 结果
 */
+ (BOOL)createFileAtPath:(NSString *)filePath contents:(NSData *)data {
    // 未传参
    if (filePath == nil || filePath.length == 0) {
        return NO;
    }
    NSString *directoryPath = [filePath stringByDeletingLastPathComponent];
    // 目标文件夹不存在
    if (![self isExistAtFilePath:directoryPath]) {
        [self createDirectoryPath:directoryPath];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL flag = [fileManager createFileAtPath:filePath contents:data attributes:nil];
    return flag;
}

/**
 * 获取文件创建时间
 *
 * @param filePath 文件路径
 * @return 文件信息
 */
+ (NSDate *)getFileCreateTimeWithFilePath:(NSString *)filePath {
    NSDictionary *info = [self getFileInfoFromFilePath:filePath];
    if (info == nil) {
        return nil;
    }
    NSDate *createTime = info[@"NSFileCreationDate"];
    return createTime;
}

/**
 * 获取文件信息
 *
 * @param filePath 文件路径
 * @return 文件信息
 */
+ (NSDictionary *)getFileInfoFromFilePath:(NSString *)filePath {
    // 未传参
    if (filePath == nil || filePath.length == 0) {
        return nil;
    }
    // 文件不存在
    if (![self isExistAtFilePath:filePath]) {
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileInfo = [fileManager attributesOfItemAtPath:filePath error:nil];
    return fileInfo;
}

/**
 * 获取文件大小
 *
 * @param filePath 文件路径
 * @return 文件大小
 */
+ (NSInteger)getFileLengthWithFilPath:(NSString *)filePath {
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSInteger fileLength = data.length;
    return fileLength;
}

/**
 * 获取文件大小
 *
 * @param filePath 文件路径
 * @return 文件大小
 */
+ (NSString *)getFileSizeWithFilPath:(NSString *)filePath {
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSInteger fileLength = data.length;
    NSString *fileSize;
    CGFloat size;
    if (fileLength < 1024) {
        size = fileLength;
        fileSize = [NSString stringWithFormat:@"%.1fB", size];
    } else if ((fileLength / 1024) < 1024) {
        size = ((CGFloat)fileLength) / 1024.0;
        fileSize = [NSString stringWithFormat:@"%.1fKB", size];
    } else if (((fileLength / 1024) / 1024) < 1024) {
        size = (((CGFloat)fileLength) / 1024.0) / 1024.0;
        fileSize = [NSString stringWithFormat:@"%.1fMB", size];
    } else if ((((fileLength / 1024) / 1024) / 1024) < 1024) {
        size = ((((CGFloat )fileLength) / 1024.0) / 1024.0) / 1024.0;
        fileSize = [NSString stringWithFormat:@"%.1fGB", size];
    } else {
        fileSize = [NSString stringWithFormat:@"%.1ld", (unsigned long)fileLength];
    }
    return fileSize;
}

#pragma mark - 文件夹工具
/**
 * 路径是不是文件夹
 *
 * @param path 路径
 * @return 结果
 */
+ (BOOL)isDirectoryAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory, isExist;
    isExist = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
    if (isExist == YES && isDirectory == YES) {
        return YES;
    } else {
        return NO;
    }
}

/**
 * 创建文件夹
 *
 * @param directoryPath 路径
 * @return 结果
 */
+ (BOOL)createDirectoryPath:(NSString *)directoryPath {
    // 文件夹已存在
    if ([self isExistAtFilePath:directoryPath]) {
        return YES;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL flag = [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:nil];
    return flag;
}

/**
 * 获取文件夹直接子路径
 *
 * @param directoryPath 文件夹路径
 * @return 结果
 */
+ (NSArray *)getDirectSubPathsInDirectoryPath:(NSString *)directoryPath {
    // 文件夹不存在
    if (![self isExistAtFilePath:directoryPath]) {
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = [fileManager contentsOfDirectoryAtPath:directoryPath error:nil];
    return paths;
}

/**
 * 获取文件夹所有子路径
 *
 * @param directoryPath 文件夹路径
 * @return 结果
 */
+ (NSArray *)getAllSubPathsInDirectoryPath:(NSString *)directoryPath {
    // 文件夹不存在
    if (![self isExistAtFilePath:directoryPath]) {
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = [fileManager subpathsAtPath:directoryPath];
    return paths;
}

/**
 * 文件清空
 *
 * @param filePath 路径
 * @return 结果
 */
+ (BOOL)clearStrorageAtFilePath:(NSString *)filePath {
    // 未传参
    if (filePath == nil || filePath.length == 0) {
        return NO;
    }
    // 文件夹存在
    if (![self isExistAtFilePath:filePath]) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtPath:filePath];
    for (NSString *fileName in directoryEnumerator) {
        [fileManager removeItemAtPath:[filePath stringByAppendingPathComponent:fileName] error:nil];
    }
    return YES;
}

@end
