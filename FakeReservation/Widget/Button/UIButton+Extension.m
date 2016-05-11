//
//  UIButton+Extension.m
//  FakeReservation
//
//  Created by yixin.jiang on 5/10/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton(Extension)

+ (UIButton *)greenButtonWithFrame:(CGRect) frame {
    return [UIButton buttonWithNormalColor:[UIColor emerald] selectedColor:[UIColor nephritis] frame:frame];
}

+ (UIButton *)blueButtonWithFrame:(CGRect)frame {
    return [UIButton buttonWithNormalColor:[UIColor peterRiver] selectedColor:[UIColor belizeHole] frame:frame];
}

+ (UIButton *)redButtonWithFrame:(CGRect)frame{
    return [UIButton buttonWithNormalColor:[UIColor alizarin] selectedColor:[UIColor pomegranate] frame:frame];
}

+ (UIButton *)orangeButtonWithFrame:(CGRect)frame {
    return [UIButton buttonWithNormalColor:[UIColor carrot] selectedColor:[UIColor pumpkin] frame:frame];
}


+ (UIButton *)buttonWithNormalColor:(UIColor *) normalColor selectedColor:(UIColor *)selectedColor frame:(CGRect)rect {
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    [btn setBackgroundImage:[UIImage imageWithColor:normalColor size:rect.size]
                   forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:selectedColor size:rect.size]
                   forState:UIControlStateSelected];
    return btn;
}


@end
