//
//  Marco.h
//  MobileAssistant
//
//  Created by Yi.Xia on 15/10/6.
//  Copyright (c) 2015年 avatek. All rights reserved.
//

#ifndef MobileAssistant_Marco_h
#define MobileAssistant_Marco_h

#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)

#define BUSINESS_LIST_REFRESH_NOTIFY @"BusinessListRefreshNotify" //业务列表刷新通知

#define SELECT_BTN_REFRESH_NOTIFY @"SelectBtnNotify" //业务列表刷新通知

#define SET_ACCOUTID_NOTIFY @"SetAccountIdNotify" //获取账号编号通知

// 角色
#define ROLE_TWO 2 //二级经理
#define ROLE_THREE 1 //三级经理
#define ROLE_CUSTOMER 0 //客户经理
#define ROLE_SPECIAL 3 //综合支撑部(特号)
#define ROLE_VISIT 4    //综合支撑部(预约拜访)
#define ROLE_TERMINAL 5 //综合支撑部(终端办理)
#define ROLE_RETREAT 6 //综合支撑部(终端退库)
#define ROLE_REPAIR 7 //售后维修单
#define ROLE_BOOK 8 //缴费台账登记
#define ROLE_CARD 9 //办卡
#define ROLE_BILL 10 //开具发票
#define ROLE_CARD_1 11 //办卡(特号)
#define ROLE_LIBRARY_1 12 ///** 串号已发送到客户经理（终端出库） */
#define ROLE_LIBRARY_2 13 ///** 是否完成营销活动受理（终端出库） */
#define ROLE_LIBRARY_3 14 ///** 完成出库（终端出库） */
#define ROLE_COMMON 25 //通用营销人员
#define ROLE_PRODUCT 26 //产品经理
#define ROLE_SOCOALCHANNEL 30 //社会渠道

// 审批 状态
/** 已终止 */
#define PROCESS_STATE_terminated  -2
/** 驳回 */
#define PROCESS_STATE_reject  -1
/** 客户经理已提交 */
#define PROCESS_STATE_manager_submit  0
/** 三级经理审批通过 */
#define PROCESS_STATE_three_manager_through  1
/** 二级经理审批通过 */
#define PROCESS_STATE_two_manager_through  2
/** 营销支撑组审核通过 */
#define PROCESS_STATE_marketing_through  3
/** 综合部审核通过 */
#define PROCESS_STATE_comprehensive_through  4
/** 已填写实际到货情况(终端办理) */
#define PROCESS_STATE_actual_arrival  5
/** 客户经理已确认(终端办理) */
#define PROCESS_STATE_manager_confirm  6
/** 已发货(终端办理) */  //支撑人员确认
#define PROCESS_STATE_delivery  7
/** 已收货(终端办理) */
#define PROCESS_STATE_delivered  8
/** 已退库(终端退库) */
#define PROCESS_STATE_retired_library  9
/** 已处理(售后维修单) */
#define PROCESS_STATE_handled  10
/** 已回款(缴费台账登记) */
#define PROCESS_STATE_payment  11
/** 已确认(缴费台账登记) */
#define PROCESS_STATE_confirm  12
/** 已办卡(办卡) */
#define PROCESS_STATE_already_card  13
/** 已送卡(办卡) */
#define PROCESS_STATE_send_card  14
/*已办卡(特号办理)*/
#define PROCESS_STATE_card_done 15
/** 已填写回款情况(开具发票) */
#define PROCESS_STATE_filled_out_confirm  18
/** 已开发票(开具发票) */
#define PROCESS_STATE_Invoice  16
/** 已送发票(开具发票) */
#define PROCESS_STATE_send_Invoice  17
/** 串号已发送至客户经理 */
#define PROCESS_STATE_library_number 19
/** 已提交客户信息至受理人员*/
#define PROCESS_STATE_library_acceptanceing 20
/** 营销活动已受理*/
#define PROCESS_STATE_library_acceptanceed 21
/** 已出库*/
#define PROCESS_STATE_library_end 22
/** 已领货*/
#define PROCESS_STATE_library_picking 23
/** 已归档*/
#define PROCESS_STATE_library_File 24
/** 客响中心已审核*/
#define PROCESS_GRC_THROUGH 25
/** 客户经理已回访*/
#define RETURN_VISIT 26
/** 财务部审核归档*/
#define RETURN_REFUND 27
/** 客户经理已处理*/
#define PROCESS_STATE_manager_VISIT 28
/** 财务人员已回复*/
#define PROCESS_STATE_responded_VISIT 29
/** 已挂单（特号办理）*/
#define PROCESS_STATE_Have_Guadan 30
/** 行业总监审核（终端订货）*/
#define PROCESS_STATE_Industry_director 40
//** 营销支撑组经理审核通过 */
#define PROCESS_STATE_marketing_manager_through 41
/** 营销支撑组已归档*/
#define PROCESS_STATE_REFUND 42

//动态配置
#define FORM_TYPE_ZERO  0   //文本框
#define FORM_TYPE_ONE  1    //单选
#define FORM_TYPE_TWO  2    //下拉菜单
#define FORM_TYPE_THREE  3  //弹出列表选择
#define FORM_TYPE_FOUR  4   //选择日期
#define FORM_TYPE_FIVE  5   //图片上传（拍照）
#define FORM_TYPE_SIX  6    //弹出自定义对话框


#endif
