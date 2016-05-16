//
//  OnlineReservationCells.m
//  FakeReservation
//
//  Created by yixin.jiang on 5/12/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import "OnlineReservationCells.h"
#import "RadioButtonGroup.h"

@implementation OnlineReservationCell

- (id)init {
    if (self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OnlineReservationCell"]) {
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end


@interface SelectPeopleCountCell() {
    UILabel *_lKey;
    UILabel *_lPeopleCount;
}

@end

@implementation SelectPeopleCountCell

@synthesize peopleCount = _peopleCount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellId = OnlineReservationCell_PeopleCount;
        
        _lKey = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 50, 34)];
        [_lKey setTextColor:[UIColor silver]];
        [_lKey setFont:[UIFont systemFontOfSize:15.f]];
        [_lKey setText:@"人数"];
        [self.contentView addSubview:_lKey];
        
        _lPeopleCount = [[UILabel alloc] init];
        [_lPeopleCount setTextColor:[UIColor midnightBlue]];
        [_lPeopleCount setFont:[UIFont systemFontOfSize:15.f]];
        [_lPeopleCount setTextAlignment:NSTextAlignmentRight];
        [_lPeopleCount setText:@"4人"];
        [self.contentView addSubview:_lPeopleCount];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_lPeopleCount setFrame:CGRectMake(self.contentView.bounds.size.width - 50, 5, 50, 34)];
}

- (void)setPeopleCount:(NSString *)peopleCount {
    _peopleCount = peopleCount;
    [_lPeopleCount setText:[NSString stringWithFormat:@"%@人", self.peopleCount]];
}

@end


@interface SelectDateCell() {
    UILabel *_lKey;
    UILabel *_lDate;
}

@end

@implementation SelectDateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellId = OnlineReservationCell_Date;
        _lKey = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 50, 34)];
        [_lKey setTextColor:[UIColor silver]];
        [_lKey setFont:[UIFont systemFontOfSize:15.f]];
        [_lKey setText:@"时间"];
        [self.contentView addSubview:_lKey];
        
        _lDate = [[UILabel alloc] init];
        [_lDate setTextColor:[UIColor midnightBlue]];
        [_lDate setFont:[UIFont systemFontOfSize:15.f]];
        [_lDate setTextAlignment:NSTextAlignmentRight];
        [_lDate setText:@"05月12日 今天 12:00"];
        [self.contentView addSubview:_lDate];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_lDate setFrame:CGRectMake(self.contentView.bounds.size.width - 150, 5, 150, 34)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


@interface NameCell() {//<RadioButtonDelegate> {
    UITextField *_tfName;
    UILabel *_lMale, *_lFemale;
//    RadioButton *_rbMale, *_rbFemale;
    RadioButtonGroup *_rbgGender;
}
@end

@implementation NameCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellId = OnlineReservationCell_Name;
        
        _tfName = [[UITextField alloc] init];
        [_tfName setPlaceholder:@"您贵姓"];
        [_tfName setTextColor:[UIColor asphalt]];
        [_tfName setFont:[UIFont systemFontOfSize:15.f]];
        [self.contentView addSubview:_tfName];
        
        NSMutableArray *rbgConfig = [[NSMutableArray alloc] init];
        [rbgConfig addObject:@{@"title": @"先生", @"value": @"0"}];
        [rbgConfig addObject:@{@"title": @"女士", @"value": @"1"}];
        _rbgGender = [[RadioButtonGroup alloc] initWithFrame:CGRectMake(0, 5, 0, 0)
                                                                   data:rbgConfig];
        [self.contentView addSubview:_rbgGender];
        [_rbgGender selectRadioButtonWith:@"0"];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self setNeedsLayout];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_tfName setFrame:CGRectMake(20, 5, self.contentView.bounds.size.width - _rbgGender.bounds.size.width, 34)];
    CGRect rect = _rbgGender.frame;
    rect.origin.x = self.contentView.bounds.size.width - _rbgGender.bounds.size.width - 15;
    [_rbgGender setFrame:rect];
}

- (BOOL)isFirstResponder {
    if ([_tfName isFirstResponder]) {
        return YES;
    } else {
        return [super isFirstResponder];
    }
}

-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    NSLog(@"changed to %lu in %@",(unsigned long)index,groupId);
}

@end



@interface TelePhoneCell() {
    UITextField *_tfTelePhone;
}
@end


@implementation TelePhoneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellId = OnlineReservationCell_TelePhone;
        
        _tfTelePhone = [[UITextField alloc] init];
        [_tfTelePhone setPlaceholder:@"请输入您的手机号码"];
        [_tfTelePhone setFont:[UIFont systemFontOfSize:15.f]];
        [_tfTelePhone setTextColor:[UIColor asphalt]];
        [_tfTelePhone setKeyboardType:UIKeyboardTypeNamePhonePad];
        [self.contentView addSubview:_tfTelePhone];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_tfTelePhone setFrame:CGRectMake(20, 5, self.contentView.frame.size.width - 30, self.contentView.frame.size.height - 10)];
}

- (BOOL)isFirstResponder {
    if ([_tfTelePhone isFirstResponder]) {
        return YES;
    } else {
        return [super isFirstResponder];
    }
}

@end


@interface ExtraNoteCell() {
    UITextField *_tfExtraNote;
}
@end


@implementation ExtraNoteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellId = OnlineReservationCell_ExtraNote;
        
        _tfExtraNote = [[UITextField alloc] init];
        [_tfExtraNote setPlaceholder:@"如有附加要求，可填写，我们会尽量安排"];
        [_tfExtraNote setFont:[UIFont systemFontOfSize:15.f]];
        [_tfExtraNote setTextColor:[UIColor asphalt]];
        [_tfExtraNote setKeyboardType:UIKeyboardTypeNamePhonePad];
        [self.contentView addSubview:_tfExtraNote];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_tfExtraNote setFrame:CGRectMake(20, 5, self.contentView.frame.size.width - 30, self.contentView.frame.size.height - 10)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
    
}

- (BOOL)isFirstResponder {
    if ([_tfExtraNote isFirstResponder]) {
        return YES;
    } else {
        return [super isFirstResponder];
    }
}

@end



NSString* findReservationCellById(NSNumber *cellId) {
    return nil;
}