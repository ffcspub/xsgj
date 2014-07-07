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

#import <LKDBHelper.h>

@implementation UserLoginHttpResponse


+(void)dbInit{
    LKDBHelper *helper = [LKDBHelper getUsingLKDBHelper];
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
    [helper createTableWithModelClass:[BNUserInfo class]];
    [helper createTableWithModelClass:[BNVisitCondition class]];
    [helper createTableWithModelClass:[BNVisitPlan class]];
    [helper createTableWithModelClass:[BNVisitStepRecord class]];
    [helper createTableWithModelClass:[BNVistRecord class]];
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

-(void)saveCacheDB{
    if (_MENU_UPDATE_STATE == 1) {
        [BNMobileMenu deleteWithWhere:nil];
        for (BNMobileMenu *bean in _MOBILE_MENUS) {
            [bean saveToDB];
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
    if (_DISPLAY_SHPAE_UPDATE_STATE == 1) {
        [BNDisplayShape deleteWithWhere:nil];
        for (BNDisplayShape *bean in _DISPLAY_SHAPES) {
            [bean saveToDB];
        }
    }
    
    
}


@end
