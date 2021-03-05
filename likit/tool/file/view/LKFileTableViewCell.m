//
//  LKFileTableViewCell.m
//  likit
//
//  Created by 李浪 on 2021/3/4.
//

#import "LKFileTableViewCell.h"

#import "LKFileModel.h"

@interface LKFileTableViewCell ()

// 文件图片
@property (nonatomic, strong) UIImageView *fileIconImageView;
// 文件名
@property (nonatomic, strong) UILabel *fileNameLabel;
// 文件简介
@property (nonatomic, strong) UILabel *fileAboutLabel;

@end

@implementation LKFileTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 加载自定义视图
        [self addCustomSubViews];
        // 布局自定义视图
        [self layoutCustomSubviews];
    }
    return self;
}

/**
 * 加载自定义视图
 */
- (void)addCustomSubViews {
    // 文件图片
    [self.contentView addSubview:self.fileIconImageView];
    // 文件名
    [self.contentView addSubview:self.fileNameLabel];
    // 文件简介
    [self.contentView addSubview:self.fileAboutLabel];
}

/**
 * 布局自定义视图
 */
- (void)layoutCustomSubviews {
    @weakify(self);
    // 文件图片
    [self.fileIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superView = weak_self.contentView;
        make.left.mas_equalTo(superView).mas_offset(15.0f);
        make.top.mas_equalTo(superView).mas_offset(10.0f);
        make.bottom.mas_equalTo(superView).mas_offset(-10.0f);
        make.width.mas_equalTo(weak_self.fileIconImageView.mas_height);
    }];
    // 文件名
    [self.fileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superView = weak_self.contentView;
        make.left.mas_equalTo(weak_self.fileIconImageView.mas_right).mas_offset(10.0f);
        make.top.mas_equalTo(weak_self.fileIconImageView);
        make.right.mas_equalTo(superView).mas_offset(-40.0f);
    }];
    // 文件简介
    [self.fileAboutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weak_self.fileNameLabel);
        make.top.mas_equalTo(weak_self.fileNameLabel.mas_bottom).mas_offset(5.0f);
        make.right.mas_equalTo(weak_self.fileNameLabel);
        make.bottom.mas_equalTo(weak_self.fileIconImageView);
        make.height.mas_equalTo(weak_self.fileNameLabel);
    }];
}

/**
 * 文件图片
 */
- (UIImageView *)fileIconImageView {
    if (_fileIconImageView == nil) {
        _fileIconImageView = [[UIImageView alloc] init];
        _fileIconImageView.backgroundColor = [UIColor clearColor];
        _fileIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _fileIconImageView;
}

/**
 * 文件名
 */
- (UILabel *)fileNameLabel {
    if (_fileNameLabel == nil) {
        _fileNameLabel = [[UILabel alloc] init];
        _fileNameLabel.textAlignment = NSTextAlignmentLeft;
        _fileNameLabel.font = [UIFont systemFontOfSize:15.0f];
        _fileNameLabel.textColor = [UIColor blackColor];
    }
    return _fileNameLabel;
}

/**
 * 文件简介
 */
- (UILabel *)fileAboutLabel {
    if (_fileAboutLabel == nil) {
        _fileAboutLabel = [[UILabel alloc] init];
        _fileAboutLabel.textAlignment = NSTextAlignmentLeft;
        _fileAboutLabel.font = [UIFont systemFontOfSize:13.0f];
        _fileAboutLabel.textColor = [UIColor blackColor];
    }
    return _fileAboutLabel;
}

- (void)setFileModel:(LKFileModel *)fileModel {
    _fileModel = fileModel;
    // 文件图片
    if (fileModel.fileIcon) {
        self.fileIconImageView.image = [UIImage imageNamed:[@"LKFileManageFileIcon.bundle" stringByAppendingPathComponent:fileModel.fileIcon]];
    } else {
        self.fileIconImageView.image = [UIImage imageNamed:@"LKFileManageFileIcon.bundle/undefine.png"];
    }
    // 文件名
    self.fileNameLabel.text = fileModel.fileName;
    // 文件简介
    self.fileAboutLabel.text = fileModel.fileAbout;
    // 下一级图标
    // 是文件夹
    if (fileModel.fileType == LKFileTypeDirectory) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
