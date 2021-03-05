//
//  LKFileTableViewCell.h
//  likit
//
//  Created by 李浪 on 2021/3/4.
//

#import "LKFileBaseTableViewCell.h"

@class LKFileModel;

NS_ASSUME_NONNULL_BEGIN

@interface LKFileTableViewCell : LKFileBaseTableViewCell

// 文件信息
@property (nonatomic, strong) LKFileModel *fileModel;

@end

NS_ASSUME_NONNULL_END
