//
//  UserHttpResponse.m
//  xsgj
//
//  Created by ilikeido on 14-7-5.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "SystemHttpResponse.h"
#import "BNMobileMenu.h"
#import "BNProductType.h"
#import "BNProduct.h"
#import "BNUnitBean.h"
#import "BNCustomerInfo.h"
#import "BNAreaInfo.h"
#import "BNCustomerType.h"
#import "BNVisitCondition.h"
#import "BNVisitPlan.h"
#import "BNVistRecord.h"
#import "BNVisitStepRecord.h"
#import "BNAssetType.h"
#import "BNDisplayCase.h"
#import "BNDisplayShape.h"
#import "BNDisplayType.h"
#import "BNSignConfigBean.h"
#import "BNCameraType.h"
#import "ContactBean.h"
#import "DeptInfoBean.h"
#import "BNPartnerInfoBean.h"
#import "BNPartnerType.h"
#import "LK_NSDictionary2Object.h"
#import "OfflineRequestCache.h"
#import "TripInfoBean.h"
#import <LKDBHelper.h>
#import "SaleTaskInfoBean.h"
#import "VisistRecordVO.h"
#import "OrderInfoBean.h"
#import "QueryOrderBackInfoBean.h"
#import "OrderDetailBean.h"
#import "QueryOrderBackDetailInfoBean.h"

@implementation UserLoginHttpResponse


+(void)dbInit{
    LKDBHelper *helper = [LKDBHelper getUsingLKDBHelper];
    [helper createTableWithModelClass:[BNUserInfo class]];
    [helper createTableWithModelClass:[BNAreaInfo class]];
    [helper createTableWithModelClass:[BNAssetType class]];
    [helper createTableWithModelClass:[BNCustomerInfo class]];
    [helper createTableWithModelClass:[BNCustomerType class]];
    [helper createTableWithModelClass:[BNDisplayCase class]];
    [helper createTableWithModelClass:[BNDisplayShape class]];
    [helper createTableWithModelClass:[BNDisplayType class]];
    [helper createTableWithModelClass:[BNMobileMenu class]];
    [helper createTableWithModelClass:[BNProduct class]];
    [helper createTableWithModelClass:[BNProductType class]];
    [helper createTableWithModelClass:[BNUnitBean class]];
    [helper createTableWithModelClass:[BNVisitCondition class]];
    [helper createTableWithModelClass:[BNVisitPlan class]];
    [helper createTableWithModelClass:[BNVisitStepRecord class]];
    [helper createTableWithModelClass:[BNVistRecord class]];
    [helper createTableWithModelClass:[BNSignConfigBean class]];
    [helper createTableWithModelClass:[BNCameraType class]];
    [helper createTableWithModelClass:[DeptInfoBean class]];
    [helper createTableWithModelClass:[ContactBean class]];
    [helper createTableWithModelClass:[BNPartnerInfoBean class]];
    [helper createTableWithModelClass:[BNPartnerType class]];
    [helper createTableWithModelClass:[OfflineRequestCache class]];
    
    [helper createTableWithModelClass:[TripInfoBean class ]]; // 出差查询表
    [helper createTableWithModelClass:[TripInfoBean2 class ]]; // 出差审批表
    [helper createTableWithModelClass:[SaleTaskInfoBean class ]]; // 销售任务
    [helper createTableWithModelClass:[OrderInfoBean class ]]; // 订货查询
    [helper createTableWithModelClass:[OrderDetailBean class ]]; // 订货查询明细
    [helper createTableWithModelClass:[QueryOrderBackInfoBean class ]]; // 退货查询
    [helper createTableWithModelClass:[QueryOrderBackDetailInfoBean class ]]; // 退货查询明细
    [helper createTableWithModelClass:[VisistRecordVO class ]]; // 拜访记录
}

-(void)saveCacheDB{
    [UserLoginHttpResponse dbInit];
    int count = [BNUserInfo rowCountWithWhere:[NSString stringWithFormat:@"USER_ID=%d",_USERINFO.USER_ID]];
    if (count > 0) {
        [BNUserInfo deleteWithWhere:[NSString stringWithFormat:@"USER_ID=%d",_USERINFO.USER_ID]];
    }
    [_USERINFO saveToDB];
}

