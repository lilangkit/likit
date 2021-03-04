//
//  LKFileManageHelper.m
//  likit
//
//  Created by 李浪 on 2021/3/4.
//

#import "LKFileManageHelper.h"

#import "LKFileUtil.h"

#import "LKFileModel.h"

@implementation LKFileManageHelper

/**
 * 获取文件类型
 *
 * @param filePath 文件路径
 * @return 图标
 */
+ (LKFileType)getFileTypeWithFilePath:(NSString *)filePath {
    // 未传参
    if (filePath == nil || filePath.length == 0) {
        return LKFileTypeNull;
    }
    // 是文件夹
    if ([LKFileUtil isDirectoryAtPath:filePath]) {
        return LKFileTypeDirectory;
    }
    
    NSString *extention = [[filePath pathExtension] lowercaseString];
    
    NSArray *textTypeArray = @[@"txt", @"rtf", @"rtfd", @"html", @"css", @"js", @"xml", @"xmls", @"c", @"h", @"cpp", @"hpp", @"m", @"java", @"py", @"json"];
    NSArray *wordTypeArray = @[@"doc", @"docx"];
    NSArray *excelTypeArray = @[@"xls", @"xlsx"];
    NSArray *pptTypeArray = @[@"ppt", @"pptx"];
    NSArray *pdfTypeArray = @[@"pdf"];
    NSArray *imageTypeArray = @[@"jpg", @"jpeg", @"png", @"tiff", @"psd", @"swf", @"svg"];
    NSArray *audioTypeArray = @[@"wav", @"mod", @"st3", @"xt", @"s3m", @"far", @"669", @"mp3", @"ra", @"rm", @"rmx", @"cmf", @"cda", @"mid", @"vqf", @"wma", @"aac", @"m4a", @"mp1", @"mp2", @"mp3", @"aiff"];
    NSArray *videoTypeArray = @[@"avi", @"wma", @"rmvb", @"rm", @"flash", @"mp4", @"mid", @"3gp"];
    NSArray *compressTypeArray = @[@"zip", @"rar", @"7z", @"gz", @"bz", @"ace", @"uha", @"uda", @"zpaq"];
    NSArray *bundleTypeArray = @[@"bundle", @"framework"];
    
    if ([textTypeArray containsObject:extention]) {
        return LKFileTypeText;
    } else if ([wordTypeArray containsObject:extention]) {
        return LKFileTypeWord;
    } else if ([excelTypeArray containsObject:extention]) {
        return LKFileTypeExcel;
    } else if ([pptTypeArray containsObject:extention]) {
        return LKFileTypePowerPoint;
    } else if ([pdfTypeArray containsObject:extention]) {
        return LKFileTypePDF;
    } else if ([imageTypeArray containsObject:extention]) {
        return LKFileTypeImage;
    } else if ([audioTypeArray containsObject:extention]) {
        return LKFileTypeAudio;
    } else if ([videoTypeArray containsObject:extention]) {
        return LKFileTypeVideo;
    } else if ([compressTypeArray containsObject:extention]) {
        return LKFileTypeCompress;
    } else if ([bundleTypeArray containsObject:extention]) {
        return LKFileTypeBundle;
    } else {
        return LKFileTypeUnknown;
    }
}

/**
 * 获取文件图标
 *
 * @param filePath 文件路径
 * @return 图标
 */
+ (NSString *)getFileIconWithFilPath:(NSString *)filePath {
    // 未传参
    if (filePath == nil || filePath.length == 0) {
        return @"undefine.png";
    }
    LKFileType fileType = [self getFileTypeWithFilePath:filePath];
    NSString *fileIcon;
    switch (fileType) {
        case LKFileTypeUnknown: fileIcon = @"undefine.png"; break;
        case LKFileTypeDirectory: fileIcon = @"directory.png"; break;
        case LKFileTypeText: fileIcon = @"text.png"; break;
        case LKFileTypeWord: fileIcon = @"word.png"; break;
        case LKFileTypeExcel: fileIcon = @"excel.png"; break;
        case LKFileTypePowerPoint: fileIcon = @"ppt.png"; break;
        case LKFileTypePDF: fileIcon = @"pdf.png"; break;
        case LKFileTypeImage: fileIcon = @"image.png"; break;
        case LKFileTypeAudio: fileIcon = @"audio.png"; break;
        case LKFileTypeVideo: fileIcon = @"vedio.png"; break;
        case LKFileTypeCompress: fileIcon = @"compress.png"; break;
        case LKFileTypeBundle: fileIcon = @"bundle.png"; break;
        default: fileIcon = @"undefine.png"; break;
    }
    return fileIcon;
}

