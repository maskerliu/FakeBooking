//
//  MainViewController.m
//  FakeReservation
//
//  Created by yixin.jiang on 5/10/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import "MainViewController.h"
#import "UIButton+Extension.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *btnReservation = [UIButton greenButtonWithFrame:CGRectMake(15, 50, self.view.bounds.size.width - 30, 44)];
    [btnReservation setTitle:@"预订" forState:UIControlStateNormal];
    [self.view addSubview:btnReservation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