@end

@implementation UpdateConfigHttpResponse

+(Class)__MOBILE_MENUSClass{
    return [BNMobileMenu class];
}

+(Class)__PRODUCT_TYPESClass{
    return [BNProductType class];
}

+(Class)__PRODUCT_UNITSClass{
    return [BNUnitBean class];
}

+(Class)__PRODUCTSClass{
    return [BNProduct class];
}

+(Class)__CUSTOMER_TYPESClass{
    return [BNCustomerType class];
}

+(Class)__AREASClass{
    return [BNAreaInfo class];
}

+(Class)__CUSTOMERSClass{
    return [BNCustomerInfo class];
}

+(Class)__VISIT_CONDITIONSClass{
    return [BNVisitCondition class];
}

+(Class)__VISIT_PLANSClass{
    return [BNVisitPlan class];
}

+(Class)__VISIT_RECORDSClass{
    return [BNVistRecord class];
}

+(Class)__VISIT_STEP_RECORDSClass{
    return [BNVisitStepRecord class];
}

+(Class)__DISPLAY_TYPESClass{
    return [BNDisplayType class];
}

+(Class)__ASSET_TYPESClass{
    return [BNAssetType class];
}

+(Class)__DISPLAY_CASESClass{
    return [BNDisplayCase class];
}

+(Class)__DISPLAY_SHAPESClass{
    return [BNDisplayShape class];
}

+(Class)__SIGN_CONFIGSClass{
    return [BNSignConfigBean class];
}

+(Class)__CAMERA_TYPESClass{
    return [BNCameraType class];
}

+(Class)__DEPT_INFOClass
{
    return [DeptInfoBean class];
}

+(Class)__CONTACT_Class
{
    return [ContactBean class];
}

+(Class)__PARTNER_INFOSClass
{
    return [BNPartnerInfoBean class];
}

+(Class)__PARTNER_TYPESClass
{
    return [BNPartnerType class];
}


-(void)saveDefaultMobileMenus{
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"menu_config" ofType:@"json"];
	NSData* data = [NSData dataWithContentsOfFile:jsonPath];
	NSArray *array =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary *dict in array) {
        BNMobileMenu *menu = [[BNMobileMenu alloc]init];
        menu.MENU_ID = [[dict objectForKey:@"id"] integerValue];
        menu.ICON = [dict objectForKey:@"icon"];
//        if([[dict objectForKey:@"leftShow"] isEqual:@"true"]){
//            menu.STATE = 1;
//        }
        NSString *CONTROLLER_NAME = [dict objectForKey:@"childClass"];
        if (CONTROLLER_NAME ) {
            menu.CONTROLLER_NAME = CONTROLLER_NAME;
        }
        menu.MENU_NAME = [dict objectForKey:@"name"];
        menu.PARENT_ID = [[dict objectForKey:@"parentId"]integerValue];
        [menu saveToDB];
    }
    
    int count = [BNMobileMenu rowCountWithWhere:nil];
    NSLog(@"mobileMenu num:%d",count);
}