/**
 * 获取文件 或 文件夹信息
 *
 * @param filePath 文件路径
 * @return 文件信息
 */
+ (NSString *)getFileInfoWithFilePath:(NSString *)filePath {
    // 是文件夹
    if ([LKFileUtil isDirectoryAtPath:filePath]) {
        NSArray *filePaths = [LKFileUtil getDirectSubPathsInDirectoryPath:filePath];
        NSInteger fileNumber = 0, directoryNumber = 0;
        for (NSString *filePathItem in filePaths) {
            NSString *path = [filePath stringByAppendingPathComponent:filePathItem];
            NSString *lastPathComponent = [filePath lastPathComponent];
            // 过滤系统文件
            if ([lastPathComponent isEqual:@".DS_Store"]) {
                continue;
            }
            if ([LKFileUtil isDirectoryAtPath:path]) {
                directoryNumber++;
            } else {
                fileNumber++;
            }
        }
        NSString *fileInfo = [NSString stringWithFormat:@"文件夹：%ld    文件：%ld", directoryNumber, fileNumber];
        return fileInfo;
    } else {
        NSDictionary *info = [LKFileUtil getFileInfoFromFilePath:filePath];
        if (info == nil) {
            return nil;
        }
        NSString *createTime = info[@"NSFileCreationDate"];
        NSString *size = [LKFileUtil getFileSizeWithFilPath:filePath];
        NSString *fileInfo = [NSString stringWithFormat:@"%@    %@", createTime, size];
        return fileInfo;
    }
}

/**
 * 获取文件夹下子文件信息
 *
 * @param directoryPath 文件夹路径
 * @return 子文件信息
 */
+ (NSArray<LKFileModel *> *)getFileModelsFromDirectoryPath:(NSString *)directoryPath {
    NSMutableArray *fileModels = [NSMutableArray array];
    NSString *directoryChangePath = directoryPath;
    // 未传参
    if (directoryChangePath == nil || directoryChangePath.length == 0) {
        return fileModels;
    }
    // 目录不存在
    if (![LKFileUtil isExistAtFilePath:directoryChangePath]) {
        return fileModels;
    }
    // 目录不是文件夹
    if (![LKFileUtil isDirectoryAtPath:directoryPath]) {
        return fileModels;
    }
    NSArray *filePaths = [LKFileUtil getDirectSubPathsInDirectoryPath:directoryPath];
    if (filePaths == nil) {
        return fileModels;
    }
    for (NSString *filePath in filePaths) {
        NSString *lastPathComponent = [filePath lastPathComponent];
        // 过滤系统文件
        if ([lastPathComponent isEqual:@".DS_Store"]) {
            continue;
        }
        
        NSString *path = [directoryPath stringByAppendingPathComponent:filePath];
        LKFileModel *fileModel = [[LKFileModel alloc] init];
        // 文件名
        fileModel.fileName = [filePath lastPathComponent];
        // 文件大小
        fileModel.fileSize = [LKFileUtil getFileSizeWithFilPath:path];
        // 文件简介
        fileModel.fileAbout = [self getFileInfoWithFilePath:path];
        // 文件图片
        fileModel.fileIcon = [self getFileIconWithFilPath:path];
        // 文件路径
        fileModel.filePath = path;
        // 文件类型
        fileModel.fileType = [self getFileTypeWithFilePath:path];
        // 是否可以编辑
        if ([path containsString:[LKFileUtil getPreferenceFilePath]]) {
            fileModel.canEdit = NO;
        } else {
            fileModel.canEdit = YES;
        }
        // 文件地址类型
        if ([path hasPrefix:[LKFileUtil getHomeFilePath]]) {
            fileModel.fileType = LKFilePathTypeSandBox;
        } else if ([path hasPrefix:[LKFileUtil getMainBundlePath]]) {
            fileModel.fileType = LKFilePathTypeBundle;
        } else {
            fileModel.fileType = LKFilePathTypeOther;
        }
        
        [fileModels addObject:fileModel];
    }
    return fileModels;
}

@end
