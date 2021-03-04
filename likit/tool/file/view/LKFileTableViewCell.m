//
//  LKFileTableViewCell.m
//  likit
//
//  Created by 李浪 on 2021/3/4.
//

#import "LKFileTableViewCell.h"

@implementation LKFileTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = K_RED_COLOR;
    }
    return self;
}

@end
