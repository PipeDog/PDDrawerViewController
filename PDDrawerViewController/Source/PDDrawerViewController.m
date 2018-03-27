//
//  PDDrawerViewController.m
//  PDSideViewController
//
//  Created by liang on 2018/3/22.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "PDDrawerViewController.h"

#define KEY_WINDOW [[UIApplication sharedApplication] keyWindow]

static CGFloat const kScreenshotImageOriginalLeft = -150.f;
static CGFloat const kDefaultVisibleMenuWidth = 300.f;

@interface PDDrawerViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) CGPoint startTouchPointInMainVC;
@property (nonatomic, assign, getter=isMoving) BOOL moving;
@property (nonatomic, strong) UIView *blackMaskView;
@property (nonatomic, strong) NSHashTable<id<PDDrawerViewControllerDelegate>> *delegates;

@end

@implementation PDDrawerViewController

- (void)dealloc {
    [_mainViewController removeFromParentViewController];
    [_menuViewController removeFromParentViewController];
    
    [_mainViewController.view removeFromSuperview];
    [_menuViewController.view removeFromSuperview];
}

- (instancetype)initWithMainViewController:(UIViewController *)mainViewController
                        menuViewController:(UIViewController *)menuViewController {
    self = [super init];
    if (self) {
        _mainViewController = mainViewController;
        _menuViewController = menuViewController;
        
        _visibleMenuWidth = kDefaultVisibleMenuWidth;
        _canDragMenu = YES;
        [_mainViewController.view addGestureRecognizer:self.pan];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)configUI {
    // Add child controllers.
    [self addChildViewController:self.menuViewController];
    [self addChildViewController:self.mainViewController];

    self.menuViewController.view.frame = self.view.bounds;
    self.mainViewController.view.frame = self.view.bounds;

    [self.view addSubview:self.menuViewController.view];
    [self.view addSubview:self.mainViewController.view];
    
    // Add blackMaskView.
    [self.view insertSubview:self.blackMaskView belowSubview:self.mainViewController.view];
    self.blackMaskView.frame = self.view.bounds;
}

- (void)moveViewWithX:(CGFloat)x {
    x = MIN(x, self.visibleMenuWidth);
    x = MAX(x, 0);
    
    CGRect frame = self.mainViewController.view.frame;
    frame.origin.x = x;
    self.mainViewController.view.frame = frame;
    
    float alpha = (1.f - x / self.visibleMenuWidth) / 2.f;
    
    self.blackMaskView.alpha = alpha;
    
    CGFloat aa = ABS(kScreenshotImageOriginalLeft) / self.visibleMenuWidth;
    CGFloat y = x * aa;
    
    CGRect rect = self.menuViewController.view.frame;
    
    self.menuViewController.view.frame = CGRectMake(kScreenshotImageOriginalLeft + y,
                                                    0,
                                                    CGRectGetWidth(rect),
                                                    CGRectGetHeight(rect));
}

#pragma mark - PDDrawerViewController Methods
- (void)presentMenuViewController {
    [UIView animateWithDuration:0.2f animations:^{
        [self moveViewWithX:self.visibleMenuWidth];
    } completion:^(BOOL finished) {
        [self sendMenuDidAppearNotification];
    }];
}

- (void)dismissMenuViewController {
    [UIView animateWithDuration:0.2f animations:^{
        [self moveViewWithX:0];
    } completion:^(BOOL finished) {
        [self sendMenuDidDisappearNotification];
    }];
}

#pragma mark - Delegates Methods
- (void)bind:(id<PDDrawerViewControllerDelegate>)delegate {
    if (!delegate) return;
    if (![delegate conformsToProtocol:@protocol(PDDrawerViewControllerDelegate)]) return;

    if (![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
    }
}

- (void)unbind:(id<PDDrawerViewControllerDelegate>)delegate {
    if (!delegate) return;

    if ([self.delegates containsObject:delegate]) {
        [self.delegates removeObject:delegate];
    }
}

- (void)sendMenuDidAppearNotification {
    for (id<PDDrawerViewControllerDelegate> delegate in [self.delegates setRepresentation]) {
        if (delegate && [delegate respondsToSelector:@selector(menuDidAppear)]) {
            [delegate menuDidAppear];
        }
    }
}

- (void)sendMenuDidDisappearNotification {
    for (id<PDDrawerViewControllerDelegate> delegate in [self.delegates setRepresentation]) {
        if (delegate && [delegate respondsToSelector:@selector(menuDidDisappear)]) {
            [delegate menuDidDisappear];
        }
    }
}

#pragma mark - Gesture Recognizer Methods
- (void)paningGestureReceive:(UIPanGestureRecognizer *)sender {    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self _panGestureRecognizerBegan:sender];
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        [self _panGestureRecognizerChanged:sender];
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        [self _panGestureRecognizerEnded:sender];
    }
    else if (sender.state == UIGestureRecognizerStateCancelled) {
        [self _panGestureRecognizerCancelled:sender];
    }
}

