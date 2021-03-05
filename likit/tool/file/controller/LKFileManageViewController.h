//
//  LKFileManageViewController.h
//  likit
//
//  Created by 李浪 on 2021/3/3.
//

#import "LKBaseViewController.h"

/**
 * 视图类型
 */
typedef enum LKFileManageViewType {
    LKFileManageViewTypeTable,// 列表
    LKFileManageViewTypeCollection// 平铺
} LKFileManageViewType;

NS_ASSUME_NONNULL_BEGIN

@interface LKFileManageViewController : LKBaseViewController

// 根目录
@property(nonatomic, copy, nullable) NSString *basePath;
// 视图类型
@property(nonatomic, assign) LKFileManageViewType fileManageViewType;

@end

NS_ASSUME_NONNULL_END
