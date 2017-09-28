//
//  Product_listViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2016/10/28.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Product_listViewController.h"
#import "MBProgressHUD.h"

@interface Product_listViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *selectArray;
    NSMutableArray *deleteArr;
    UITableViewCell *cell;
}
@end

@implementation Product_listViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"产品列表";
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *rightBtn = [self setNaviRightBtnWithTitle:@"确定"];
//    
//    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.tableView.editing = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    deleteArr = [NSMutableArray array];
    selectArray = [[NSMutableArray alloc]init];
    self.arrayCustomerTemp = [NSMutableArray array];
    self.arrayCutomer = [NSMutableArray array];
    
    [self.textFieldKey addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self loadData];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked:(id)sender{

    if(deleteArr.count > 0 && self.delegate && [self.delegate respondsToSelector:@selector(successProduct_listDelegate:)]){


        [_delegate successProduct_listDelegate:deleteArr];

        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrayCustomerTemp.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

//   CGSize size = [cell.textLabel sizeThatFits:CGSizeMake(cell.textLabel.frame
//                                                           .size.width, MAXFLOAT)];
//    if (size.height == 0) {
//        return 50;
//    }
//    
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
    cell.textLabel.text = [[self.arrayCustomerTemp objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}

////取消选中时 将存放在self.deleteArr中的数据移除
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    [deleteArr removeObject:self.arrayCustomerTemp[indexPath.row]];
//    
//}

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return YES;
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    [deleteArr addObject:[self.arrayCustomerTemp objectAtIndex:indexPath.row]];
    
    [self rightBtnClicked:nil];
}

- (void)loadData{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"努力加载中...";
    
    [self getData];
}

- (void)getData{
    
    CommonService *service = [[CommonService alloc]init];
    
    NSDictionary *dic = @{@"method":@"order_product_list"};
    [service getNetWorkData:dic Successed:^(id entity) {
        NSNumber *state = [entity valueForKeyPath:@"state"];
        NSString *strState = [NSString stringWithFormat:@"%d", [state intValue]];
        
        if ([strState isEqualToString:@"1"] == YES) {
            
            for (NSDictionary *dic in [entity valueForKey:@"content"]) {
                
                [self.arrayCutomer addObject:dic];
                [self.arrayCustomerTemp addObject:dic];

            }
        }
        
        [self.tableView reloadData];
        
        [HUD hide:YES];
    } Failed:^(int errorCode, NSString *message) {
        [HUD hide:YES];
    }];
    
}

- (IBAction)doSelectByKey:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (self.textFieldKey.text.length > 0) {
        [selectArray removeAllObjects];
        for (int i = 0; i < [self.arrayCutomer count]; i++) {
            if ([[[self.arrayCutomer objectAtIndex:i] objectForKey:@"name"]rangeOfString:self.textFieldKey.text].location != NSNotFound ) {
                [selectArray addObject:[self.arrayCutomer objectAtIndex:i]];
            }
        }
        if ([selectArray count] == 0) {
            
            ALERT_ERR_MSG(@"没有你想要的！");
            return;
        }
//        [deleteArr removeAllObjects];
        self.arrayCustomerTemp = selectArray;
        [self.tableView reloadData];
    }else{
        
        [self.arrayCustomerTemp removeAllObjects];
        [self loadData];
    }
    
}

- (void)TextFieldEndEdited:(UITextField *)TextField
{
    [TextField resignFirstResponder];
    
    [self doSelectByKey:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.textFieldKey resignFirstResponder];
    
}

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    [self.textFieldKey resignFirstResponder];
//    
//    [self doSelectByKey:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
