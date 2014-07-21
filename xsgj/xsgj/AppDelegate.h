//
//  AppDelegate.h
//  xsgj
//
//  Created by ilikeido on 14-7-4.
//  Copyright (c) 2014年 ilikeido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@class AKTabBarController;
@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) AKTabBarController *tabBarController;

@property (strong, nonatomic) LoginViewController *loginViewController;

@property (strong, nonatomic) BMKMapManager* mapManager;



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)showTabView;

-(void)hideTabView;

-(void)selectedTabView:(NSInteger)index;

-(void)showLoginViewController;

-(void)showTabViewController;

@end
