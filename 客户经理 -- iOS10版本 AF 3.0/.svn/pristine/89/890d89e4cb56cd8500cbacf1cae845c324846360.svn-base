//
//  ExaminationViewController.m
//  MobileAssistant
//
//  Created by 张晓烨 on 2017/6/8.
//  Copyright © 2017年 avatek. All rights reserved.
//

#import "ExaminationViewController.h"
#import "ExaminationTableViewCell.h"
#import <CoreText/CoreText.h>
#import "Examination_SeconViewController.h"

@interface ExaminationViewController ()

@end

@implementation ExaminationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的试卷";
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    UIButton *backBtn = [self setNaviCommonBackBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

//返回
- (void)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"ExaminationTableViewCell";
    ExaminationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }

    NSString *numStr = @"2";
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"当前有%@张试卷",numStr]];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, numStr.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(3, numStr.length)];
    
    long number = 3.f;
    
    //CFNumberRef添加字间距
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);    [str addAttribute:(id)kCTKernAttributeName value:(__bridge id _Nonnull)(num) range:NSMakeRange(2,[numStr length] + 1)];
    
    //清除CFNumberRef
    CFRelease(num);
    
    cell.titleLabel.text = @"省级发起公司评测";
    cell.sumbitLabel.attributedText = str;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Examination_SeconViewController *vc = [[Examination_SeconViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
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

@end
