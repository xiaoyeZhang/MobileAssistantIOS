//
//  UIAlertView+Blocks.m
//  Shibui
//
//  Created by Jiva DeVoe on 12/28/10.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//  Modified by Robert Saunders on 20/01/12
//

#import "UIAlertView+Blocks.h"
#import <objc/runtime.h>

static NSString *LEFT_ACTION_ASS_KEY = @"com.51buy.cancelbuttonaction";
static NSString *RIGHT_ACTION_ASS_KEY = @"com.51buy.otherbuttonaction";

@implementation UIAlertView (Blocks)


-(id)initWithTitle:(NSString *)     title 
           message:(NSString *)     message
   leftButtonTitle:(NSString *)     leftButtonTitle
  leftButtonAction:(void (^)(void)) leftButtonAction
  rightButtonTitle:(NSString*)      rightButtonTitle
 rightButtonAction:(void (^)(void)) rightButtonAction
{
  if((self = [self initWithTitle:title 
                         message:message 
                        delegate:self
               cancelButtonTitle:leftButtonTitle
               otherButtonTitles:rightButtonTitle, nil]))
  {
    // We might get nil for one or both block inputs.  To 
    
    
    // Since this is a catogory, we cant add properties in the usual way.
    // Instead we bind the delegate block to the pointer to self.
    // We use copy to invoke block_copy() to ensure the block is copied off the stack to the heap
    // so that it is still in scope when the delegate callback is invoked.
    if (leftButtonAction) 
    {
      objc_setAssociatedObject(self, (__bridge const void *)(LEFT_ACTION_ASS_KEY), leftButtonAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    if (rightButtonAction) 
    {
      objc_setAssociatedObject(self, (__bridge const void *)(RIGHT_ACTION_ASS_KEY), rightButtonAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    if (!leftButtonAction && !rightButtonAction)
    {
        self.delegate = nil;
    }
  }
  return self;
}


// This is a convenience wrapper for the constructor above
+ (void) displayAlertWithTitle:(NSString *)title 
                       message:(NSString *)message
               leftButtonTitle:(NSString *)leftButtonTitle
              leftButtonAction:(void (^)(void))leftButtonAction
              rightButtonTitle:(NSString*)rightButtonTitle
             rightButtonAction:(void (^)(void))rightButtonAction
{
  UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title 
                                                      message:message
                                              leftButtonTitle:leftButtonTitle
                                             leftButtonAction:leftButtonAction
                                             rightButtonTitle:rightButtonTitle
                                            rightButtonAction:rightButtonAction];
  [alertView show];
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  // Decalare the block variable
  void (^action)(void) = nil;
  
  // Get the block using the correct key 
  // depending on the index of the buttom that was tapped
  if (buttonIndex == 0) 
  {
    action  = objc_getAssociatedObject(self, (__bridge const void *)(LEFT_ACTION_ASS_KEY));
  } 
  else if (buttonIndex == 1)
  {
    action  = objc_getAssociatedObject(self, (__bridge const void *)(RIGHT_ACTION_ASS_KEY));
  }
  
  // Invoke the block if we have it.
  if (action) action();
  
  // Unbind both blocks from ourself so they are released
  // We assign nil to the objects wich will release them automatically
  objc_setAssociatedObject(self, (__bridge const void *)(LEFT_ACTION_ASS_KEY), nil, OBJC_ASSOCIATION_COPY);
  objc_setAssociatedObject(self, (__bridge const void *)(RIGHT_ACTION_ASS_KEY), nil, OBJC_ASSOCIATION_COPY);

    
    ///获取关联的对象，通过关键字。
    CompleteBlock block = objc_getAssociatedObject(self, &key);
    if (block)
    {
        ///block传值
        block(buttonIndex);
    }
    objc_removeAssociatedObjects(self);
}






static char key;

// 用Block的方式回调，这时候会默认用self作为Delegate
- (void)showAlertViewWithCompleteBlock:(CompleteBlock)block
{
    if (block)
    {
        ////移除所有关联
        objc_removeAssociatedObjects(self);
        /**
         1 创建关联（源对象，关键字，关联的对象和一个关联策略。)
         2 关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字。
         3 关联策略表明了相关的对象是通过赋值，保留引用还是复制的方式进行关联的；关联是原子的还是非原子的。这里的关联策略和声明属性时的很类似。
         */
        objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_COPY);
        ////设置delegate
        self.delegate = self;
    }
    ////show
    [self show];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    /*
//     ///获取关联的对象，通过关键字。
//     CompleteBlock block = objc_getAssociatedObject(self, &key);
//     if (block)
//     {
//     ///block传值
//     block(buttonIndex);
//     }*/
//}
//alertView 与HUD 冲突，alertView 消失时会把HUD 也消失，所以放在alertView 消失后调用block
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
//{
//    ///获取关联的对象，通过关键字。
//    CompleteBlock block = objc_getAssociatedObject(self, &key);
//    if (block)
//    {
//        ///block传值
//        block(buttonIndex);
//    }
//}





@end
