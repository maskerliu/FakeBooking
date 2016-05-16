//
//  OnlineReservationCells.h
//  FakeReservation
//
//  Created by yixin.jiang on 5/12/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import <UIKit/UIKit.h>


const static NSInteger OnlineReservationCell_PeopleCount = 0;
const static NSInteger OnlineReservationCell_Date = 1;
const static NSInteger OnlineReservationCell_Name = 2;
const static NSInteger OnlineReservationCell_TelePhone = 3;
const static NSInteger OnlineReservationCell_ExtraNote = 4;


@interface OnlineReservationCell : UITableViewCell

@property (nonatomic, assign) NSInteger cellId; // 在线预订页的Cell标识编号

@end


@interface SelectPeopleCountCell : OnlineReservationCell

@property (nonatomic, strong) NSString *peopleCount;

@end


@interface SelectDateCell : OnlineReservationCell

@end


@interface NameCell : OnlineReservationCell<UITextFieldDelegate>

@end


@interface TelePhoneCell : OnlineReservationCell<UITextFieldDelegate>

@end


@interface ExtraNoteCell : OnlineReservationCell<UITextFieldDelegate>

@end


