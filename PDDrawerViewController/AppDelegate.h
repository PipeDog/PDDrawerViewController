//
//  AppDelegate.h
//  PDDrawerViewController
//
//  Created by liang on 2018/3/22.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDDrawerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong, readonly) PDDrawerViewController *drawerVC;

@end

