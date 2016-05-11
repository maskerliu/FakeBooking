//
//  NSData+DPNetwork.h
//  FakeReservation
//
//  Created by yixin.jiang on 5/11/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(DPNetwork)

- (NSData *)dp_decodeMobileData;
- (NSData *)dp_encodeMobileData;

@end
