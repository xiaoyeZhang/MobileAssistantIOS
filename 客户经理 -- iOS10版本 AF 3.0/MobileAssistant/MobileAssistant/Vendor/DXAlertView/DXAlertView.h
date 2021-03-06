//
//  ILSMLAlertView.h
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 谢凯伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisitTaskDetailViewController.h"
#import "No_visit_sumListView.h"
#import "Product_Visit_DetailViewController.h"

@interface DXAlertView : UIView

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
      TextAlignment:(int)textAlignment
           FontSize:(float) fontsize;

- (id)initWithTitle:(NSString *)title
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle;

- (id)initWithTitle:(NSString *)title
        contentButton:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle;


- (id)initWithTitle:(NSString *)title
       summaryText:(NSString *)content
       qradioButton:(NSString *)qradioTitle
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle;

- (id)initWithTitle:(NSString *)title
    leftTitle:(NSString *)leftTitle
         rightTitle:(NSString *)rigthTitle placeholderTitle:(NSString *)placeholder;

- (id)initWithTitle:(NSString *)title
          user_list:(NSString *)leftTitle
          summaryText:(NSString *)content
         rightTitle:(NSString *)rigthTitle;

- (void)show;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;
@property (nonatomic, copy) dispatch_block_t contentBlock;
@property (nonatomic, copy) dispatch_block_t userBlock;

@property (nonatomic, strong) UITextField *serviceTextfield;//推荐业务
@property (nonatomic, strong) UITextField *operationsTextfield;//挖掘业务
@property (nonatomic, strong) UITextView *alertContentTextView;//拜访任务
@property (nonatomic, strong) UITextField *user_listTextfield;//下级处理人

@property (nonatomic, strong) UIButton *alertButton;
@property (nonatomic, strong) VisitTaskDetailViewController *vsTaskVC;

@property (nonatomic, strong) No_visit_sumListView *no_visitVC;

@property (nonatomic, strong) Product_Visit_DetailViewController *Pro_visitVC;
@end

@interface UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
