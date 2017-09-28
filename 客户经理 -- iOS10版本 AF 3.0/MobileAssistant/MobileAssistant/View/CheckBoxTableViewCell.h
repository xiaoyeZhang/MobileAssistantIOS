//
//  CheckBoxTableViewCell.h
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/4.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckBoxTableViewCell;
@protocol CheckBoxTableViewCellDelegate <NSObject>

@optional
- (void)checkBoxTableViewCell:(CheckBoxTableViewCell *)cell checkDidChanged:(int)selectedIndex;

@end

@interface CheckBoxTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (assign, nonatomic) int selectedIndex; /*选中按钮索引*/
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<CheckBoxTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSArray *selectArray;

- (void)setSelectDataWithArray:(NSArray *)array;

- (void)setSelectBtnIndex:(int)index;

@end
