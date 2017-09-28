//
//  Select_ object_ViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/15.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Select_object_ViewController.h"
#import "Ooe_LabelTableViewCell.h"

@interface Select_object_ViewController (){
    
    NSMutableArray *deleteArr;
    UIButton *rightBtn;
}

@property (strong, nonatomic) NSMutableArray *arrayCutomer;
@end

@implementation Select_object_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"选择派发对象";
    
    self.arrayCutomer = [[NSMutableArray alloc]init];
    deleteArr = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    rightBtn = [self setNaviRightBtnWithTitle:@"确定"];
    
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    self.tableView.editing = YES;
    
    
    [_arrayCutomer addObject:@{@"name":@"贵阳市",@"dep_id":@"10001"}];
    [_arrayCutomer addObject:@{@"name":@"六盘水市",@"dep_id":@"10002"}];
    [_arrayCutomer addObject:@{@"name":@"遵义市",@"dep_id":@"10003"}];
    [_arrayCutomer addObject:@{@"name":@"铜仁市",@"dep_id":@"10004"}];
    [_arrayCutomer addObject:@{@"name":@"黔西南政企事业部",@"dep_id":@"10005"}];
    [_arrayCutomer addObject:@{@"name":@"毕节市",@"dep_id":@"10006"}];
    [_arrayCutomer addObject:@{@"name":@"安顺市",@"dep_id":@"10007"}];
    [_arrayCutomer addObject:@{@"name":@"黔东南苗族侗族自治州",@"dep_id":@"10008"}];
    [_arrayCutomer addObject:@{@"name":@"黔南布依族苗族自治州",@"dep_id":@"10009"}];
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked:(UIButton *)sender{
    
    [_tcVC setCustomer:deleteArr];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayCutomer.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Ooe_LabelTableViewCell";
    
    Ooe_LabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.titleLabel.text = _arrayCutomer[indexPath.row][@"name"];
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}

//取消选中时 将存放在self.deleteArr中的数据移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [deleteArr removeObject:self.arrayCutomer[indexPath.row]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    [deleteArr addObject:[self.arrayCutomer objectAtIndex:indexPath.row]];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
