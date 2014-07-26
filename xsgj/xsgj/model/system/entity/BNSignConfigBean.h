//
//  BNSignConfigBean.h
//  xsgj
//
//  Created by ilikeido on 14-7-19.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNSignConfigBean : NSObject

@property (nonatomic,strong)      NSString*	CONF_ID	;//	配置id
@property (nonatomic,strong)      NSString*	SIGN_TIMES	;//	考勤次序
@property (nonatomic,strong)      NSString*	SIGN_NAME	;//	考勤主题
@property (nonatomic,assign)      int	BEGIN_TIME	;//	签到时间(小时加分钟 HHmm)
@property (nonatomic,assign)      int	END_TIME	;//	签退时间(小时加分钟 HHmm)
@property (nonatomic,strong)      NSString*	SHIFT_EARLY	;//	签到可提早分钟
@property (nonatomic,strong)      NSString*	SHIFT_DELAY	;//	签退可退后分钟
@property (nonatomic,assign)      int WEEK_DAY	;//	星期(星期日为1，依次类推)

@end
