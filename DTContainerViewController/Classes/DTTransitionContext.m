//
//  DTTransitionContext.m
//  Pods
//
//  Created by 金秋成 on 2016/12/6.
//
//

#import "DTTransitionContext.h"

@interface DTTransitionContext()
@property (nonatomic,weak)UIViewController<DTContainerViewControllerProtocol> * privateContainerViewController;
@property (nonatomic,weak)UIView * privateContainerView;
@property (nonatomic,strong)id<UIViewControllerAnimatedTransitioning> animator;
@property (nonatomic,assign)BOOL isCancelled;
@property (nonatomic,assign)BOOL interactive;
@property (nonatomic,assign)CFTimeInterval transitionDuration;
@property (nonatomic,assign)float          transitionPercent;

@property (nonatomic,assign)BOOL           trasitionSameObject;

@end


@implementation DTTransitionContext

-(instancetype)initWithContainerViewController:(UIViewController *)containerViewController
                                 containerView:(UIView *)containerView{
    self = [super init];
    if (self) {
        self.privateContainerViewController = containerViewController;
        self.privateContainerView = containerView;
        _trasitionDelegate = [[DTTransitionDelegate alloc]init];
    }
    return self;
}

-(void)startAnimationTrasition{
    
    self.animator = [self.trasitionDelegate dt_animationControllerForContainerViewController:self.privateContainerViewController
                                                                   transitFromViewController:self.fromViewController
                                                                                     atIndex:self.fromIndex
                                                                            toViewController:self.toViewController
                                                                                     atIndex:self.toIndex];
    [self activateNonInteractiveTransition];
    [self.privateContainerViewController contextDidStartTransition];
}


#pragma -mark 交互式处理


-(void)startInteractiveTransition{
    
    self.animator = [self.trasitionDelegate dt_animationControllerForContainerViewController:self.privateContainerViewController transitFromViewController:self.fromViewController atIndex:self.fromIndex toViewController:self.toViewController atIndex:self.toIndex];
    
    self.transitionDuration = [self.animator transitionDuration:self];
    
    id<UIViewControllerInteractiveTransitioning> interactionController = [self.trasitionDelegate dt_interactionControllerForAnimationController:self.animator containerViewController:self.privateContainerViewController];
    
    
    [interactionController startInteractiveTransition:self];
    
    [self.privateContainerViewController contextDidStartTransition];
    
}

-(void)activateNonInteractiveTransition{
    self.interactive = NO;
    self.isCancelled = NO;
    self.privateContainerView.layer.beginTime = 0;
    self.privateContainerView.layer.speed = 1;
    [self.privateContainerViewController addChildViewController:self.toViewController];
    [self.animator animateTransition:self];
}


-(void)activateInteractiveTransition{
    self.interactive = YES;
    self.isCancelled = NO;
    [self.privateContainerViewController addChildViewController:self.toViewController];
    self.privateContainerView.layer.beginTime = 0;
    self.privateContainerView.layer.speed = 0;
    [self.animator animateTransition:self];
}



-(void)updateInteractiveTransition:(CGFloat)percentComplete{
    if (self.interactive) {
        self.transitionPercent = percentComplete;
        self.privateContainerView.layer.timeOffset = percentComplete * self.transitionDuration;
        [self.privateContainerViewController contextTransitionProgress:percentComplete];
    }
}

-(void)finishInteractiveTransition{
    self.interactive = NO;
    CADisplayLink * displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(finishCurrentAnimation:)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    
    CFTimeInterval interval = (1-self.transitionPercent) * self.transitionDuration;
    [self performSelector:@selector(fixBeginTimeBug) withObject:nil afterDelay:interval];
}

-(void)cancelInteractiveTransition{
    self.interactive = NO;
    self.isCancelled = YES;
    
    CADisplayLink * displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(reverseCurrentAnimation:)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    
}

-(void)finishCurrentAnimation:(CADisplayLink *)displayLink{
    CFTimeInterval timeOffset = self.privateContainerView.layer.timeOffset + displayLink.duration;
    if (timeOffset > self.transitionDuration) {
        [displayLink invalidate];
        self.privateContainerView.layer.timeOffset = 0.0;
        self.privateContainerView.layer.speed   = 1;
    }
    else{
        self.privateContainerView.layer.timeOffset = timeOffset;
        self.transitionPercent = timeOffset/self.transitionDuration;
        [self.privateContainerViewController contextTransitionProgress:self.transitionPercent];
    }
}


-(void)reverseCurrentAnimation:(CADisplayLink *)displayLink{
    CFTimeInterval timeOffset = self.privateContainerView.layer.timeOffset - displayLink.duration;
    if (timeOffset>0) {
        self.privateContainerView.layer.timeOffset = timeOffset;
        self.transitionPercent = timeOffset/self.transitionDuration;
        
        [self.privateContainerViewController contextTransitionProgress:self.transitionPercent];
    }
    else{
        [displayLink invalidate];
        self.privateContainerView.layer.timeOffset = 0;//self.transitionDuration;
        self.privateContainerView.layer.speed   = 1;
    }
    
}

-(void)fixBeginTimeBug{
    self.privateContainerView.layer.beginTime = 0.0;
}


-(UIView *)containerView{
    return  self.privateContainerView;
}

-(UIViewController *)viewControllerForKey:(UITransitionContextViewControllerKey)key{
    if ([key isEqualToString:UITransitionContextFromViewControllerKey]) {

        return self.fromViewController;
    }
    else if([key isEqualToString:UITransitionContextToViewControllerKey]){
        return self.toViewController;
    }
    return nil;
}

-(UIView *)viewForKey:(UITransitionContextViewKey)key{
    if ([key isEqualToString:UITransitionContextFromViewKey]) {
        return self.fromViewController.view;
    }
    else if([key isEqualToString:UITransitionContextToViewKey]){
        return self.toViewController.view;
    }
    return nil;
}

-(CGRect)initialFrameForViewController:(UIViewController *)vc{
    return CGRectZero;
}

-(CGRect)finalFrameForViewController:(UIViewController *)vc{
    return vc.view.frame;
}

-(BOOL)transitionWasCancelled{
    return self.isCancelled;//标记动画或者交互是否被取消
}


//管理viewcontroller的生命周期
-(void)completeTransition:(BOOL)isComplete{
    [self.toViewController didMoveToParentViewController:self.privateContainerViewController];
    if (isComplete) {
        //会调用viewwilldisappear
        [self.fromViewController willMoveToParentViewController:nil];
        [self.fromViewController.view removeFromSuperview];
        //会调用viewDidDisappear
        [self.fromViewController removeFromParentViewController];
    }
    else{
        //会调用viewwilldisappear
        [self.toViewController willMoveToParentViewController:nil];
        [self.toViewController.view removeFromSuperview];
        //会调用viewDidDisappear
        [self.toViewController removeFromParentViewController];
    }
    if ([self.animator respondsToSelector:@selector(animationEnded:)]) {
        [self.animator animationEnded:!self.isCancelled];
    }
    [self.privateContainerViewController contextDidFinishTransition:self.isCancelled];
}
@end
