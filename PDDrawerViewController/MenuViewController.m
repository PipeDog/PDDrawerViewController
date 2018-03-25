//
//  MenuViewController.m
//  PDDrawerViewController
//
//  Created by liang on 2018/3/22.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "PDDrawerViewController.h"

#define kBackgroundColor [UIColor colorWithRed:13.f / 255.f green:184.f / 255.f blue:246.f / 255.f alpha:1]

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <NSArray *>*dataArray;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView Delegate && DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const reUse = @"reUse";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reUse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUse];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.imageView.image = self.dataArray[indexPath.row][0];
    cell.textLabel.text = self.dataArray[indexPath.row][1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.drawerVC dismissMenuViewController];
}

#pragma mark - Getter Methods
- (NSArray<NSArray *> *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@[[UIImage imageNamed:@"sidebar_business"], @"我的商城"],
                       @[[UIImage imageNamed:@"sidebar_purse"], @"QQ钱包"],
                       @[[UIImage imageNamed:@"sidebar_decoration"], @"个性装扮"],
                       @[[UIImage imageNamed:@"sidebar_favorit"], @"我的收藏"],
                       @[[UIImage imageNamed:@"sidebar_album"], @"我的相册"],
                       @[[UIImage imageNamed:@"sidebar_file"], @"我的文件"]];
    }
    return _dataArray;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   CGRectGetWidth(self.view.bounds),
                                                                   280)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.image = [UIImage imageNamed:@"sidebar_bg"];
        _imageView.clipsToBounds = YES;
        
        UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
        avatarImageView.frame = CGRectMake(25.f, 64.f, 60.f, 60.f);
        avatarImageView.clipsToBounds = YES;
        avatarImageView.layer.cornerRadius = CGRectGetWidth(avatarImageView.frame) / 2.f;
        avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        avatarImageView.layer.borderWidth = 2.f;
        [_imageView addSubview:avatarImageView];
        
        UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) + 30, CGRectGetMinY(avatarImageView.frame) + 10, 100, 20)];
        nickLabel.textColor = [UIColor darkGrayColor];
        nickLabel.font = [UIFont boldSystemFontOfSize:20];
        nickLabel.text = @"__liang__";
        [_imageView addSubview:nickLabel];
    }
    return _imageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.tableHeaderView = self.imageView;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

@end
