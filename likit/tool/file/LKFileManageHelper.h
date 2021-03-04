//
//  LKFileManageHelper.h
//  likit
//
//  Created by 李浪 on 2021/3/4.
//

#import <Foundation/Foundation.h>

@class LKFileModel;

NS_ASSUME_NONNULL_BEGIN

@interface LKFileManageHelper : NSObject

/**
 * 获取文件夹下子文件信息
 *
 * @param directoryPath 文件夹路径
 * @return 子文件信息
 */
+ (NSArray<LKFileModel *> *)getFileModelsFromDirectoryPath:(NSString *)directoryPath;

@end

NS_ASSUME_NONNULL_END
