//
//  DistributionQueryVC.m
//  xsgj
//
//  Created by xujunwen on 14-7-27.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "DistributionQueryVC.h"

@interface DistributionQueryVC ()

@end

@implementation DistributionQueryVC

- (id)init
{
    self = [super initWithNibName:@"BaseDistributionVC" bundle:nil];
    if (self) {
        self.type = DistrubutionTypeQuery;
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
