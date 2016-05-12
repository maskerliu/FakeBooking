//
//  DemoVC.m
//  FakeReservation
//
//  Created by yixin.jiang on 5/11/16.
//  Copyright © 2016 dianping. All rights reserved.
//

#import "DemoVC.h"

#import "OnlineReservationCells.h"

@interface DemoVC ()<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_viewConfig;
}

@property (nonatomic, strong) NSArray *heros;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor cloud]];
    
    UIButton *btnReservation = [UIButton greenButtonWithFrame:CGRectMake(15, self.view.bounds.size.height - 50, self.view.bounds.size.width - 30, 44)];
    [btnReservation setTitle:@"预订" forState:UIControlStateNormal];
    [btnReservation addTarget:self action:@selector(p_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnReservation];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.frame.size.height - 100)
                                                  style:UITableViewStyleGrouped];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    
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
    // 1.创建CELL
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.text = @"hello world";
    cell = [[cellClazz alloc] init];
    // 3.返回cell
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
