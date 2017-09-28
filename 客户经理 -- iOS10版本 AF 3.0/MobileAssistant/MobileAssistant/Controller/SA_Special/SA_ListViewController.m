//
//  SA_ListViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/8/22.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "SA_ListViewController.h"
#import "MBProgressHUD.h"
#import "CustomerViewController.h"
#import "SA_Special_SumbitViewController.h"

@interface SA_ListViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    UITableViewCell *cell;
    NSMutableArray *selectArray;
    NSMutableArray *data_arrCutomer;
}
@end

@implementation SA_ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"产品列表";
    
    data_arrCutomer = [NSMutableArray array];
    selectArray = [NSMutableArray array];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getData];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doSelectByKey:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (self.textFieldKey.text.length > 0) {
        [selectArray removeAllObjects];
        for (int i = 0; i < [data_arrCutomer count]; i++) {
            if ([[[data_arrCutomer objectAtIndex:i] objectForKey:@"title"]rangeOfString:self.textFieldKey.text].location != NSNotFound ) {
                [selectArray addObject:[data_arrCutomer objectAtIndex:i]];
            }
        }
        if ([selectArray count] == 0) {
            
            ALERT_ERR_MSG(@"没有你想要的！");
            return;
        }
        data_arrCutomer = selectArray;
        [self.tableView reloadData];
    }else{
        
        [data_arrCutomer removeAllObjects];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return data_arrCutomer.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"identifier";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
    }
    cell.textLabel.text = [[data_arrCutomer objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *type = [[data_arrCutomer objectAtIndex:indexPath.row] objectForKey:@"type"];

    if ([type isEqualToString:@"0"]) {
        
        CustomerViewController *vc = [[CustomerViewController alloc]init];
        
        vc.product_name = [[data_arrCutomer objectAtIndex:indexPath.row] objectForKey:@"title"];
        
        vc.enter_type = 10;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([type isEqualToString:@"1"]){
        
        SA_Special_SumbitViewController *vc = [[SA_Special_SumbitViewController alloc]init];
    
        vc.type = type;
        
        vc.product_name = [[data_arrCutomer objectAtIndex:indexPath.row] objectForKey:@"title"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }

}

- (void)getData{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    CommonService *service = [[CommonService alloc]init];
    
    NSDictionary *dic = @{
                          @"method":@"m_order_sa_list",
                          };
    
    [service getNetWorkData:dic Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        
        if ([state intValue] > 0) {
            
            NSMutableArray *array = [entity objectForKey:@"content"];
            for (NSDictionary* attributes in array) {

                [data_arrCutomer addObject:attributes];
            }
            
        }else{
            
        }
        
        [_tableView reloadData];
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
}

- (void)TextFieldEndEdited:(UITextField *)TextField
{
    [TextField resignFirstResponder];
    
    [self doSelectByKey:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.textFieldKey resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
