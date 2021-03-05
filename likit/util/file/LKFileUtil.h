//
//  LKFileUtil.h
//  likit
//
//  Created by 李浪 on 2021/3/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKFileUtil : NSObject

#pragma mark - 获取沙盒文件路径
/**
 * 获取沙盒根路径
 *
 * @return 根路径
 */
+ (NSString *)getHomeFilePath;

/**
 * 获取沙盒Document路径
 *
 * @return Document路径
 */
+ (NSString *)getDocumentFilePath;

/**
 * 获取沙盒library路径
 *
 * @return library路径
 */
+ (NSString *)getLibraryFilePath;

/**
 * 获取沙盒cache路径
 *
 * @return cache路径
 */
+ (NSString *)getCacheFilePath;

/**
 * 获取沙盒Preference路径
 *
 * @return Preference路径
 */
+ (NSString *)getPreferenceFilePath;

/**
 * 获取沙盒tmp路径
 *
 * @return tmp路径
 */
+ (NSString *)getTmpFilePath;

#pragma mark - 资源文件
/**
 * 获取主资源文件路径
 *
 * @return 主资源文件路径
 */
+ (NSString *)getMainBundlePath;

/**
 * 获取主资源文件URL
 *
 * @return 主资源文件URL
 */
+ (NSString *)getMainBundleUrl;

/**
 * 获取资源文件路径
 *
 * @param bundleName 资源文件名
 * @return 资文件路径
 */
+ (NSString *)getBundlePathWithBundleName:(NSString *)bundleName;

/**
 * 获取资源文件URL
 *
 * @param bundleName 资源文件名
 * @return 资源文件URL
 */
+ (NSString *)getBundleUrlWithBundleName:(NSString *)bundleName;

#pragma mark - 文件工具
/**
 * 文件拷贝
 *
 * @param sourcePath 文件路径
 * @param filePath 复制文件路径
 * @return 结果
 */
+ (BOOL)copyFilePath:(NSString *)sourcePath toPath:(NSString *)filePath;

/**
 * 文件剪切
 *
 * @param sourcePath 文件路径
 * @param filePath 复制文件路径
 * @return 结果
 */
+ (BOOL)moveFilePath:(NSString *)sourcePath toPath:(NSString *)filePath;

/**
 * 删除文件
 *
 * @param filePath 路径
 * @return 结果
 */
+ (BOOL)removeFilePath:(NSString *)filePath;

/**
 * 文件是否存在
 *
 * @param filePath 路径
 * @return 结果
 */
+ (BOOL)isExistAtFilePath:(NSString *)filePath;

/**
 * 创建文件
 *
 * @param filePath 路径
 * @param data 文件
 * @return 结果
 */
+ (BOOL)createFileAtPath:(NSString *)filePath contents:(NSData *)data;

/**
 * 获取文件创建时间
 *
 * @param filePath 文件路径
 * @return 文件信息
 */
+ (NSDate *)getFileCreateTimeWithFilePath:(NSString *)filePath;

/**
 * 获取文件信息
 *
 * @param filePath 文件路径
 * @return 文件信息
 */
+ (NSDictionary *)getFileInfoFromFilePath:(NSString *)filePath;

/**
 * 获取文件大小
 *
 * @param filePath 文件路径
 * @return 文件大小
 */
+ (NSInteger)getFileLengthWithFilPath:(NSString *)filePath;

/**
 * 获取文件大小
 *
 * @param filePath 文件路径
 * @return 文件大小
 */
+ (NSString *)getFileSizeWithFilPath:(NSString *)filePath;

#pragma mark - 文件夹工具
/**
 * 路径是不是文件夹
 *
 * @param path 路径
 * @return 结果
 */
+ (BOOL)isDirectoryAtPath:(NSString *)path;

/**
 * 创建文件夹
 *
 * @param directoryPath 路径
 * @return 结果
 */
+ (BOOL)createDirectoryPath:(NSString *)directoryPath;

/**
 * 获取文件夹直接子路径
 *
 * @param directoryPath 文件夹路径
 * @return 结果
 */
+ (NSArray *)getDirectSubPathsInDirectoryPath:(NSString *)directoryPath;

/**
 * 获取文件夹所有子路径
 *
 * @param directoryPath 文件夹路径
 * @return 结果
 */
+ (NSArray *)getAllSubPathsInDirectoryPath:(NSString *)directoryPath;

/**
 * 文件清空
 *
 * @param filePath 路径
 * @return 结果
 */
+ (BOOL)clearStrorageAtFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
