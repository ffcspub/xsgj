//
//  KHGLHttpRequest.h
//  xsgj
//
//  Created by mac on 14-7-10.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LK_HttpRequest.h"


@interface AllTypeHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *SESSION_ID;//会话ID
@property(nonatomic,assign) int CORP_ID;//企业ID
@property(nonatomic,assign) int DEPT_ID;//部门ID
@property(nonatomic,strong) NSString *USER_AUTH;//数据权限
@property(nonatomic,assign) int USER_ID;//用户ID

@end

@interface AddCustomerCommitHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int         CORP_ID;//	企业ID
@property(nonatomic,assign) int         DEPT_ID;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int         USER_ID;//	用户ID
@property(nonatomic,assign) int         CLASS_ID;//	客户类型ID
@property(nonatomic,strong) NSString *	CUST_NAME	;//	客户名称
@property(nonatomic,strong) NSString *	CUST_CODE	;//	客户编码
@property(nonatomic,strong) NSString *	LINKMAN	;//	联系人
@property(nonatomic,strong) NSString *	TEL	;//	联系电话
@property(nonatomic,strong) NSString *	ADDRESS	;//	联系地址
@property(nonatomic,strong) NSString *	REMARK	;//	备注
@property(nonatomic,strong) NSString *	PHOTO	;//	照片
@property(nonatomic,strong) NSNumber *	LNG	;//	经度
@property(nonatomic,strong) NSNumber *	LAT	;//	纬度
@property(nonatomic,strong) NSString *	POSITION	;//	地理位置
@property(nonatomic,strong) NSString *	COMMITTIME	;//	创建时间

@end

@interface CustomerQueryHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int         CORP_ID	;//	企业ID
@property(nonatomic,assign) int         DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int         USER_ID	;//	用户ID
@property(nonatomic,strong) NSNumber *  TYPE_ID	;//	客户类型标识
@property(nonatomic,strong) NSString *	CUST_NAME	;//	客户名称

@end

@interface CustomerDetailHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *	SESSION_ID;//	会话ID
@property(nonatomic,assign) int         CORP_ID;//	企业ID
@property(nonatomic,assign) int         DEPT_ID;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH;//	数据权限
@property(nonatomic,assign) int         USER_ID;//	用户ID
@property(nonatomic,strong) NSNumber *	CUST_ID;//	客户标识
@property(nonatomic,strong) NSNumber *	TYPE_ID;//	客户类型标识
@property(nonatomic,strong) NSString *	CUST_NAME;//	客户名称

@end

@interface RecordVisitHttpRequest : LK_HttpBaseRequest

@property(nonatomic,assign) int         USER_ID;//	用户标识
@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话标识
@property(nonatomic,assign) int         CORP_ID;//	企业标识
@property(nonatomic,assign) int         DEPT_ID;//	部门标识
@property(nonatomic,strong) NSString *	USER_AUTH	;//	用户数据权限
@property(nonatomic,assign) int         CONF_ID;//	线路配置id
@property(nonatomic,assign) int         CUST_ID;//	客户标识
@property(nonatomic,strong) NSString *  VISIT_NO;//	拜访编号(随机生成的uuid)
@property(nonatomic,strong) NSString *	VISIT_TYPE	;//	拜访类型(0表示临时拜访 1表示计划拜访)
@property(nonatomic,strong) NSString *	VISIT_DATE	;//	计划拜访日期
@property(nonatomic,strong) NSString *	BEGIN_TIME	;//	开始时间
@property(nonatomic,strong) NSNumber *	BEGIN_LAT	;//	开始纬度
@property(nonatomic,strong) NSNumber *	BEGIN_LNG	;//	开始经度
@property(nonatomic,strong) NSString *	BEGIN_POS	;//	开始位置
@property(nonatomic,strong) NSNumber *	BEGIN_LAT2	;//	纠偏纬度
@property(nonatomic,strong) NSNumber *	BEGIN_LNG2	;//	纠偏经度
@property(nonatomic,strong) NSString *	BEGIN_POS2	;//	纠偏位置
@property(nonatomic,strong) NSString *	END_TIME	;//	结束拜访时间
@property(nonatomic,strong) NSNumber *	END_LAT	;//	结束纬度
@property(nonatomic,strong) NSNumber *	END_LNG	;//	结束经度
@property(nonatomic,strong) NSString *	END_POS	;//	结束位置
@property(nonatomic,strong) NSNumber *	END_LAT2	;//	纠偏结束纬度
@property(nonatomic,strong) NSNumber *	END_LNG2	;//	纠偏结束经度
@property(nonatomic,strong) NSString *	END_POS2	;//	纠偏结束位置

