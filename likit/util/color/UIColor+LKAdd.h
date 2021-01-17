//
//  UIColor+Add.h
//  likit
//
//  Created by 李浪 on 2021/1/15.
//

@interface UIColor (LKAdd)

#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 \
alpha:1.0]

#define RGB(r,g,b)                  [UIColor colorWithRed:(r)/255.f \
green:(g)/255.f \
blue:(b)/255.f \
alpha:1.f]

#define RGBA(r,g,b,a)               [UIColor colorWithRed:(r)/255.f \
green:(g)/255.f \
blue:(b)/255.f \
alpha:(a)]

#define RGB_OF(rgbValue)            [UIColor colorWithRed:((float)(((rgbValue) & 0xFF000000) >> 24))/255.0 \
green:((float)(((rgbValue) & 0x00FF0000) >> 16))/255.0 \
blue:((float)(rgbValue & 0x0000FF00) >> 8)/255.0 \
alpha:((float)(rgbValue & 0x000000FF))/255.0]

#define RGBA_OF(v, a)                [UIColor colorWithRed:((float)(((v) & 0xFF0000) >> 16))/255.0 \
green:((float)(((v) & 0x00FF00) >> 8))/255.0 \
blue:((float)(v & 0x0000FF))/255.0 \
alpha:a]

//通用颜色
#define K_BLACK_COLOR                [UIColor blackColor]
#define K_DARKGRAY_COLOR             [UIColor darkGrayColor]
#define K_LIGHTGRAY_COLOR            [UIColor lightGrayColor]
#define K_WHITE_COLOR                [UIColor whiteColor]
#define K_GRAY_COLOR                 [UIColor grayColor]
#define K_RED_COLOR                  [UIColor redColor]
#define K_GREENC_OLOR                [UIColor greenColor]
#define K_BLUE_COLOR                 [UIColor blueColor]
#define K_CYAN_COLOR                 [UIColor cyanColor]
#define K_YELLOW_COLOR               [UIColor yellowColor]
#define K_MAGENTA_COLOR              [UIColor magentaColor]
#define K_ORANGE_COLOR               [UIColor orangeColor]
#define K_PURPLE_COLOR               [UIColor purpleColor]
#define K_CLEAR_COLOR                [UIColor clearColor]

+ (UIColor *)flatRedColor;
+ (UIColor *)flatDarkRedColor;

+ (UIColor *)flatGreenColor;
+ (UIColor *)flatDarkGreenColor;

+ (UIColor *)flatBlueColor;
+ (UIColor *)flatDarkBlueColor;

+ (UIColor *)flatTealColor;
+ (UIColor *)flatDarkTealColor;

+ (UIColor *)flatPurpleColor;
+ (UIColor *)flatDarkPurpleColor;

+ (UIColor *)flatBlackColor;
+ (UIColor *)flatDarkBlackColor;

+ (UIColor *)flatYellowColor;
+ (UIColor *)flatDarkYellowColor;

+ (UIColor *)flatOrangeColor;
+ (UIColor *)flatDarkOrangeColor;

+ (UIColor *)flatWhiteColor;
+ (UIColor *)flatDarkWhiteColor;

+ (UIColor *)flatGrayColor;
+ (UIColor *)flatDarkGrayColor;

+ (UIColor *)randomFlatColor;
+ (UIColor *)randomFlatLightColor;
+ (UIColor *)randomFlatDarkColor;

@end
