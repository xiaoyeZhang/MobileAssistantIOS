//
//  Select_section_ManmerViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 16/7/26.
//  Copyright © 2016年 avatek. All rights reserved.
//

#import "Select_section_ManmerViewController.h"
#import "Ooe_LabelTableViewCell.h"

@interface Select_section_ManmerViewController ()
{
    NSMutableArray *arrayCutomer;
}
@end

@implementation Select_section_ManmerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayCutomer = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([self.type isEqualToString:@"2"]) {
        
        self.navigationItem.title = [self.selectDic objectForKey:@"name"];
        
    }else{
        
        self.navigationItem.title = @"选择下级执行人";
        
        [self getData];
    }
}

//返回
- (void)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.type isEqualToString:@"2"]) {
        return [[self.selectDic objectForKey:@"list"] count];
    }
    return arrayCutomer.count;
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
    if ([self.type isEqualToString:@"2"]) {
        cell.titleLabel.text = [[self.selectDic objectForKey:@"list"][indexPath.row] objectForKey:@"name"];
    }else{
        cell.titleLabel.text = [arrayCutomer[indexPath.row] objectForKey:@"name"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    if ([self.type isEqualToString:@"2"]) {
        
        if ([self.delegate respondsToSelector:@selector(Select_section_ManmerViewController:didSelectUser:)]) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setValue:self.navigationItem.title forKey:@"title"];
            [dic setValue:[self.selectDic objectForKey:@"list"][indexPath.row] forKey:@"list"];
            [self.delegate Select_section_ManmerViewController:self didSelectUser:dic];
        }
        
    }else{
        
        [_tcVC set_Section_Customer:arrayCutomer[indexPath.row]];
    
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)getData{
    
    
    CommonService *service = [[CommonService alloc] init];
    NSDictionary *dict = @{@"method":@"get_two_level_manager",

                           };
    
    [service getNetWorkData:dict  Successed:^(id entity) {
        
        int state = [entity[@"state"] intValue];
        
        if (state == 0) {

            
        }else{
            
            for (NSDictionary *dic in [entity valueForKey:@"content"]) {
                
                [arrayCutomer addObject:dic];
            }
        
        }
     
        [_tableView reloadData];
        
    } Failed:^(int errorCode, NSString *message) {

    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
