//
//  DTContainerViewController.m
//  Pods
//
//  Created by 金秋成 on 2016/12/6.
//
//

#import "DTContainerViewController.h"
#import "DTTransitionContext.h"

@interface DTContainerViewController ()<DTContainerViewControllerProtocol>
//上下文
@property (nonatomic,strong)DTTransitionContext * context;
//容器视图
@property (nonatomic,strong)UIView * containerView;
//子视图控制器数
@property (nonatomic,assign)NSUInteger childViewControllerCount;
//当前控制器
@property (nonatomic,strong)UIViewController * currentViewController;
//是否转场中
@property (nonatomic,assign,getter=isTransitioning)BOOL transitioning;

@property (nonatomic,assign,getter=isInteractive)BOOL interactive;

@property (nonatomic,assign)CGPoint interactiveStartPoint;

@property (nonatomic,assign)CGFloat tempPercent;

@end

@implementation DTContainerViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}


-(void)commonInit{
    _currentIndex = 0;
    self.selectIndex = 0;
    self.interactive = NO;
    self.childViewControllerCount = 0;
    self.transitioning = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerView = [[UIView alloc]initWithFrame:CGRectZero];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.translatesAutoresizingMaskIntoConstraints  =NO;
    self.containerView.clipsToBounds = YES;
    [self.view addSubview:self.containerView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:self.containerViewEdge.top]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.containerViewEdge.bottom]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:self.containerViewEdge.left]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-self.containerViewEdge.right]];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPan:)];
    [self.containerView addGestureRecognizer:pan];
    
}



-(void)reloadChildViewControllers{
    self.childViewControllerCount = [self.dataSource numberOfChildViewController];
    if (self.childViewControllerCount > 0) {
        //如果刷新之前的当前索引值大于或等于刷新后子控制器的数量时默认选择最后一个索引对应的视图控制器
        if (_childViewControllerCount <= self.currentIndex) {
            _currentIndex = _childViewControllerCount-1;
        }
        
        UIViewController * newCurrentIndexVC = [self.dataSource viewControllerAtIndex:self.currentIndex];
        //如果刷新后的视图与刷新前的视图控制器不同，这将刷新前的视图控制器移除，并添加新的视图控制器
        if (newCurrentIndexVC != self.currentViewController) {
            //如果和当前的控制器不是同一个  移除之前的控制器
            [self.currentViewController willMoveToParentViewController:nil];
            [self.currentViewController.view removeFromSuperview];
            [self.currentViewController removeFromParentViewController];
            //将新的控制器加入
            [self addChildViewController:newCurrentIndexVC];
            newCurrentIndexVC.view.frame = self.containerView.bounds;
            [self.containerView addSubview:newCurrentIndexVC.view];
            [newCurrentIndexVC didMoveToParentViewController:self];
            self.currentViewController = newCurrentIndexVC;
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSelectIndex:(NSUInteger)selectIndex{
    if (self.childViewControllerCount <= selectIndex || selectIndex<0) return;
    if (self.isTransitioning) return;
    if (self.currentIndex == selectIndex) return;
    _selectIndex = selectIndex;
    if ([self isViewLoaded]) {
        self.context = [[DTTransitionContext alloc]initWithContainerViewController:self containerView:self.containerView];
        UIViewController * toVC   = [self.dataSource viewControllerAtIndex:selectIndex];
        UIViewController * fromVC = [self.dataSource viewControllerAtIndex:self.currentIndex];
        
        
        if (toVC == fromVC) {//如果是同一个对象
            
        }
       
        self.context.fromViewController = fromVC;
        self.context.toViewController   = toVC;
        self.context.fromIndex = self.currentIndex;
        self.context.toIndex   = selectIndex;
        if (self.isInteractive) {
            [self.context startInteractiveTransition];
        }
        else{
            [self.context startAnimationTrasition];
        }
    }
}



#pragma -mark pan
-(void)didPan:(UIPanGestureRecognizer *)pan{
    
    CGPoint panPoint = [pan translationInView:self.containerView];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.interactive = YES;
            self.interactiveStartPoint = panPoint;
            self.tempPercent = 0;
            CGPoint velocity= [pan velocityInView:self.containerView];
            if (velocity.x > 0) {
                self.selectIndex = self.currentIndex - 1;
            }
            else{
                self.selectIndex = self.currentIndex + 1;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (self.selectIndex > self.currentIndex) {
                if (self.interactiveStartPoint.x > panPoint.x) {
                    self.tempPercent = (self.interactiveStartPoint.x - panPoint.x)/self.containerView.frame.size.width;
                    [self.context.trasitionDelegate.interactiveController updateInteractiveTransition:self.tempPercent];
                }
                
                
                
                
            }
            else if(self.selectIndex < self.currentIndex){
                if (self.interactiveStartPoint.x < panPoint.x) {
                    self.tempPercent = (panPoint.x - self.interactiveStartPoint.x)/self.containerView.frame.size.width;
                    [self.context.trasitionDelegate.interactiveController updateInteractiveTransition:self.tempPercent];
                }
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        {
            
            if (self.tempPercent > 0.3) {
                
                [self.context.trasitionDelegate.interactiveController finishInteractiveTransition];
            }
            else{
                [self.context.trasitionDelegate.interactiveController cancelInteractiveTransition];
            }
            self.interactive = NO;
        }
            break;
        default:
            break;
    }
}


-(void)contextDidStartTransition{
    self.transitioning = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStartTrasitionFromIndex:toIndex:)]) {
        [self.delegate didStartTrasitionFromIndex:_currentIndex toIndex:_selectIndex];
    }
}


-(void)contextTransitionProgress:(CGFloat)progress{
    if (self.delegate && [self.delegate respondsToSelector:@selector(transitionFromIndex:toIndex:withProgress:)]) {
        [self.delegate transitionFromIndex:_currentIndex toIndex:_selectIndex withProgress:progress];
    }
}


-(void)contextDidFinishTransition:(BOOL)isCanceled{
    self.transitioning = NO;
    if (!isCanceled) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didEndTrasitionFromIndex:toIndex:)]) {
            [self.delegate didEndTrasitionFromIndex:_currentIndex toIndex:_selectIndex];
        }
        _currentIndex = _selectIndex;
    }
}



@end
