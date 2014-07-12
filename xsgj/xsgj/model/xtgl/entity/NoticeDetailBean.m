//
//  NoticeDetailBean.m
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "NoticeDetailBean.h"
#import "NoticeAttmentBean.h"

@implementation NoticeDetailBean

+(Class)__attmentlistClass{
    return [NoticeAttmentBean class];
}

@end
