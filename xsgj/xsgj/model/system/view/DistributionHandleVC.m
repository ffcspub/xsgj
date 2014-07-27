//
//  DistributionHandleVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DistributionHandleVC.h"

@interface DistributionHandleVC ()

@end

@implementation DistributionHandleVC

- (id)init
{
    self = [super initWithNibName:@"BaseDistributionVC" bundle:nil];
    if (self) {
        self.type = DistrubutionTypeHandle;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
