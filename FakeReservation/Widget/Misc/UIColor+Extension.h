//
//  UIColor+Extension.h
//  FakeReservation
//
//  Created by yixin.jiang on 5/10/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIColor(Extension)

// 绿色
+ (UIColor *)emerald;
+ (UIColor *)nephritis;

// 暗绿
+ (UIColor *)turquoise;
+ (UIColor *)greenSea;

// 蓝色
+ (UIColor *)peterRiver;
+ (UIColor *)belizeHole;

// 紫色
+ (UIColor *)amethyst;
+ (UIColor *)wisteria;

// 红色
+ (UIColor *)alizarin;
+ (UIColor *)pomegranate;

// 橙色
+ (UIColor *)carrot;
+ (UIColor *)pumpkin;

// 黄色
+ (UIColor *)sunFlower;
+ (UIColor *)orange;

+ (UIColor *)colorWithHex:(NSString *)str;

@end
