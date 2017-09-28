//
//  White_query_Detail_listViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/5/13.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "White_query_Detail_listViewController.h"
#import "Bussiness_CustomerTableViewCell.h"
#import "TwoLablesTableViewCell.h"
#import "White_query_DetailViewController.h"

@interface White_query_Detail_listViewController ()<UITextFieldDelegate>
{
    UILabel *titleLabel;
    UILabel *subLabel;
}
@property(strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) NSString *isVMStr;
@end

@implementation White_query_Detail_listViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[[[self.ListDic objectForKey:@"ResultList"] objectAtIndex:0] objectForKey:@"ActivityInfo"] objectForKey:@"IsVpmnMember"] isEqualToString:@"0"]) {
        self.isVMStr = @"否";
    }else{
        self.isVMStr = @"是";
    }
    
    
    self.navigationItem.title = @"可办理的营销活动";
        
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self getData];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    self.dataArr = [[NSMutableArray alloc] initWithObjects:
                    @{@"title":@"电话号码："},
                    @{@"title":@"是否为集团V网用户："},nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    if (section == 0) {
        num = 2;
    }else if (section == 1){
        num = [[self.ListDic objectForKey:@"ResultList"] count];
//        num = 5;
    }
    return num;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return 100;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier1 = @"TwoLablesTableViewCell";
    static NSString *identifier2 = @"Bussiness_CustomerTableViewCell";
    TwoLablesTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
    
    if(!cell1)
    {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil] firstObject];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            
            cell1.titleLbl.alpha = 0;
            cell1.subTitleLbl.alpha = 0;
            if (titleLabel == nil) {
                
                titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 140, 40)];
                subLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.size.width - 8, 0, cell1.frame.size.width - titleLabel.frame.size.width - 8, 40)];
                
            }
            
            titleLabel.text = self.dataArr[indexPath.row][@"title"];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = [UIFont systemFontOfSize:14];
        
            
            subLabel.text = self.isVMStr;
            subLabel.textAlignment = NSTextAlignmentCenter;
            subLabel.font = [UIFont systemFontOfSize:15];
            
            [cell1 addSubview:titleLabel];
            [cell1 addSubview:subLabel];
        }else{
            cell1.titleLbl.text = self.dataArr[indexPath.row][@"title"];
            cell1.subTitleLbl.text = [self.ListDic objectForKey:@"ServiceNum"];
        }
        
        return cell1;
    }else{
       
        Bussiness_CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil] firstObject];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
//        Arrears_taskEntity *entity = [self.arrayCutomer objectAtIndex:indexPath.row];
//        cell.CustomerName.text = @"贵阳全球通经典套餐（策划）贵阳全球通经典套餐（策划）";
        cell.CustomerName.text = [[[[self.ListDic objectForKey:@"ResultList"] objectAtIndex:indexPath.row] objectForKey:@"ActivityInfo"] objectForKey:@"BigActivityName"];
        cell.CustomerNum.text = [NSString stringWithFormat:@"生效时间：%@",[[[[[self.ListDic objectForKey:@"ResultList"] objectAtIndex:indexPath.row] objectForKey:@"ActivityInfo"] objectForKey:@"EffDate"] substringToIndex:10]];
        cell.CustomerAddress.text = [NSString stringWithFormat:@"失效时间：%@",[[[[[self.ListDic objectForKey:@"ResultList"] objectAtIndex:indexPath.row] objectForKey:@"ActivityInfo"] objectForKey:@"ExpDate"] substringToIndex:10]];
        return cell;
  
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == [tableView numberOfSections]-1) {
        title = @"> 营销活动列表";
    }
    
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {

        White_query_DetailViewController *vc = [[White_query_DetailViewController alloc]init];
        vc.DicCustomerTemp = [[[self.ListDic objectForKey:@"ResultList"] objectAtIndex:indexPath.row] objectForKey:@"ActivityInfo"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void) getData{
    
    CommonService *service = [[CommonService alloc] init];
    
    NSDictionary *dict = @{@"method":@"whole_province",
                           @"oicode":@"OI_QueryMemberOfOfferInfo",
                           @"ServiceNum":[self.ListDic objectForKey:@"ServiceNum"],
                           };
    
    [service getNetWorkData:dict Successed:^(id entity) {
        int state = [entity[@"state"] intValue];
        
        if (state == 1) {
        
            NSArray *arr = [entity objectForKey:@"content"];
            if (arr.count > 0) {
                
                self.isVMStr = @"是";
            }else{
                
                self.isVMStr = @"否";
            
            }
            
        }else{
            
            self.isVMStr = @"否";
        
        }
        
        [self.tableView reloadData];
        
    } Failed:^(int errorCode, NSString *message) {
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
