//
//  ViewController.m
//  PDDrawerViewController
//
//  Created by liang on 2018/3/22.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "PDDrawerViewController.h"

@interface ViewController () <PDDrawerViewControllerDelegate>

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftItem:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

static BOOL show = NO;

- (void)didClickLeftItem:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!show) {
        [appDelegate.drawerVC presentMenuViewController];
    } else {
        [appDelegate.drawerVC dismissMenuViewController];
    }
    show = !show;
}

#pragma mark - PDDrawerViewControllerDelegate
- (void)menuDidAppear {
    show = YES;
}

- (void)menuDidDisappear {
    show = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
