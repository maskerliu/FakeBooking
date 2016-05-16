//
//  FakeReservationVC.m
//  FakeReservation
//
//  Created by yixin.jiang on 5/11/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import "FakeReservationVC.h"

#import "OnlineReservationCells.h"

@interface FakeReservationVC ()<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_viewConfig;
    
    NameCell *_nameCell;
    TelePhoneCell *_telePhoneCell;
    ExtraNoteCell *_extraNoteCell;
}

@property (nonatomic, strong) NSArray *heros;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FakeReservationVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor cloud]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_hideKeyBoard)];
//    tapGesture.numberOfTapsRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGesture];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height - 100)
                                                  style:UITableViewStyleGrouped];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    
    UIButton *btnReservation = [UIButton greenButtonWithFrame:CGRectMake(15, self.view.bounds.size.height - 120, self.view.bounds.size.width - 30, 44)];
    [btnReservation setTitle:@"预订" forState:UIControlStateNormal];
    [btnReservation addTarget:self action:@selector(p_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnReservation];
    
    _viewConfig = [[NSMutableArray alloc] init];
    
   
    NSArray *sectionConfig = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:OnlineReservationCell_PeopleCount],
                              [NSNumber numberWithInt:OnlineReservationCell_Date], nil];
    [_viewConfig addObject:sectionConfig];
    sectionConfig = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:OnlineReservationCell_Name], [NSNumber numberWithInt:OnlineReservationCell_TelePhone], nil];
    [_viewConfig addObject:sectionConfig];
    sectionConfig = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:OnlineReservationCell_ExtraNote], nil];
    [_viewConfig addObject:sectionConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
// 返回多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _viewConfig.count;
}

// 返回每一组有多少行
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = (NSArray *)_viewConfig[section];
    return array.count;
}

// 返回哪一组的哪一行显示什么内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionConfig = (NSArray *)_viewConfig[indexPath.section];
    NSNumber *cellId = sectionConfig[indexPath.row];
    Class cellClazz = [self p_findCellByCellId:cellId];
    UITableViewCell *cell = [[cellClazz alloc] init];
    
    switch (cellId.integerValue) {
        case OnlineReservationCell_Name:
            _nameCell = (NameCell *)cell;
            break;
        case OnlineReservationCell_TelePhone:
            _telePhoneCell = (TelePhoneCell *)cell;
        case OnlineReservationCell_ExtraNote:
            _extraNoteCell = (ExtraNoteCell *)cell;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
/*
// 当每一行的cell的高度不一致的时候就使用代理方法设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.row) {
        return 180;
    }
    return 44;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}


- (void)keyboardWillHidden:(NSNotification*)aNotification
{
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 51);
}

- (void)p_touchTableView {
    [self p_hideKeyBoard];
}

- (void)keyboardDidShown:(NSNotification*)aNotification
{
    CGRect kbBounds;
    [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&kbBounds];
    
    CGFloat keyboardHeight = kbBounds.size.height;
    self.tableView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight);
    
    
    if ([_nameCell isFirstResponder]) {
        [self.tableView scrollRectToVisible:_nameCell.frame animated:YES];
    }
    
    if ([_telePhoneCell isFirstResponder]) {
        [self.tableView scrollRectToVisible:_telePhoneCell.frame animated:YES];
    }
    
    if ([_extraNoteCell isFirstResponder]) {
        [self.tableView scrollRectToVisible:_extraNoteCell.frame animated:YES];
    }
}

- (void)p_hideKeyBoard {
    [_nameCell resignFirstResponder];
    [_telePhoneCell resignFirstResponder];
    [_extraNoteCell resignFirstResponder];
}

- (void)p_buttonClick:(UIButton *)btn {
    [self p_fetchInfo:btn];
}

- (void)p_fetchInfo:(UIButton *)btn {
    NSString *urlStr = [NSString stringWithFormat:@"http://www.baidu.com/%@", @""];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
                                                    NSLog(@"%ld", (long)httpResp.statusCode);
                                                    NSLog(@"%lu", (unsigned long)data.length);
                                                }];
    [dataTask resume];
    
}

- (Class)p_findCellByCellId:(NSNumber *)cellId {
    switch (cellId.intValue) {
        case OnlineReservationCell_PeopleCount:
            return [SelectPeopleCountCell class];
        case OnlineReservationCell_Date:
            return [SelectDateCell class];
        case OnlineReservationCell_Name:
            return [NameCell class];
        case OnlineReservationCell_TelePhone:
            return [TelePhoneCell class];
        case OnlineReservationCell_ExtraNote:
            return [ExtraNoteCell class];
        default:
            return nil;
    }
}

@end
