//
//  LKFileManageViewController.m
//  likit
//
//  Created by 李浪 on 2021/3/3.
//

#import "LKFileManageViewController.h"

#import "LKFileUtil.h"

@interface LKFileManageViewController ()<UITableViewDelegate, UITableViewDataSource>

// 列表
@property(nonatomic, strong) UITableView *tableView;
// 数据源
@property(nonatomic, strong) NSMutableArray *dataSource;

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
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

/**
 * 根据文件夹路径更新数据源
 *
 * @param directoryPath 文件夹路径
 */
- (void)updateDataSourceWithDirectoryPath:(NSString *)directoryPath {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
