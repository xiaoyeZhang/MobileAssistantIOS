//
//  P_BusinessBaseViewController.m
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/1.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import "P_BusinessBaseViewController.h"
#import "Utilies.h"
#import "UIAlertView+Blocks.h"
#
@interface P_BusinessBaseViewController ()
{
    BOOL isDone;
}
@end

@implementation P_BusinessBaseViewController

- (void)dealloc
{
    [refreshHeader free];
    [refreshFooter free];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    super.model = NSStringFromClass([self class]);
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //客户经理才能提交
//    UserEntity *userInfo = [UserEntity sharedInstance];
//    if ([userInfo.type_id intValue] == ROLE_CUSTOMER) {
        UIButton *addBtn = [self setNaviRightBtnWithTitle:@"添加"];
        [addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
    isDone = NO;
    
    self.startTime = [Utilies getLastMonth];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.endTime = [dateFormatter stringFromDate:[NSDate date]];;
    
    [dateBtn setTitle:[NSString stringWithFormat:@"  ~ %@",self.endTime]
             forState:UIControlStateNormal];
    
    listMuArr = [[NSMutableArray alloc] init];
    
    [self addRefreshView];
    
    [self getSpecialConfig];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subVCBackNeedRefresh:) name:BUSINESS_LIST_REFRESH_NOTIFY object:nil];
}

#pragma mark - ButtonMethod

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//添加
- (void)addBtnClicked:(id)sender
{
    
}

//待办事项点击
- (IBAction)waitBtnClicked:(id)sender
{
    waitBtn.selected = !waitBtn.selected;
    
    self.currentPage = 0;
    [self getBusinessListWithPage:self.currentPage];
}

//时间区间选择
- (IBAction)dateBtnClicked:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *startDate = [dateFormatter dateFromString:self.startTime];
    NSDate *endDate = [dateFormatter dateFromString:self.endTime];
    
    XYStartEndDatePicker *picker = [XYStartEndDatePicker datePicker];
    picker.startDatePicker.date = startDate;
    picker.endDatePicker.date = endDate;
    picker.delegate = self;
    [picker show];
}

#pragma mark -

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    
    refreshHeader = [MJRefreshHeaderView header];
    refreshHeader.scrollView = _tableView;
    refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        weakSelf.currentPage = 0;
        [weakSelf getBusinessListWithPage:weakSelf.currentPage];
    };
    
    refreshFooter = [MJRefreshFooterView footer];
    refreshFooter.scrollView = _tableView;
    refreshFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        [weakSelf getBusinessListWithPage:[listMuArr count]];
    };
}

- (void)getSpecialConfig
{
    UserEntity *userInfo = [UserEntity sharedInstance];
    NSDictionary *dict = @{@"method":@"special_config",
                           @"user_id":userInfo.user_id};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict
                  Successed:^(id entity) {
                      int state = [entity[@"state"] intValue];
                      
                      if (state == 1) {
                          id content = entity[@"content"];
                          
                          self.specialConfigStr = content;
                          
                          [super setSpecialConfigStr:self.specialConfigStr];
                          
                      }
                  } Failed:^(int errorCode, NSString *message) {
                      
                  }];
}


#pragma mark -

- (void)getBusinessListWithPage:(int)page
{
    
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    NSDictionary *dict = @{@"user_id":userInfo.user_id,
                           @"method":@"getbusiness_list",
                           @"dep_id":userInfo.dep_id,
                           @"user_type":userInfo.type_id,
                           @"unfinish":waitBtn.selected?@"0":@"2",
                           @"page":@(page),
                           @"type_id":self.typeId,
                           @"start_time":isDone?self.startTime:@"",
                           @"end_time":isDone?self.endTime:@""};
    
    CommonService *service = [[CommonService alloc] init];
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"]) {
            
            id content = entity[@"content"];
            NSArray *arr = [BusinessListModel objectArrayWithKeyValuesArray:content];
            
            if (page == 0) {
                [listMuArr removeAllObjects];
                [listMuArr addObjectsFromArray:arr];
                
                [_tableView reloadData];
            }else{
                [listMuArr addObjectsFromArray:arr];
                
                NSInteger rows = [_tableView numberOfRowsInSection:0];
                NSInteger insertRows = [arr count];
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                for (NSInteger i = rows; i < rows+insertRows; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [indexPaths addObject:indexPath];
                }
                
                //插入数据
                [_tableView beginUpdates];
                [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [_tableView endUpdates];
            }
            
        }else{
            if (waitBtn.selected) {
                [listMuArr removeAllObjects];
                
                [_tableView reloadData];
            }
        }
        
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
        
    } Failed:^(int errorCode, NSString *message) {
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
        
    }];
}

#pragma mark - XYStartEndDatePickerDelegate

- (void)startEndDatePickerDonePressed:(XYStartEndDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.startTime = [dateFormatter stringFromDate:datePicker.startDatePicker.date];
    self.endTime = [dateFormatter stringFromDate:datePicker.endDatePicker.date];
    
    
    NSString *dateStr = [NSString stringWithFormat:@" %@ ~ %@",self.startTime,self.endTime];
    [dateBtn setTitle:dateStr forState:UIControlStateNormal];
    
    isDone = YES;

    self.currentPage = 0;
    [self getBusinessListWithPage:self.currentPage];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listMuArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    BusinessListModel *model = listMuArr[indexPath.row];
    
    NSString *title = [NSString stringWithFormat:@"%@(%@)",model.title,\
                       [StringHelper getBusinessStateString:model.state]];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = model.create_time;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessListModel *model = listMuArr[indexPath.row];
    UserEntity *userInfo = [UserEntity sharedInstance];
    
    if ([userInfo.user_id isEqualToString:model.create_id]) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) { //删除
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"确定要删除该工单吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"删除", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex != alert.cancelButtonIndex) {
                
                UserEntity *userInfo = [UserEntity sharedInstance];
                BusinessListModel *model = listMuArr[indexPath.row];
                
                NSDictionary *dict = @{@"method":@"change_state",
                                       @"state":@"-2",
                                       @"business_id":model.business_id,
                                       @"user_id":userInfo.user_id,
                                       @"next_processor":@"-1"};
                
                CommonService *service = [[CommonService alloc] init];
                [service getNetWorkData:dict
                              Successed:^(id entity) {
                                  int state = [entity[@"state"] intValue];
                                  
                                  if (state == 1) {
                                      ALERT_ERR_MSG(@"删除成功");
                                      
                                      [listMuArr removeObjectAtIndex:indexPath.row];
                                      
                                      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                  }else{
                                      ALERT_ERR_MSG(@"删除失败");
                                  }
                              } Failed:^(int errorCode, NSString *message) {
                                  ALERT_ERR_MSG(@"网络连接错误");
                              }];
                
            }
        }];
        

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 刷新数据

- (void)subVCBackNeedRefresh:(id)sender
{
    //刷新数据

    self.currentPage = 0;
    [self getBusinessListWithPage:self.currentPage];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
