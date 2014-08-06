//
//  ServerConfig.h
//  ffcsdemo
//
//  Created by hesh on 13-9-12.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef fxtx_FXRequestUrl_h
#define fxtx_FXRequestUrl_h




// 根路径
#define BASE_SERVERLURL @"http://202.101.116.77:8082/xsgj_ws/"

// 图片上传路径
#define UPLOAD_PIC_URL @"http://202.101.116.77:8082/xsgj_up/"

// 图片根路径
#define IMAGE_PREFIX_URL @"http://202.101.116.77:8082/xsgj_up/photo.shtml?corpId=%d&fileId=%@"


// gmm
#define URL_LOGIN @"loginCheck.shtml" // 登录
#define URL_UPDATE_CONFIG @"updateConfig.shtml" // 配置更新
#define URL_UPDATE_URL @"corp/versionInfo.shtml"// 版本更新
#define URL_ACTIVITY_COMMIT_URL @"activity/activityCommit.shtml" // 活动上报
#define URL_PRODUCT_TYPE_URL @"product/productType.shtml"// 产品类型
#define URL_PRODUCT_URL @"product/productInfo.shtml"// 获取
#define URL_ORDER_COMMIT @"order/orderCommit.shtml"// 订单上报
#define URL_GET_PRODUCT_UNIT @"product/getProductInfo.shtml"// 获取产品单位
#define URL_QUERY_ORDERS @"order/orderQuery.shtml"// 订货查询
#define URL_ORDER_DETAIL @"order/orderDetail.shtml"// 订货详情
#define URL_ORDER_BACK_COMMIT @"orderBack/insertOrderBack.shtml"// 退货上报
#define URL_STOCK_COMMIT @"stock/stockCommit.shtml"// 库存上报
#define URL_QUERY_ORDER_BACK @"orderBack/queryOrderBack.shtml"// 退货查询
#define URL_ORDER_BACK_DETAIL @"orderBack/queryOrderBackDetail.shtml" // 退货详情
#define URL_ANNOUNCEMENT @"notice/noticeQuery.shtml" // 企业公告
#define URL_ANNOUNCEMENT_TYPE @"notice/noticeTypes.shtml" // 公告类型
#define URL_ANNOUNCEMENT_DETAIL @"notice/noticeDetail.shtml"// 公告详情
#define URL_CONTACT_DEPT @"userdept/getAllDeptInfo.shtml"
#define URL_ADDRESS_BOOK @"user/queryContacts.shtml"
// zcq
#define URL_ApplyLeave @"leave/applyLeave.shtml"// 请假申请
#define URL_queryLeave @"leave/queryLeaveDetail.shtml"// 请假查询
#define URL_queryLeaveDetail @"leave/queryLeaveDetail.shtml"// 请假详情
#define URL_ApprovalLeave @"leave/approvalLeave.shtml"// 请假审批
#define URL_leave_type @"leave/leave_type.shtml"// 请假类型
#define URL_applyTrip @"trip/applyTrip.shtml" // 出差申请
#define URL_approveTrip @"trip/approveTrip.shtml" // 出差审批
#define URL_queryTrip @"trip/queryTrip.shtml"// 出差查询
#define URL_detailTrip @"trip/detailTrip.shtml" // 出差详情
#define URL_approveCount @"leave/queryApproveCount.shtml" //审批数量
#define URL_insertWorkInfo @"workReport/insertWorkInfo.shtml" // 工作上报
#define URL_workReport @"workReport/workReport.shtml"//工作汇报
#define URL_work_type @"workReport/work_type.shtml"// 工作上报类型
#define URL_addAdvice @"advice/addAdvice.shtml"// 意见上报
#define URL_queryAdvice @"advice/queryAdvice.shtml"// 查询意见上报
#define URL_queryDetailAdvice @"advice/queryDetailAdvice.shtml"// 查询意见上报详细
#define URL_tempVisit @"visit/tempVisit.shtml"//客户信息采集
#define URL_allTypeinfo @"customerinfo/allTypeinfo.shtml"// 客户类型
#define URL_addCustomerCommit @"customerinfo/addCustomerCommit.shtml"// 新增客户上报
#define URL_queryCustomer @"customerinfo/customerQuery.shtml"// 客户查询
#define URL_customerDetail @"customerinfo/customerDetail.shtml"// 客户查询
#define URL_querySaleTask @"saletask/querySaleTask.shtml"// 销售任务(拜访目标)
#define URL_queryVisitRecord @"visit/queryVisitRecord.shtml"// 拜访记录
#define URL_updatePwd @"user/updatePwd.shtml"// 修改密码
#define URL_forgetPwd @"user/forgetPwd.shtml"//忘记密码
#define URL_addApplyCorp @"corp/addApplyCorp.shtml"//企业申请
#define URL_insertCompete @"compete/insertCompete.shtml"// 竞品上报
#define URL_storeCameraCommit @"store/storeCameraCommit.shtml"// 店招拍照
#define URL_toDisplayCamera @"display/toDisplayCamera.shtml"// 获取陈列类型和资产类别接口
#define URL_displayCameraCommit @"display/displayCameraCommit.shtml"// 陈列拍照上报接口
#define URL_displayCase @"displayVivid/displayCase.shtml"// 陈列生动化类别
#define URL_insertDisplayVivid @"displayVivid/insertDisplayVivid.shtml"// 陈列生动化上报接口
#define URL_displayShape @"displayShape/displayShape.shtml"// 陈列费用形式
#define URL_insertDisplayCost @"displayShape/insertDisplayCost.shtml"// 陈列费用上报接口
#define URL_queryApproveCount @"leave/queryApproveCount.shtml"// 请假审批接口
// dongbk
#define URL_signUp @"sign/sign.shtml" // 签到签退
#define URL_queryAttendance @"sign/queryAttendance.shtml"// 考勤查询
#define URL_detailAttendance @"sign/detailAttendance.shtml"// 考勤查询(包含详情）
#define URL_planVisit @"visit/planVisit.shtml"// 计划拜访-获取路线
#define URL_updateVisitPlans @"visit/updateVisitPlans.shtml"//更新拜访规划
#define URL_customerInfoGatherr @"visit/tempVisit.shtml"// 客户信息采集
#define URL_queryVisitStates @"visit/queryVisitStates.shtml"// 获取拜访状态
#define URL_recordVisit @"visit/recordVisit.shtml"// 离开登记
#define URL_queryPlanVisitConfigs @"visit/queryPlanVisitConfigs.shtml"//查询拜访规划接口
#define URL_getCustomerTypes @"visit/getCustomerTypes.shtml"// 获取客户类型
#define URL_getDeptInfos @"visit/getDeptInfos.shtml"// 获取部门树
#define URL_getTempCustomerInfos @"visit/getTempCustomerInfos.shtml"// 获取客户列表
#define URL_insertUserCamera @"usercamera/insertUserCamera.shtml"//日常拍照上报
#define URL_uploadPhoto @"uploadPhoto.shtml" //照片上传
#define URL_locateCommit @"locate/locateCommit.shtml"//实时定位上传
#define URL_getServerUpdateTime @"getServerUpdateTime.shtml" //获取服务器更新时间
#define URL_insertMobileState @"mobilestate/insertMobileState.shtml"//手机状态上报
#define URL_getWorkRange @"sign/getWorkRange.shtml"//读取手机状态上报工作范围
#define URL_getTimeInterval @"mobilestate/getTimeInterval.shtml"
#define URL_getMobbileDisInfo @"mobileDis/getMobileDisInfo.shtml"//配送查询
#define URL_updateMobileDisState @"mobileDis/updateState.shtml"//配送处理上报

#endif
