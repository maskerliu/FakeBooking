//
//  UIColor+Extension.m
//  FakeReservation
//
//  Created by yixin.jiang on 5/10/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor(Extension)

// 绿色
+ (UIColor *)emerald {
    return [UIColor colorWithHex:@"#2ecc71"];
}

+ (UIColor *)nephritis {
    return [UIColor colorWithHex:@"#27ae60"];
}

// 暗绿
+ (UIColor *)turquoise {
    return [UIColor colorWithHex:@"#1abc9c"];
}
+ (UIColor *)greenSea {
    return [UIColor colorWithHex:@"#16a085"];
}

// 蓝色
+ (UIColor *)peterRiver {
    return [UIColor colorWithHex:@"#3498db"];
}
+ (UIColor *)belizeHole {
    return [UIColor colorWithHex:@"#2980b9"];
}

// 紫色
+ (UIColor *)amethyst {
    return [UIColor colorWithHex:@"#9b59b6"];
}
+ (UIColor *)wisteria {
    return [UIColor colorWithHex:@"#8e44ad"];
}

// 黄色
+ (UIColor *)sunFlower {
    return [UIColor colorWithHex:@"#f1c40f"];
}
+ (UIColor *)orange {
    return [UIColor colorWithHex:@"#f39c12"];
}

// 橙色
+ (UIColor *)carrot {
    return [UIColor colorWithHex:@"#e67e22"];
}
+ (UIColor *)pumpkin {
    return [UIColor colorWithHex:@"#d35400"];
}

// 红色
+ (UIColor *)alizarin {
    return [UIColor colorWithHex:@"#e74c3c"];
}
+ (UIColor *)pomegranate {
    return [UIColor colorWithHex:@"#c0392b"];
}

+ (UIColor *)colorWithHex:(NSString *)str {
    
    NSString *cString = [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
