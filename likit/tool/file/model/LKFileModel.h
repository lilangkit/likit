//
//  LKFileModel.h
//  likit
//
//  Created by 李浪 on 2021/3/4.
//

#import <Foundation/Foundation.h>

/**
 * 文件类型
 */
typedef enum LKFileType {
    LKFileTypeUnknown,// 未知
    LKFileTypeDirectory,// 文件夹
    LKFileTypeText,// 文本文件
    LKFileTypeWord,// word文件
    LKFileTypeExcel,//excel文件
    LKFileTypePowerPoint,// ppt文件
    LKFileTypePDF,// PDF文件
    LKFileTypeImage,// 图片文件
    LKFileTypeAudio,// 音频文件
    LKFileTypeVideo,// 视频文件
    LKFileTypeCompress,// 压缩文件
    LKFileTypeBundle,// 资源文件
    LKFileTypeNull// 非文件
} LKFileType;

/**
 * 文件地址类型
 */
typedef enum LKFilePathType {
    LKFilePathTypeSandBox,// 沙盒
    LKFilePathTypeBundle,// app资源文件夹
    LKFilePathTypeOther// 其他文件夹
} LKFilePathType;

NS_ASSUME_NONNULL_BEGIN

@interface LKFileModel : NSObject

// 文件名
@property(nonatomic, copy) NSString *fileName;
// 文件大小
@property(nonatomic, assign) NSUInteger fileLength;
// 文件大小
@property(nonatomic, copy) NSString *fileSize;
// 文件创建时间
@property(nonatomic, strong) NSDate *fileCreateTime;
// 文件简介
@property(nonatomic, copy) NSString *fileAbout;
// 文件图片
@property(nonatomic, copy) NSString *fileIcon;
// 文件路径
@property(nonatomic, copy) NSString *filePath;
// 文件类型
@property(nonatomic, assign) LKFileType fileType;
// 是否可以编辑
@property(nonatomic, assign) BOOL canEdit;
// 文件地址类型
@property(nonatomic, assign) LKFilePathType filePathType;

@end

NS_ASSUME_NONNULL_END