- (void)_panGestureRecognizerBegan:(UIPanGestureRecognizer *)sender {
    self.moving = YES;
    self.startTouchPointInMainVC = [sender locationInView:self.mainViewController.view];
}

- (void)_panGestureRecognizerChanged:(UIPanGestureRecognizer *)sender {
    CGPoint touchPointInWindow = [sender locationInView:KEY_WINDOW];
    
    if (self.isMoving) {
        [self moveViewWithX:touchPointInWindow.x - self.startTouchPointInMainVC.x];
    }
}

- (void)_panGestureRecognizerEnded:(UIPanGestureRecognizer *)sender {
    CGPoint touchPointInWindow = [sender locationInView:KEY_WINDOW];
    
    if (touchPointInWindow.x - self.startTouchPointInMainVC.x > self.visibleMenuWidth / 2.f) {
        [UIView animateWithDuration:0.2 animations:^{
            [self moveViewWithX:self.visibleMenuWidth];
        } completion:^(BOOL finished) {
            self.moving = NO;
            [self sendMenuDidAppearNotification];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            self.moving = NO;
            [self sendMenuDidDisappearNotification];
        }];
    }
}

- (void)_panGestureRecognizerCancelled:(UIPanGestureRecognizer *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        [self moveViewWithX:0];
    } completion:^(BOOL finished) {
        self.moving = NO;
        [self sendMenuDidDisappearNotification];
    }];
}

#pragma mark - Setter Methods
- (void)setCanDragMenu:(BOOL)canDragMenu {
    _canDragMenu = canDragMenu;
    
    if (_canDragMenu) {
        [self.mainViewController.view addGestureRecognizer:self.pan];
    } else {
        [self.mainViewController.view removeGestureRecognizer:self.pan];
    }
}

- (void)setMainViewController:(UIViewController *)mainViewController {
    if (_mainViewController) {
        [_mainViewController removeFromParentViewController];
        [_mainViewController.view removeFromSuperview];
    }
    _mainViewController = mainViewController;
    
    [self addChildViewController:_mainViewController];
    _mainViewController.view.frame = self.view.bounds;
    [self.view insertSubview:_mainViewController.view aboveSubview:self.blackMaskView];
    
    self.canDragMenu = _canDragMenu; // Add or remove gesture.
}

- (void)setMenuViewController:(UIViewController *)menuViewController {
    if (_menuViewController) {
        [_menuViewController removeFromParentViewController];
        [_menuViewController.view removeFromSuperview];
    }
    _menuViewController = menuViewController;
    
    [self addChildViewController:_menuViewController];
    _menuViewController.view.frame = self.view.bounds;
    [self.view insertSubview:_menuViewController.view belowSubview:self.blackMaskView];
}

#pragma mark - Getter Methods
- (UIPanGestureRecognizer *)pan {
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paningGestureReceive:)];
        _pan.delegate = self;
    }
    return _pan;
}

- (UIView *)blackMaskView {
    if (!_blackMaskView) {
        _blackMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _blackMaskView.backgroundColor = [UIColor blackColor];
    }
    return _blackMaskView;
}

- (NSHashTable<id<PDDrawerViewControllerDelegate>> *)delegates {
    if (!_delegates) {
        _delegates = [NSHashTable weakObjectsHashTable];
    }
    return _delegates;
}

@end
