//
//  Bless_informationViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/4/7.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Bless_informationViewController.h"
#import "Bless_informationTableViewCell.h"
#import "MBProgressHUD.h"
#import "sms_ListEntity.h"
#import "MJRefresh.h"
#import "CoustomerMainNewsViewController.h"
#import <MessageUI/MFMessageComposeViewController.h>

@interface Bless_informationViewController ()<MBProgressHUDDelegate,MJRefreshBaseViewDelegate,MFMessageComposeViewControllerDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_fooder;
    Bless_informationTableViewCell *cell;
    MBProgressHUD *HUD;
   

}
@property (assign, nonatomic) int pageNum;
@property (strong, nonatomic) NSMutableArray *arrayCutomer;
@end

@implementation Bless_informationViewController

- (void)dealloc{
    
    [_header free];
    [_fooder free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 0;
    self.navigationItem.title = self.Title;
    self.arrayCutomer = [[NSMutableArray alloc]init];

    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addRefreshView];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    [self getData:self.pageNum];
}

#pragma mark - ButtonMethod

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRefreshView
{
    __weak typeof(self) weakSelf = self;
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = self.tableView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        [weakSelf.arrayCutomer removeAllObjects];
        
        [weakSelf getData:weakSelf.pageNum];
    };
    
    _fooder = [MJRefreshFooterView footer];
    _fooder.scrollView = self.tableView;
    

    _fooder.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        weakSelf.pageNum = weakSelf.pageNum + 12;
        
        [weakSelf getData:weakSelf.pageNum];
        
    };
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayCutomer.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = [cell.titleLabel sizeThatFits:CGSizeMake(cell.titleLabel.frame
                                                              .size.width, MAXFLOAT)];
    if (size.height == 0) {
        return 100;
    }
    return size.height + 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Bless_informationTableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
    }
    
    sms_ListEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = entity.content;
    cell.NumLabel.text = [NSString stringWithFormat:@"人气:%@",entity.count];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    sms_ListEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
    
    if(self.delegate&&[self.delegate respondsToSelector:@selector(successBless_informationdelegate:)]){

        NSDictionary *dict = @{@"content":entity.content,
                               @"sms_id":entity.sms_id,
                               };
        
        [_delegate successBless_informationdelegate:dict];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        if (self.telArr.count > 0) {

          [self sendSMS:entity.content recipientList:self.telArr];

        }else{
            CoustomerMainNewsViewController *vc = [[CoustomerMainNewsViewController alloc]init];
            vc.type = @"1";
            vc.message = entity.content;
            [self.navigationController pushViewController:vc animated:YES];
        }
 
    }
    
    
}

- (void)getData:(int)page{
    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *dict = @{@"method":@"get_sms_list",
                           @"type_id":self.type_id,
                           @"location":@(page)
                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            NSMutableArray *arr = [entity objectForKey:@"content"];
            
            for (NSDictionary *attributes in arr) {
                sms_ListEntity *entity = [[sms_ListEntity alloc] init];
                entity = [entity initWithAttributes:attributes];
                [self.arrayCutomer addObject:entity];
            }
            
        }else{
            
        }
        [self.tableView reloadData];
        [HUD hide:YES];
        [_header endRefreshing];
        [_fooder endRefreshing];
    } Failed:^(int errorCode, NSString *message) {
        [_header endRefreshing];
        [_fooder endRefreshing];
        [HUD hide:YES];
        
    }];
    
    
}

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText]) {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{
            ;
        }];
    }
}

// 处理发送完的响应结果
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //Notifies users about errors associated with the interface
    switch (result) {
        case MessageComposeResultCancelled:
            DebugLog(@"Result: canceled");
            break;
        case MessageComposeResultSent:
            DebugLog(@"Result: Sent");
            break;
        case MessageComposeResultFailed:
            DebugLog(@"Result: Failed");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
