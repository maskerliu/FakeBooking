//
//  RadioButtonGroup.h
//  FakeReservation
//
//  Created by yixin.jiang on 5/13/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadioButton;

@protocol OnRadioButtonSelected <NSObject>

- (void)onRadioButtonSelected:(RadioButton *)radioButton;

@end


@interface RadioButton : UIView

- (id)initWithTitle:(NSString *)title value:(NSObject *)value;

- (void)setSelected:(BOOL)selected;


@property (nonatomic, strong) NSObject *value;
@property (nonatomic, weak) id<OnRadioButtonSelected> delegate;

@end

@interface RadioButtonGroup : UIView <OnRadioButtonSelected>

- (id)initWithFrame:(CGRect)frame data:(NSArray *)data;

- (void)selectRadioButtonWith:(NSObject *)value;

- (NSObject *)selectedData;

@end
