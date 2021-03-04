//
//  LKFileManageViewController.m
//  likit
//
//  Created by 李浪 on 2021/3/3.
//

#import "LKFileManageViewController.h"
#import "LKFileTableViewCell.h"

#import "LKFileManageHelper.h"
#import "LKFileUtil.h"

#import "LKFileModel.h"

@interface LKFileManageViewController ()<UITableViewDelegate, UITableViewDataSource>

// 列表
@property(nonatomic, strong) UITableView *tableView;
// 数据源
@property(nonatomic, strong) NSMutableArray *dataSource;
// 当前目录
@property(nonatomic, copy) NSString *currentDirectoryPath;

@end

@implementation LKFileManageViewController

/**
 * 初始化
 */
- (void)initialize {
    [super initialize];
    // 标题
    self.title = @"文件管理";
}

/**
 * 加载自定义视图
 */
- (void)addCustomSubViews {
    [super addCustomSubViews];
    // 文件视图
    [self.view addSubview:self.tableView];
}

/**
 * 布局自定义视图
 */
- (void)layoutCustomSubviews {
    [super layoutCustomSubviews];
    @weakify(self);
    // 文件视图
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superView = weak_self.view;
        make.edges.mas_equalTo(superView);
    }];
}

/**
 * 加载数据
 */
- (void)loadData {
    // 根数据
    [self updateDataSourceWithDirectoryPath:self.basePath];
}

#pragma mark - 覆写
/**
 * 根目录
 */
- (NSString *)basePath {
    if(_basePath == nil) {
        _basePath = [LKFileUtil getHomeFilePath];
    }
    return _basePath;
}

#pragma mark - 私有方法
/**
 * 文件视图
 */
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[LKFileTableViewCell class] forCellReuseIdentifier:LKFileTableViewCell.className];
    }
    return _tableView;
}

/**
 * 根据文件夹路径更新数据源
 *
 * @param directoryPath 文件夹路径
 */
- (void)updateDataSourceWithDirectoryPath:(NSString *)directoryPath {
    NSString *directoryChangePath = directoryPath;
    // 默认根路径
    if (directoryChangePath == nil || directoryChangePath.length == 0) {
        directoryChangePath = [LKFileUtil getHomeFilePath];
    } else {
        // 不包含沙盒路径 且 不包含资源路径 默认拼接 沙盒路径
        if (![directoryChangePath hasPrefix:[LKFileUtil getHomeFilePath]] && ![directoryChangePath hasPrefix:[LKFileUtil getMainBundlePath]]) {
            directoryChangePath = [[LKFileUtil getHomeFilePath] stringByAppendingPathComponent:directoryPath];
        }
    }
    // 读取目录下的文件清单
    self.dataSource = [NSMutableArray arrayWithArray:[LKFileManageHelper getFileModelsFromDirectoryPath:directoryChangePath]];
    // 记下当前目录
    self.currentDirectoryPath = directoryChangePath;
    
    // 当前路径 等于 跟目录
    // 关闭上翻
    // 开启上翻
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKFileTableViewCell *fileTableViewCell = [tableView dequeueReusableCellWithIdentifier:LKFileTableViewCell.className];
    return fileTableViewCell;
}

@end
