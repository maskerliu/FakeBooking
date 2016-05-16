//
//  RadioButtonGroup.m
//  FakeReservation
//
//  Created by yixin.jiang on 5/13/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import "RadioButtonGroup.h"

static const NSUInteger kRadioButtonWidth = 35;
static const NSUInteger kRadioButtonHeight = 35;

@interface RadioButton() {
    UIButton *_btn;
    UILabel *_lTitle;
}

@end

@implementation RadioButton


- (id)initWithTitle:(NSString *)title value:(NSObject *)value {
    self = [super init];
    if (self) {
        self.value = value;
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(0, 0, kRadioButtonWidth, kRadioButtonHeight);
        _btn.adjustsImageWhenHighlighted = NO;
        [_btn setImage:[UIImage imageNamed:@"radio_def"] forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateSelected];
        [_btn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        
        _lTitle = [[UILabel alloc] initWithFrame:CGRectMake(_btn.frame.origin.x + _btn.frame.size.width, 0, 30, kRadioButtonHeight)];
        [_lTitle setFont:[UIFont systemFontOfSize:15.f]];
        [_lTitle setTextColor:[UIColor asphalt]];
        [_lTitle setText:title];
        [self addSubview:_lTitle];
        
        CGRect frame = CGRectMake(0, 0, _lTitle.frame.origin.x + _lTitle.frame.size.width, kRadioButtonHeight);
        self.frame = frame;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGesture];
        
        [self setNeedsLayout];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)tap:(id)sender {
    [self setSelected:YES];
    [self.delegate onRadioButtonSelected:self];
}

- (void)setSelected:(BOOL)selected{
    [_btn setSelected:selected];
    [_lTitle setTextColor:selected ? [UIColor pumpkin] : [UIColor asphalt]];
}

@end



@interface RadioButtonGroup() {
    NSMutableArray *_radioBtns;
    NSObject *_selectedData;
}

@end

@implementation RadioButtonGroup

- (id)initWithFrame:(CGRect)frame data:(NSArray *)data {
    if (self = [super initWithFrame:frame]) {
        _radioBtns = [[NSMutableArray alloc] init];
        int x = 0;
        for (NSDictionary *dict in data) {
            NSString *title = (NSString *)[dict objectForKey:@"title"];
            NSObject *value = [dict objectForKey:@"value"];
            RadioButton *radioBtn = [[RadioButton alloc] initWithTitle:title value:value];
            
            CGRect rect = radioBtn.bounds;
            rect.origin.x = x;
            [radioBtn setFrame:rect];
            radioBtn.delegate = self;
            
            x += radioBtn.bounds.size.width + 5;
            
            [_radioBtns addObject:radioBtn];
            [self addSubview:radioBtn];
        }
        
        CGRect rect = frame;
        rect.size.width = x;
        rect.size.height = kRadioButtonHeight;
        self.frame = rect;
    }
    return self;
}

- (void)selectRadioButtonWith:(NSObject *)value {
    for (RadioButton *radioBtn in _radioBtns) {
        if ([radioBtn.value isEqual:value]) {
            [radioBtn setSelected:YES];
        } else {
            [radioBtn setSelected:NO];
        }
    }
}

- (void)setRadioButtonSelected:(RadioButton *)radioButton {
    for (RadioButton *radioBtn in _radioBtns) {
        if (![radioBtn isEqual:radioButton]) {
            [radioBtn setSelected:NO];
        }
    }
    
    _selectedData = radioButton.value;
}

- (void)onRadioButtonSelected:(RadioButton *)radioButton {
    for (RadioButton *radioBtn in _radioBtns) {
        if (![radioBtn isEqual:radioButton]) {
            [radioBtn setSelected:NO];
        }
    }
    
    _selectedData = radioButton.value;
}

- (NSObject *)selectedData {
    return _selectedData;
}

@end