@end


@interface QueryVistitRecordHttpRequest : LK_HttpBaseRequest

@property(nonatomic,assign) int USER_ID	;//	用户标识
@property(nonatomic,strong) NSString * 	SESSION_ID	;//	会话标识
@property(nonatomic,assign) int         CORP_ID	;//	企业标识
@property(nonatomic,assign) int         DEPT_ID 	;//	部门标识
@property(nonatomic,strong) NSString * 	CUST_NAME	;//	客户姓名
@property(nonatomic,strong) NSString * 	BEGIN_TIME	;//	起始时间
@property(nonatomic,strong) NSString * 	END_TIME	;//	结束时间
@property(nonatomic,strong) NSString * 	USER_AUTH	;//	用户数据权限
@property(nonatomic,strong) NSNumber * 	QUERY_DEPTID	;//	要查询的部门id
@property(nonatomic,strong) NSNumber * 	QUERY_USER_ID	;//	要查询的用户id

@end

@interface QueryPlanVisitConfigsHttpRequest : LK_HttpBaseRequest

@property(nonatomic,assign) int         USER_ID	;//	用户标识
@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话标识
@property(nonatomic,assign) int         CORP_ID;//	企业标识
@property(nonatomic,assign) int         DEPT_ID;//	部门标识
@property(nonatomic,strong) NSString *	USER_AUTH	;//	用户数据权限
@property(nonatomic,strong) NSString *	PLAN_DATE	;//	起始时期

@end

@interface UpdateVisitPlansHttpRequest : LK_HttpBaseRequest

@property(nonatomic,assign) int         USER_ID;//	用户标识
@property(nonatomic,strong) NSString *	SESSION_ID;//	会话标识
@property(nonatomic,assign) int         CORP_ID;//	企业标识
@property(nonatomic,assign) int         DEPT_ID;//	部门标识
@property(nonatomic,strong) NSString *	USER_AUTH;//	用户数据权限
@property(nonatomic,strong) NSString *	PLAN_DATE;//	计划拜访日期
@property(nonatomic,strong) NSString *	WEEKDAY;//	星期几
@property(nonatomic,strong) NSMutableArray  *	VISIT_PLANS;//	拜访计划

@end

@interface ActivityCommitHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int	CORP_ID	;//	企业ID
@property(nonatomic,assign) int	DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int	USER_ID	;//	用户ID
@property(nonatomic,assign) int	CUST_ID	;//	客户ID
@property(nonatomic,assign) int	PROD_ID	;//	产品ID
@property(nonatomic,strong) NSString *	REMARK	;//	备注
@property(nonatomic,strong) NSString *	COMMITTIME	;//	上报时间
@property(nonatomic,strong) NSString *	PHOTO1	;//	照片ID
@property(nonatomic,strong) NSString *	PHOTO2	;//	照片ID
@property(nonatomic,strong) NSString *	PHOTO3	;//	照片ID
@property(nonatomic,strong) NSString *	PHOTO4	;//	照片ID
@property(nonatomic,strong) NSString *	PHOTO5	;//	照片ID
@property(nonatomic,strong) NSString *	VISIT_NO	;//	拜访编号
@property(nonatomic,strong) NSString *	OPER_MENU	;//	操作菜单

@end

@interface InsertCompeteHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int	CORP_ID	;//	企业ID
@property(nonatomic,assign) int	DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int	USER_ID	;//	用户ID
@property(nonatomic,assign) int	CUST_ID	;//	客户ID
@property(nonatomic,strong) NSString *	BRAND	;//	竞品品牌
@property(nonatomic,strong) NSString *	NAME	;//	竞品名称
@property(nonatomic,strong) NSString *	PRICE	;//	竞品价格
@property(nonatomic,strong) NSString *	SPEC	;//	竞品规格
@property(nonatomic,strong) NSString *	PROMOTION	;//	促销方式
@property(nonatomic,strong) NSString *	ACTIVITY	;//	消费者活动
@property(nonatomic,strong) NSString *	REMARK	;//	备注
@property(nonatomic,strong) NSString *	COMMITTIME	;//	上报时间
@property(nonatomic,strong) NSString *	PHOTO1	;//	照片
@property(nonatomic,strong) NSString *	PHOTO2	;//	照片
@property(nonatomic,strong) NSString *	PHOTO3	;//	照片
@property(nonatomic,strong) NSString *	PHOTO4	;//	照片
@property(nonatomic,strong) NSString *	PHOTO5	;//	照片


