//
//  LKBaseNavigationController.m
//  likit
//
//  Created by 李浪 on 2021/1/16.
//

#import "LKBaseNavigationController.h"

@interface LKBaseNavigationController ()

@property (nonatomic, strong) UIImageView *hairlineImageView;
@property (nonatomic, strong) UIView *hairlineImageViewNew;

@end

@implementation LKBaseNavigationController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 导航栏分隔线
    if (_hairlineImageView == nil) {
        _hairlineImageView = [self findHairlineImageViewUnder:self.navigationBar];
        _hairlineImageViewNew = [UIView new];
        _hairlineImageViewNew.backgroundColor = K_SEPARATOR_COLOR;
        [_hairlineImageView addSubview:_hairlineImageViewNew];
    }
    _hairlineImageViewNew.frame = _hairlineImageView.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.navigationBar.translucent = NO;
}

/**
 * 找出导航栏分隔线
 */
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1.0f) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
