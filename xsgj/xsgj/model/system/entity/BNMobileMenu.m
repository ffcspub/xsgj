//
//  BNMobileMenu.m
//  配置更新
//
//  Created by apple on 14-6-18.
//  Copyright (c) 2014年 newdoone. All rights reserved.
//

#import "BNMobileMenu.h"
#import <LKDBHelper.h>

@implementation BNMobileMenu

//表名
+(NSString *)getTableName
{
    return [NSString stringWithFormat:@"t_%d_BNMobileMenu",[ShareValue shareInstance].userInfo.USER_ID];
}

-(void)save{
    BNMobileMenu *menu = [BNMobileMenu searchSingleWithWhere:[NSString stringWithFormat:@"MENU_ID=%d",_MENU_CODE] orderBy:nil];
    if (menu) {
        [BNMobileMenu deleteToDB:menu];
        menu.MENU_CODE = _MENU_CODE;
        menu.MENU_NAME = self.MENU_NAME;
        menu.STATE = self.STATE;
        menu.REQUIRED = self.REQUIRED;
        menu.ORDER_NO = self.ORDER_NO;
        [menu saveToDB];
    }
//    else{
//        menu = self;
//    }
    
}

@end
