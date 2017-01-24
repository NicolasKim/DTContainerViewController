//
//  DTTransitionAnimator.m
//  Pods
//
//  Created by 金秋成 on 2016/12/6.
//
//

#import "DTTransitionAnimator.h"
@implementation DTTransitionAnimator
-(instancetype)initWithTransitionDirect:(DTTransitionDirect)direct{
    self = [super init];
    if (self) {
        _transitionDirect = direct;
    }
    return self;
}
//协议方法：确定转场的动画时长
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.28;//统一动画时长为0.28秒
}
//协议方法：确定转场的动画的样式
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //获取toviewcontroller
    UIViewController * tovc   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获取fromviewcontroller
    UIViewController * fromvc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    
    
    //获取容器视图，所有转场都在该视图内进行
    UIView * containerView = [transitionContext containerView];
    UIView * toView        = tovc.view;
    UIView * fromView      = fromvc.view;
    

    
    //获取转场时长
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    //设置视图为容器视图的大小，考虑后续有控件加入容器视图控制器的view的情况。
    toView.frame = containerView.bounds;
    [containerView addSubview:toView];
    //这里就不多做解释
    switch (_transitionDirect) {
        case DTTransitionDirectLeftToRight:
        {
            CGFloat toTranslationX = toView.frame.size.width;
            CGFloat fromTranslationX = fromView.frame.size.width;
            toView.transform = CGAffineTransformMakeTranslation(-toTranslationX, 0);
            fromView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                toView.transform = CGAffineTransformMakeTranslation(0, 0);
                fromView.transform = CGAffineTransformMakeTranslation(fromTranslationX, 0);
            } completion:^(BOOL finished) {
                toView.transform = CGAffineTransformIdentity;
                fromView.transform = CGAffineTransformIdentity;
                //动画完成后必须调用该方法
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }
            break;
        case DTTransitionDirectRightToLeft:
        {
            CGFloat toTranslationX = toView.frame.size.width;
            CGFloat fromTranslationX = fromView.frame.size.width;
            toView.transform = CGAffineTransformMakeTranslation(toTranslationX, 0);
            fromView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                toView.transform = CGAffineTransformMakeTranslation(0, 0);
                fromView.transform = CGAffineTransformMakeTranslation(-fromTranslationX, 0);
            } completion:^(BOOL finished) {
                //动画结束后重置transform
                toView.transform = CGAffineTransformIdentity;
                fromView.transform = CGAffineTransformIdentity;
                //动画完成后必须调用该方法
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }
            break;
        default:
        {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }
            break;
    }
}
@end
