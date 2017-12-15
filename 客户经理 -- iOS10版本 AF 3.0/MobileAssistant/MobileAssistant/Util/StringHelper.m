//
//  StringHelper.m
//  MobileAssistant
//
//  Created by 许孝平 on 14-4-26.
//  Copyright (c) 2014年 XiaoPing. All rights reserved.
//

#import "StringHelper.h"

@implementation StringHelper

+ (NSString *)getStateString:(NSString *)state
{
    int intState = [state intValue];
    switch (intState) {
        case -3:
            return @"任务已过期";
        case -2:
            return @"重新指派,等待接受";
        case -1:
            return @"已撤销";
        case 0:
            return @"指派中,等待接受";
        case 1:
            return @"已拒绝,审批中";
        case 2:
            return @"变更审批中";
        case 3:
            return @"正在执行中";
        case 4:
            return @"拜访进行中";
        case 5:
            return @"现场拜访完成";
        case 6:
            return @"纪要添加完成";
        case 7:
            return @"拜访任务完成";
        default:
            break;
    }
    
    return @"未知状态";
}


+ (NSString *)getBusinessStateString:(NSString *)state
{
    int intState = [state intValue];
    
    NSString *msg = nil;
    
    switch (intState) {
        case -2:
            msg = @"已终止";
            break;
        case -1:
            msg = @"已驳回";
            break;
        case 0:
            msg = @"客户经理已提交";
            break;
        case 1:
            msg = @"三级经理审核通过";
            break;
        case 2:
            msg = @"二级经理审核通过";
            break;
        case 3:
            msg = @"营销支撑组审核通过";
            break;
        case 4:
            msg = @"综合部审核通过";
            break;
        case 5:
            msg = @"已填写实际到货情况";//(终端办理)
            break;
        case 6:
            msg = @"客户经理已确认";//(终端办理)
            break;
        case 7:
            msg = @"支撑人员确认"; //@"已发货";//(终端办理)
            break;
        case 8:
            msg = @"已收货";//(终端办理)
            break;
        case 9:
            msg = @"已退库";//(终端退库)
            break;
        case 10:
            msg = @"已完成";//售后维修单
            break;
        case 11:
            msg = @"已回款";//缴费台账记录
            break;
        case 12:
            msg = @"已确认";//缴费台账记录
            break;
        case 13:
            msg = @"已办卡";//办卡
            break;
        case 14:
            msg = @"已送卡";//办卡
            break;
        case 15:
            msg = @"已办卡";//特号办理
            break;
        case 16:
            msg = @"已开具发票";//开具发票
            break;
        case 17:
            msg = @"已送发票"; //开具发票
            break;
        case 18:
            msg = @"已填写回款情况";//开具发票
            break;
        case 19:
            msg = @"串号已发送至客户经理";
            break;
        case 20:
            msg = @"已提交客户信息至受理人员";
            break;
        case 21:
            msg = @"营销活动已受理";
            break;
        case 22:
            msg = @"已出库";
            break;
        case 23:
            msg = @"已领货";
            break;
        case 24:
            msg = @"已归档";
            break;
        case 25:
            msg = @"客响中心已审核";
            break;
        case 26:
            msg = @"客户经理已回访";
            break;
        case 27:
            msg = @"财务部审核归档";
            break;
        case 28:
            msg = @"客户经理已处理";
            break;
        case 29:
            msg = @"财务人员已回复";
            break;
        case 30:
            msg = @"已挂单";
            break;
        case 40:
            msg = @"行业总监审核通过";
            break;
        case 41:
            msg = @"营销支撑组经理审核通过";
            break;
        case 42:
            msg = @"营销支撑组经理选择人员归档";
            break;
        case 43:
            msg = @"营销支撑组已归档";
            break;
        case 99:
            msg = @"";
            break;
        default:
            msg = @"未知状态";
            break;
    }
    
    return msg;
}

+ (NSString *)getUserType:(int)type
{
//#define ROLE_TWO 2 //二级经理
//#define ROLE_THREE 1 //三级经理
//#define ROLE_CUSTOMER 0 //客户经理
//#define ROLE_SPECIAL 3 //综合支撑部(特号)
//#define ROLE_VISIT 4    //综合支撑部(预约拜访)
//#define ROLE_TERMINAL 5 //综合支撑部(终端办理)
//#define ROLE_RETREAT 6 //综合支撑部(终端退库)
//#define ROLE_REPAIR 7 //售后维修单
//#define ROLE_BOOK 8 //缴费台账登记
//#define ROLE_CARD 9 //办卡
//#define ROLE_BILL 10 //开具发票
//#define ROLE_CARD_1 11 //办卡(特号)
    
    NSString *typeStr = nil;
    
    switch (type) {
        case ROLE_CUSTOMER:
            typeStr = @"客户经理";
            break;
        case ROLE_THREE:
            typeStr = @"三级经理";
            break;
        case ROLE_TWO:
            typeStr = @"二级经理";
            break;
        case ROLE_SPECIAL:
            typeStr = @"特号人员";
            break;
        case ROLE_VISIT:
            typeStr = @"预约拜访人员";
            break;
        case ROLE_TERMINAL:
            typeStr = @"终端办理人员";
            break;
        case ROLE_RETREAT:
            typeStr = @"终端退库人员";
            break;
        case ROLE_REPAIR:
            typeStr = @"售后维修人员";
            break;
        case ROLE_BOOK:
            typeStr = @"缴费台账登记人员";
            break;
        case ROLE_CARD:
            typeStr = @"办卡人员(办卡)";
            break;
        case ROLE_BILL:
            typeStr = @"开具发票人员";
            break;
        case ROLE_CARD_1:
            typeStr = @"办卡人员(特号)";
            break;
        case ROLE_COMMON:
            typeStr = @"支撑人员";
            break;
        case ROLE_LIBRARY_1:
            typeStr = @"支撑人员";
            break;
        case ROLE_LIBRARY_2:
            typeStr = @"支撑人员";
            break;
        case ROLE_LIBRARY_3:
            typeStr = @"支撑人员";
            break;
            
        default:
            typeStr = @"未知类型人员";
            break;
    }
    
    return typeStr;
}

@end
