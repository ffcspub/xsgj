//
//  OrderGoodsDetailVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-23.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "OrderGoodsDetailVC.h"
#import "OrderDetailBean.h"
#import "KHGLAPI.h"
#import "MBProgressHUD+Add.h"

@interface OrderGoodsDetailVC ()

@property (nonatomic, strong) OrderDetailBean *deailBean;

@property (weak, nonatomic) IBOutlet UIView *vRoot;
@property (weak, nonatomic) IBOutlet UIScrollView *svRoot;

@property (weak, nonatomic) IBOutlet UILabel *lblProductName; // 产品名称
@property (weak, nonatomic) IBOutlet UILabel *lblStand; // 规格
@property (weak, nonatomic) IBOutlet UILabel *lblPrice; // 单价
@property (weak, nonatomic) IBOutlet UILabel *lblOrderNumber; // 数量
@property (weak, nonatomic) IBOutlet UILabel *lblUnit; // 单位
@property (weak, nonatomic) IBOutlet UILabel *lblPresentName; // 赠品名称
@property (weak, nonatomic) IBOutlet UILabel *lblPresentNumber; // 赠品数量
@property (weak, nonatomic) IBOutlet UILabel *lblPresentUnit; // 单位
@property (weak, nonatomic) IBOutlet UILabel *lblPresentMoney; // 赠送金额
@property (weak, nonatomic) IBOutlet UILabel *lblProductMoney; // 产品金额

@end

@implementation OrderGoodsDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xefeff4);
    self.title = @"订货详情";
    self.svRoot.contentSize = CGSizeMake(80 * 9, 80.f);
    
    // 隐藏
    self.vRoot.alpha = 0.0f;
    
    [self loadOrderGoodsDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadOrderGoodsDetail
{
    OrderDetailHttpRequest *request = [[OrderDetailHttpRequest alloc] init];
    request.ORDER_ID = self.orderInfoBean.ORDER_ID;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [KHGLAPI queryOrderDetailByRequest:request success:^(OrderDetailHttpResponse *response) {
        
        self.deailBean = [response.DATA firstObject];
        [self refreshUI];
        
        [hub removeFromSuperview];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [hub removeFromSuperview];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}

/**
 *  刷新界面
 */
- (void)refreshUI
{
    self.lblProductName.text = self.deailBean.PROD_NAME;
    self.lblStand.text = self.deailBean.SPEC;
    self.lblPrice.text = [NSString stringWithFormat:@"%.2f", [self.deailBean.ITEM_PRICE floatValue]];
    self.lblOrderNumber.text = [NSString stringWithFormat:@"%d", [self.deailBean.ITEM_NUM intValue]];
    self.lblUnit.text = self.deailBean.UNITNAME;
    self.lblPresentName.text = self.deailBean.GIFT_NAME;
    self.lblPresentNumber.text = [NSString stringWithFormat:@"%d", [self.deailBean.GIFT_NUM intValue]];
    self.lblPresentUnit.text = self.deailBean.GIFT_UNIT;
    self.lblPresentMoney.text = [NSString stringWithFormat:@"%.2f", [self.deailBean.GIFT_PRICE floatValue]];
    self.lblProductMoney.text = [NSString stringWithFormat:@"%.2f", [self.deailBean.TOTAL_PRICE floatValue]];
    
    [UIView animateWithDuration:0.2f animations:^{
        self.vRoot.alpha = 0.f;
        self.vRoot.alpha = 1.f;
    }];
}

@end