@end

@interface OrderCommitHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int	CORP_ID	;//	企业ID
@property(nonatomic,assign) int	DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int	USER_ID	;//	用户ID
@property(nonatomic,assign) int	CUST_ID	;//	客户标识
@property(nonatomic,strong) NSString *	COMMITTIME	;//	上报时间
@property(nonatomic,strong) NSString *	VISIT_NO	;//	拜访编号
@property(nonatomic,strong) NSString *	OPER_MENU	;//	菜单id
@property(nonatomic,strong) NSMutableArray *	DATA	;//	订单明细

@end


@interface OrderQueryHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int 	CORP_ID	;//	企业ID
@property(nonatomic,assign) int 	DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int 	USER_ID	;//	用户ID
@property(nonatomic,strong) NSNumber *	QUERY_DEPTID	;//	查询部门标识
@property(nonatomic,strong) NSString *	USER_NAME	;//	登录名
@property(nonatomic,strong) NSString *	REALNAME	;//	姓名
@property(nonatomic,strong) NSString *	MOBILENO	;//	手机号码
@property(nonatomic,strong) NSString *	BEGIN_TIME	;//	上报开始时间
@property(nonatomic,strong) NSString *	END_TIME	;//	上报结束时间
@property(nonatomic,strong) NSString *	CUST_NAME	;//	客户名称

@end

@interface OrderDetailHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int 	CORP_ID	;//	企业ID
@property(nonatomic,assign) int 	DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int 	USER_ID	;//	用户ID
@property(nonatomic,assign) int     ORDER_ID;//订单标识

@end

@interface InsertOrderBackHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int 	CORP_ID	;//	企业ID
@property(nonatomic,assign) int 	DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int 	USER_ID	;//	用户ID
@property(nonatomic,assign) int 	CUST_ID	;//	客户标识
@property(nonatomic,strong) NSString *	COMMITTIME	;//	上报时间
@property(nonatomic,strong) NSString *	VISIT_NO	;//	拜访编号
@property(nonatomic,strong) NSString *	OPER_MENU	;//	操作菜单
@property(nonatomic,strong) NSMutableArray *	DATA	;//	明细

@end


@interface QueryOrderBackHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int 	CORP_ID	;//	企业ID
@property(nonatomic,assign) int 	DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int 	USER_ID	;//	用户ID
@property(nonatomic,strong) NSNumber *	QUERY_DEPTID	;//	查询部门标识
@property(nonatomic,strong) NSString *	CUST_NAME	;//	客户名称
@property(nonatomic,strong) NSString *	BEGIN_TIME	;//	上报开始时间
@property(nonatomic,strong) NSString *	END_TIME	;//	上报结束时间

@end

@interface QueryOrderBackDetailHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int 	CORP_ID	;//	企业ID
@property(nonatomic,assign) int 	DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int 	USER_ID	;//	用户ID
@property(nonatomic,strong) NSNumber *	QUERY_DEPTID	;//	查询部门标识
@property(nonatomic,strong) NSNumber *  ORDER_ID;//退货ID

@end

@interface StockCommitHttpRequest : LK_HttpBasePageRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID	String
@property(nonatomic,assign) int 	CORP_ID	;//	企业ID
@property(nonatomic,assign) int 	DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int 	USER_ID	;//	用户ID
@property(nonatomic,assign) int 	CUST_ID	;//	客户标识	Long
@property(nonatomic,strong) NSString *	COMMITTIME	;//	上报时间	Date
@property(nonatomic,strong) NSString *	VISIT_NO	;//	拜访编号	String
@property(nonatomic,strong) NSString *	OPER_MENU	;//	操作菜单	String
@property(nonatomic,strong) NSMutableArray *	DATA	;//	库存上报集

@end

