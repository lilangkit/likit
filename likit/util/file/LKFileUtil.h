//
//  LKFileUtil.h
//  likit
//
//  Created by 李浪 on 2021/3/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKFileUtil : NSObject

#pragma mark 获取沙盒文件路径
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

@end

NS_ASSUME_NONNULL_END
