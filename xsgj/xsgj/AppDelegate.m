//
//  AppDelegate.m
//  xsgj
//
//  Created by ilikeido on 14-7-4.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import "AppDelegate.h"
#import <AKTabBarController.h>
#import <MAMapKit/MAMapKit.h>
#import "UIColor+External.h"
#import "KHGLViewController.h"
#import "OtherViewController.h"
#import "XTGLViewController.h"
#import "XZGLViewController.h"
#import "LoginViewController.h"

#import "SystemAPI.h"

#import "XZGLAPI.h"
#import "XZGLHttpRequest.h"
#import "XZGLHttpResponse.h"
#import "SignDetailBean.h"

#import "TopMenuViewController.h"
#import <LKDBHelper.h>
#import "BNMobileMenu.h"
#import <MBProgressHUD.h>

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize tabBarController = _tabBarController;

-(void)test{
    
//    [SystemAPI loginByCorpcode:@"zlbzb" username:@"linwei" password:@"123456" success:^(BNUserInfo *userinfo) {
//        [SystemAPI updateConfigSuccess:^{
//            
//        } fail:^(BOOL notReachable, NSString *desciption) {
//            
//        }];
//    } fail:^(BOOL notReachable, NSString *desciption) {
//        
//    }];
    
//    ApplyLeaveHttpRequest *request = [[ApplyLeaveHttpRequest alloc]init];
//    DetailAttendanceHttpRequest *request = [[DetailAttendanceHttpRequest alloc]init];
//    [XZGLAPI detailAttendanceByRequest:request success:^(DetailAttendanceHttpResponse *response) {
//        for (SignDetailBean *infoBean in response.DATA) {
//            NSLog(@"%@,%@",infoBean.DEPT_NAME,infoBean.USER_NAME );
//        }
//    } fail:^(BOOL notReachable, NSString *desciption) {
//        
//    }];
    

//    QueryAttendanceHttpRequest *request = [[QueryAttendanceHttpRequest alloc]init];
//    [XZGLAPI queryAttendanceByRequest:request success:^(QueryAttendanceHttpReponse *response) {
//        
//        for (SigninfoBean *infoBean in response.DATA) {
//            NSLog(@"%@,%@",infoBean.DEPT_NAME,infoBean.USER_NAME );
//        }
//        
//    } fail:^(BOOL notReachable, NSString *desciption) {
//        
//    }];
    
//    SignUpHttpRequest *request = [[SignUpHttpRequest alloc]init];
//    request.LNG = 323232;
//    request.LAT = 234353;
//    request.POSITION = @"测试地址";
//    [XZGLAPI signupByRequest:request success:^(SignUpHttpReponse *response) {
//        NSLog(@"%@,%@",response.MESSAGE.MESSAGECODE,response.MESSAGE.MESSAGECONTENT);
//    } fail:^(BOOL notReachable, NSString *desciption) {
//        
//    }];
//
    
}

-(void)initStyle{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (IOS7_OR_LATER) {
        
//        [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"MyNavigationBar1"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBarTintColor:HEX_RGB(0x409be4)];
        [[UINavigationBar appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont boldSystemFontOfSize:20],UITextAttributeFont,@0.0,UITextAttributeTextShadowOffset, nil]];
    }
#endif
}

-(void)addThirthPart{
    [self test];
    [MAMapServices sharedServices].apiKey =@"9dfdf1c3299afea34b2c97c45010afaa";
}


-(void)initTabBarController{
    _tabBarController = [[AKTabBarController alloc]initWithTabBarHeight:50];
    [_tabBarController setTabTitleIsHidden:NO];
    [_tabBarController setTabEdgeColor:[UIColor clearColor]];
    [_tabBarController setIconGlossyIsHidden:YES];
    [_tabBarController setIconShadowOffset:CGSizeZero];
    [_tabBarController setTabColors:@[[UIColor clearColor],[UIColor clearColor]]];
    [_tabBarController setSelectedTabColors:@[[UIColor clearColor],[UIColor clearColor]]];
    [_tabBarController setIconColors:@[HEX_RGB(0xa4a4a6),HEX_RGB(0xa4a4a6)]];
    [_tabBarController setSelectedIconColors:@[HEX_RGB(0x409be4),HEX_RGB(0x409be4)]];
    [_tabBarController setBackgroundImageName:@"tabbar-green"];
    [_tabBarController setSelectedBackgroundImageName:@"tabbar-black"];
    [_tabBarController setTextColor:HEX_RGB(0xa4a4a6)];
    [_tabBarController setSelectedTextColor:HEX_RGB(0x409be4)];
    [_tabBarController setTabStrokeColor:[UIColor clearColor]];
    [_tabBarController setTabInnerStrokeColor:[UIColor clearColor]];
    [_tabBarController setTopEdgeColor:[UIColor clearColor]];
    [_tabBarController setMinimumHeightToDisplayTitle:50];
    
}

-(void)addController:(AKTabBarController *)tabBarController{
    
    NSArray *array = [BNMobileMenu searchWithWhere:[NSString stringWithFormat:@"PARENT_ID=%D and STATE=1",-1] orderBy:nil offset:0 count:10];
    NSMutableArray *navs = [NSMutableArray array];
    for (BNMobileMenu *menu in array) {
        TopMenuViewController *vlc = [[TopMenuViewController alloc]init];
        vlc.menu = menu;
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vlc];
        [navs addObject:navController];
    }
    [_tabBarController setViewControllers:navs];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self initStyle];
    // Override point for customization after application launch.
    [self addThirthPart];
    [self showLoginViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"xsgj" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"xsgj.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)showTabView;{
    [_tabBarController showTabBarAnimated:NO];
}

-(void)selectedTabView:(NSInteger)index{
    [_tabBarController setSelectedIndex:index];
    
}

-(void)hideTabView;{
    [_tabBarController hideTabBarAnimated:NO];
}

-(void)showLoginViewController{
    _tabBarController = nil;
    if (!_loginViewController) {
        _loginViewController = [[LoginViewController alloc]init];
    }
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:_loginViewController];
    self.window.rootViewController = navController;
}

-(void)showTabViewController;{
    [self initTabBarController];
    [self addController:_tabBarController];
    self.window.rootViewController = _tabBarController;
}

@end
