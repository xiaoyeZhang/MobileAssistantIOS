
//
//  M_Product_listViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/4/17.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "M_Product_listViewController.h"

@interface M_Product_listViewController ()
{
    UITableViewCell *cell;
    NSMutableArray *selectArray;
    NSMutableDictionary *retunDic;
}
@end

@implementation M_Product_listViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    selectArray = [NSMutableArray array];
    retunDic = [NSMutableDictionary dictionary];
    
    self.data_arr = [NSMutableArray array];
    self.data_arrCutomer = [NSMutableArray array];
    
    NSMutableArray *data_arr = [NSMutableArray arrayWithArray:[_entity.data_info componentsSeparatedByString:@";"]];
    
    self.data_arrCutomer = data_arr;
    self.data_arr = data_arr;
    
    [self.textFieldKey addTarget:self action:@selector(TextFieldEndEdited:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked:(id)sender{
    
    if(retunDic.count > 0 && self.delegate && [self.delegate respondsToSelector:@selector(successM_Product_listViewDelegate:)]){
        
        
        [_delegate successM_Product_listViewDelegate:retunDic];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (IBAction)doSelectByKey:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (self.textFieldKey.text.length > 0) {
        [selectArray removeAllObjects];
        for (int i = 0; i < [self.data_arr count]; i++) {
            if ([[[self.data_arr objectAtIndex:i] objectForKey:@"name"]rangeOfString:self.textFieldKey.text].location != NSNotFound ) {
                [selectArray addObject:[self.data_arrCutomer objectAtIndex:i]];
            }
        }
        if ([selectArray count] == 0) {
            
            ALERT_ERR_MSG(@"没有你想要的！");
            return;
        }
        //        [deleteArr removeAllObjects];
        self.data_arrCutomer = selectArray;
        [self.tableView reloadData];
    }else{
        
        [self.data_arrCutomer removeAllObjects];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.data_arrCutomer.count;
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
    cell.textLabel.text = [self.data_arrCutomer objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    [retunDic setObject:[self.data_arrCutomer objectAtIndex:indexPath.row] forKey:@"message"];
    [retunDic setObject:self.entity forKey:@"entity"];

    [self rightBtnClicked:nil];
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
