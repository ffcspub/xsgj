//
//  NoticeDetailBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-12.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeDetailBean : NSObject

@property(nonatomic,assign) int	NOTICE_ID	;//	公告标识
@property(nonatomic,strong) NSString *	BEGIN_TIME	;//	发布时间
@property(nonatomic,strong) NSString *	END_TIME	;//	终止时间
@property(nonatomic,strong) NSString *	TOPIC	;//	公告主题
@property(nonatomic,assign) int         POSTED_BY;//	发布人
@property(nonatomic,strong) NSString *	CONTENT	;//	公告内容
@property(nonatomic,strong) NSMutableArray *	attmentlist	;//	附件集

@end
