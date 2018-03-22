//
//  PDDrawerViewController.h
//  PDSideViewController
//
//  Created by liang on 2018/3/22.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PDDrawerViewControllerDelegate <NSObject>

@optional
- (void)menuDidAppear;
- (void)menuDidDisappear;

@end

@interface PDDrawerViewController : UIViewController <NSObject>

- (instancetype)initWithMainViewController:(UIViewController *)mainViewController
                        menuViewController:(UIViewController *)menuViewController;

@property (nonatomic, assign) CGFloat visibleMenuWidth; ///< Default is 300.f.
@property (nonatomic, assign) BOOL canDragMenu; ///< Default is YES.

@property (nonatomic, strong, readwrite) UIViewController *mainViewController;
@property (nonatomic, strong, readwrite) UIViewController *menuViewController;

- (void)presentMenuViewController; ///< Show menu page.
- (void)dismissMenuViewController; ///< Hide menu page.

- (void)bind:(id<PDDrawerViewControllerDelegate>)delegate;
- (void)unbind:(id<PDDrawerViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