@interface StoreCameraCommitHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int 	CORP_ID	;//	企业ID
@property(nonatomic,assign) int 	DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int 	USER_ID	;//	用户ID
@property(nonatomic,assign) int 	CUST_ID	;//	客户标识	Long
@property(nonatomic,strong) NSString *	PHOTO1	;//	照片ID1
@property(nonatomic,strong) NSString *	PHOTO2	;//	照片ID2
@property(nonatomic,strong) NSString *	PHOTO3	;//	照片ID3
@property(nonatomic,strong) NSString *	PHOTO4	;//	照片ID4
@property(nonatomic,strong) NSString *	PHOTO5	;//	照片ID5
@property(nonatomic,strong) NSString *	COMMITTIME	;//	手机上报时间
@property(nonatomic,strong) NSString *	VISIT_NO	;//	拜访编号
@property(nonatomic,strong) NSString *	OPER_MENU	;//	操作菜单

@end


@interface DisplayCameraCommitHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int 	CORP_ID	;//	企业ID
@property(nonatomic,assign) int 	DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int 	USER_ID	;//	用户ID
@property(nonatomic,assign) int 	CUST_ID	;//	客户标识	Long
@property(nonatomic,assign) int     TYPE_ID	;//	陈列类型标识
@property(nonatomic,assign) int     ASSETS_ID	;//	资产类别标识
@property(nonatomic,assign) int     ASSETS_NUM	;//	资产数量
@property(nonatomic,strong) NSString *	PHOTO1	;//	照片ID1
@property(nonatomic,strong) NSString *	PHOTO2	;//	照片ID2
@property(nonatomic,strong) NSString *	PHOTO3	;//	照片ID3
@property(nonatomic,strong) NSString *	PHOTO4	;//	照片ID4
@property(nonatomic,strong) NSString *	PHOTO5	;//	照片ID1
@property(nonatomic,strong) NSString *	COMMITTIME	;//	上报时间
@property(nonatomic,strong) NSString *	VISIT_NO	;//	拜访编号
@property(nonatomic,strong) NSString *	OPER_MENU	;//	操作菜单

@end

@interface InsertDisplayVividHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int	CORP_ID	;//	企业ID
@property(nonatomic,assign) int	DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int	USER_ID	;//	用户ID
@property(nonatomic,assign) int	CUST_ID	;//	客户标识
@property(nonatomic,assign) int	CASE_ID	;//	陈列情况标识
@property(nonatomic,strong) NSString *	REMARK	;//	备注
@property(nonatomic,strong) NSString *	PHOTO1	;//	照片ID1
@property(nonatomic,strong) NSString *	PHOTO2	;//	照片ID2
@property(nonatomic,strong) NSString *	PHOTO3	;//	照片ID3
@property(nonatomic,strong) NSString *	PHOTO4	;//	照片ID4
@property(nonatomic,strong) NSString *	PHOTO5	;//	照片ID1
@property(nonatomic,strong) NSString *	COMMITTIME	;//	上报时间
@property(nonatomic,strong) NSString *	VISIT_NO	;//	拜访编号
@property(nonatomic,strong) NSString *	OPER_MENU	;//	操作菜单

@end

@interface InsertDisplayCostHttpRequest : LK_HttpBaseRequest
@property(nonatomic,strong) NSString * SESSION_ID;//	会话ID
@property(nonatomic,assign) int	CORP_ID	;//	企业ID
@property(nonatomic,assign) int	DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int	USER_ID	;//	用户ID
@property(nonatomic,assign) int	CUST_ID	;//	客户标识
@property(nonatomic,strong) NSString *	SHAPE_ID	;//	形式id
@property(nonatomic,strong) NSString *	COST	;//	费用
@property(nonatomic,strong) NSString *	COMMITTIME	;//	上报时间
@property(nonatomic,strong) NSString *	VISIT_NO	;//	拜访编号
@property(nonatomic,strong) NSString *	OPER_MENU	;//	操作菜单

@end

@interface UploadPhotoHttpRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString * 	SESSION_ID	;//	会话ID
@property(nonatomic,assign) int	CORP_ID	;//	企业ID
@property(nonatomic,assign) int	DEPT_ID	;//	部门ID
@property(nonatomic,strong) NSString *	USER_AUTH	;//	数据权限
@property(nonatomic,assign) int	USER_ID	;//	用户ID
@property(nonatomic,assign) int	CUST_ID	;//	客户标识
@property(nonatomic,strong) NSString * 	FILE_NAME	;//	拍照名称
@property(nonatomic,strong) NSString * 	DATA	;//	拍照数据

@end