-(void)saveCacheDB{
    if (_MENU_UPDATE_STATE == 1) {
        [BNMobileMenu deleteWithWhere:nil];
        [self saveDefaultMobileMenus];
        for (BNMobileMenu *bean in _MOBILE_MENUS) {
            [bean save];
        }
    }
    if (_PRODUCT_TYPE_UPDATE_STATE == 1) {
        [BNProductType deleteWithWhere:nil];
        for (BNProductType *bean in _PRODUCT_TYPES) {
            [bean saveToDB];
        }
    }
    if (_PRODUCT_UNIT_UPDATE_STATE == 1) {
        [BNUnitBean deleteWithWhere:nil];
        for (BNUnitBean *bean in _PRODUCT_UNITS) {
            [bean saveToDB];
        }
    }
    if (_PRODUCT_UPDATE_STATE == 1) {
        [BNProduct deleteWithWhere:nil];
        for (BNProduct *bean in _PRODUCTS) {
            [bean saveToDB];
        }
    }
    if (_CUSTOMER_TYPE_UPDATE_STATE == 1) {
        [BNCustomerType deleteWithWhere:nil];
        for (BNCustomerType *bean in _CUSTOMER_TYPES) {
            [bean saveToDB];
        }
    }
    if (_AREA_UPDATE_STATE == 1) {
        [BNAreaInfo deleteWithWhere:nil];
        for (BNAreaInfo *bean in _AREAS) {
            [bean saveToDB];
        }
    }
    if (_CUSTOMER_UPDATE_STATE == 1) {
        [BNCustomerInfo deleteWithWhere:nil];
        for (BNCustomerInfo *bean in _CUSTOMERS) {
            [bean saveToDB];
        }
    }
    if (_VISIT_CONDITION_UPDATE_STATE == 1) {
        [BNVisitCondition deleteWithWhere:nil];
        for (BNVisitCondition *bean in _VISIT_CONDITIONS) {
            [bean saveToDB];
        }
    }
    if (_VISIT_PLAN_UPDATE_STATE == 1) {
        [BNVisitPlan deleteWithWhere:nil];
        for (BNVisitPlan *bean in _VISIT_PLANS) {
            [bean saveToDB];
        }
    }
    if (_DISPLAY_TYPE_UPDATE_STATE == 1) {
        [BNDisplayType deleteWithWhere:nil];
        for (BNDisplayType *bean in _DISPLAY_TYPES) {
            [bean saveToDB];
        }
    }
    if (_ASSET_TYPE_UPDATE_STATE == 1) {
        [BNAssetType deleteWithWhere:nil];
        for (BNAssetType *bean in _ASSET_TYPES) {
            [bean saveToDB];
        }
    }
    if (_DISPLAY_CASE_UPDATE_STATE == 1) {
        [BNDisplayCase deleteWithWhere:nil];
        for (BNDisplayCase *bean in _DISPLAY_CASES) {
            [bean saveToDB];
        }
    }
    if (_DISPLAY_SHAPE_UPDATE_STATE == 1) {
        [BNDisplayShape deleteWithWhere:nil];
        for (BNDisplayShape *bean in _DISPLAY_SHAPES) {
            [bean saveToDB];
        }
    }
    if (_SIGN_CONFIG_UPDATE_STATE == 1) {
        [BNSignConfigBean deleteWithWhere:nil];
        for (BNSignConfigBean *bean in _SIGN_CONFIGS) {
            [bean saveToDB];
        }
    }
    if (_CAMERA_TYPE_UPDATE_STATE == 1) {
        [BNCameraType deleteWithWhere:nil];
        for (BNCameraType *bean in _CAMERA_TYPES) {
            [bean saveToDB];
        }
    }
    if (_PARTNER_UPDATE_STATE == 1) {
        [BNPartnerInfoBean deleteWithWhere:nil];
        for (BNPartnerInfoBean *bean in _PARTNER_INFOS) {
            [bean saveToDB];
        }
    }
    if (_PARTNER_TYPE_UPDATE_STATE == 1) {
        [BNPartnerType deleteWithWhere:nil];
        for (BNPartnerType *bean in _PARTNER_TYPES) {
            [bean saveToDB];
        }
    }
    
    [BNVistRecord deleteWithWhere:@"SYNC_STATE=1"];
    for (BNVistRecord *bean in _VISIT_RECORDS) {
        [bean save];
    }
    [BNVisitStepRecord deleteWithWhere:nil];
    for (BNVisitStepRecord *bean in _VISIT_STEP_RECORDS) {
        [bean saveToDB];
    }
    
}

@end

@implementation GetServerUpdateTimeHttpResponse


@end

@implementation LocateCommitHttpResponse

@end

@implementation UploadPhotoHttpResponse

@end

@implementation InsertMobileStateHttpResponse

@end
