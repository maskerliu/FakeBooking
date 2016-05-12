//
//  MainViewController.m
//  FakeReservation
//
//  Created by yixin.jiang on 5/10/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import "MainViewController.h"
#import "DemoVC.h"

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
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)p_buttonClick:(UIButton *)btn {
    DemoVC *demoVC = [[DemoVC alloc] init];
    [self.navigationController pushViewController:demoVC animated:YES];
}

@end
