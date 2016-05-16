//
//  MainViewController.m
//  FakeReservation
//
//  Created by yixin.jiang on 5/10/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import "MainViewController.h"

#import "FakeReservationVC.h"
#import "MAPI.h"

#import "RadioButtonGroup.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor cloud]];
    
    UIButton *btnReservation = [UIButton greenButtonWithFrame:CGRectMake(15, 90, self.view.bounds.size.width - 30, 44)];
    [btnReservation setTitle:@"预订" forState:UIControlStateNormal];
    [btnReservation addTarget:self action:@selector(p_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnReservation];
    
    
    [btnReservation addTarget:self action:@selector(btnReservationPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnReservation];
    
    UIButton *btnResult = [UIButton greenButtonWithFrame:CGRectMake(15, 150, self.view.bounds.size.width - 30, 44)];
    [btnResult setTitle:@"查看结果" forState:UIControlStateNormal];
    [btnResult addTarget:self action:@selector(btnResultPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnResult];
    
    NSMutableArray *rbgConfig = [[NSMutableArray alloc] init];
    [rbgConfig addObject:@{@"title": @"先生", @"value": @"0"}];
    [rbgConfig addObject:@{@"title": @"女士", @"value": @"1"}];
    RadioButtonGroup *rbg = [[RadioButtonGroup alloc] initWithFrame:CGRectMake(15, btnResult.frame.origin.y + btnResult.frame.size.height + 15, 200, 200)
                                                               data:rbgConfig];
    
    [self.view addSubview:rbg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)p_buttonClick:(UIButton *)btn {
    FakeReservationVC *demoVC = [[FakeReservationVC alloc] init];
    [self.navigationController pushViewController:demoVC animated:YES];
}

- (void)btnReservationPressed:(id)button
{
    MAPI *testApi = [MAPI new];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = @"2016-05-13 12:30:00";
    NSDate *date = [formatter dateFromString:dateString];
    
    [testApi dp_postToURL:@"http://rs.api.dianping.com/book.yy"
               parameters:@{
                            @"ismodify": @"0",
                            @"gender": @"20",
                            @"shopName": @"测试门店",
                            @"phone": @"86_18521051012",
                            @"bookingTimeLong": [NSString stringWithFormat:@"%@", @([self getTimestamp:date])],
                            @"peopleNumber": @"4",
                            @"shopID": @"56827309",
                            @"positionType": @"10",
                            @"cx": @"{\n  \"fingerprint\" : \"n0uLqVAk\\/RAwAg767+ckYj01e0iHxv0TYiiusBtrgkf8m7q4zlSpjqzv3mpCkdqPmHu4K2P1zpfqBzuG+5JUOvmU0vYeOWSZqobF1QZPwdxZcAjhedXmcMXsEsUcTc\\/UczYE6FfgioIwblPrbAdVwSY+2bGURCmOgtZgIFwsJB+YwIznIzxgC0GLSdekfu0YQn31UjMxaqXFq3SNjR7mDxt1NRye33wwyStUH8Lu1et7t3Qy8PkfGjWOg95sAN4gQZpGvC8VbU68S67oE6no0fuDvbCIJwJ8xbqrp4XvH\\/URf8iySFwADNCkefzIM5Fev9kV04dEGD5A7DJ9G\\/Z1EK4E7q5pibk1FJ+7SFttCC+ZG+msXLW66Kvv1xoVNVQZb8LN08ayTvYAX1VoHGcS\\/ApHGxfbjlK0jRS8SVCx4+maPZcGZbp+OZMkSQKlqKJBp38vAU3baCBsqNKxJ7R9HDXTLpssjpcFjWyNvXvgCVBkEihgI2nljjUufzYPPETZR2Pnn1k\\/JPbFYopehmsZp2fSbf97\\/zzFsHWk9DsGVDKwea363SQAYCgQZcVwc8pr3fEvlRsRFSfbiorkKFSFl5HM4zBxop9QQBBsIai2\\/lMtSslq0M8MOH+UIkVlb7Gwh3PvgHh0wTlzutURO\\/bJmdSlXw9\\/n5cOrm+TZ92wjbD5Nl+FQIA0Ej3LcJlLrMXtnhDlTZ9d4sGWT7xJB93YcGo0Ea9MGUNq1nB2aeT2\\/QPQbo7kYzZ6HL5xFYvOhxlWMoSYjI7CCijukOctTS4JMPEdpZ4zzkTl4\\/ZSXjWnXnMCAu6npS0ytWjs8z4Eaig1DOSthIPDsgwOq1zr85aGPR62+0UQ\\/IOSc8wRilJLNzWQws7UcZO\\/u3PV4sxnuklEeR\\/Fn9NoOCJm8ewDsxdq3A==\"\n}",
                            @"deviceId": @"76b378ae4c48d0ff4da1bee1a4e0f2ff272d9368",
                            @"bookingTime": dateString,
                            @"token": @"",
                            @"forceBook": @"0",
                            @"clientUUID": @"76b378ae4c48d0ff4da1bee1a4e0f2ff272d9368",
                            @"name": @"fax",
                            @"isinstead": @"0"
                            }
          completionBlock:^(NVObject *object, NSError *error) {
              
              NSString *result = [NSString stringWithFormat:@"%@\n订单号：%@", [object stringForKey:@"Message"], [object stringForKey:@"BookingRecordSerialNum"]];
              UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                       message:result
                                                                                preferredStyle:UIAlertControllerStyleAlert];
              
              UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:NULL];
              [alertController addAction:cancelAction];
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self presentViewController:alertController animated:YES completion:NULL];
              });
          }];
}

- (void)btnResultPressed:(id)button
{
    MAPI *testApi = [MAPI new];

    [testApi dp_getFromURL:@"http://rs.api.dianping.com/loadbooking.yy"
                parameters:@{
                             @"serializedid": @"0E28TCG",
                             }
           completionBlock:^(NVObject *object, NSError *error) {
               
               NSString *result = [NSString stringWithFormat:@"订单状态为 %ld", [object integerForKey:@"Status"]];
               NSLog(@"订单状态为%@", result);
           }];
}

- (long long)getTimestamp:(NSDate *)date{
    NSTimeInterval timestamp=[date timeIntervalSince1970];
    long long timestamp_i = ceil(timestamp*1000);
    return timestamp_i;
}

@end
