//
//  FakeReservationVC.m
//  FakeReservation
//
//  Created by yixin.jiang on 5/11/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import "FakeReservationVC.h"

#import "OnlineReservationCells.h"

@interface FakeReservationVC ()<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    NSMutableArray *_viewConfig;
    
    SelectPeopleCountCell *_peopleCountCell;
    NameCell *_nameCell;
    TelePhoneCell *_telePhoneCell;
    ExtraNoteCell *_extraNoteCell;
    
    UIView *_vPeopleCountBg;
    UIPickerView *_pvPeopleCount;
    
    NSMutableArray *_peopleCountConfig;
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
    
    
    _vPeopleCountBg = [[UIView alloc] initWithFrame:self.view.bounds];
    [_vPeopleCountBg setBackgroundColor:[UIColor colorWithHex:@"#a0000000"]];
    [_vPeopleCountBg setHidden:YES];
    [self.view addSubview:_vPeopleCountBg];
    
    _pvPeopleCount = [[UIPickerView alloc] init];
    _pvPeopleCount.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, _pvPeopleCount.bounds.size.height);
    [_pvPeopleCount setBackgroundColor:[UIColor whiteColor]];
    [_pvPeopleCount setDelegate:self];
    [_pvPeopleCount setDataSource:self];
    [self.view addSubview:_pvPeopleCount];
    
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapGesture.cancelsTouchesInView = NO;
    [_vPeopleCountBg addGestureRecognizer:tapGesture];
    
    
    _peopleCountConfig = [[NSMutableArray alloc] initWithObjects:@"2", @"3", @"4", @"6", @"8", @"10", @"12", @"15+", nil];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewConfig.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = (NSArray *)_viewConfig[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionConfig = (NSArray *)_viewConfig[indexPath.section];
    NSNumber *cellId = sectionConfig[indexPath.row];
    Class cellClazz = [self p_findCellByCellId:cellId];
    UITableViewCell *cell = [[cellClazz alloc] init];
    
    switch (cellId.integerValue) {
        case OnlineReservationCell_PeopleCount:
            _peopleCountCell = (SelectPeopleCountCell *)cell;
            break;
        case OnlineReservationCell_Name:
            _nameCell = (NameCell *)cell;
            break;
        case OnlineReservationCell_TelePhone:
            _telePhoneCell = (TelePhoneCell *)cell;
            break;
        case OnlineReservationCell_ExtraNote:
            _extraNoteCell = (ExtraNoteCell *)cell;
            break;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *sectionConfig = (NSArray *)_viewConfig[indexPath.section];
    NSNumber *cellId = sectionConfig[indexPath.row];
    
    switch (cellId.integerValue) {
        case OnlineReservationCell_PeopleCount:
            [self p_showPicker];
            break;
        case OnlineReservationCell_Date:
            
            break;
        default:
            break;
    }
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _peopleCountConfig.count;
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 100;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _peopleCountConfig[row];
}


//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [_peopleCountCell setPeopleCount:_peopleCountConfig[row]];
    [self p_hidePicker];
}


- (void)p_hidePicker {
    [_vPeopleCountBg setHidden:YES];
    float pvHeight = _pvPeopleCount.frame.size.height;
    float y = self.view.bounds.size.height - (pvHeight * -2); // the root view of view controller
    [UIView animateWithDuration:0.5f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _pvPeopleCount.frame = CGRectMake(0 , y, _pvPeopleCount.frame.size.width, pvHeight);
                     }
                     completion:nil];
}

- (void)p_showPicker {
    [_vPeopleCountBg setHidden:NO];
    float pvHeight = _pvPeopleCount.frame.size.height;
    float y = self.view.bounds.size.height - (pvHeight); // the root view of view controller
    [UIView animateWithDuration:0.5f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _pvPeopleCount.frame = CGRectMake(0, y, _pvPeopleCount.frame.size.width, pvHeight);
                     }
                     completion:nil];
}

-(void)tapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    [_vPeopleCountBg endEditing:YES];
    [self p_hidePicker];
}

- (void)keyboardWillHidden:(NSNotification*)aNotification
{
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 51);
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
