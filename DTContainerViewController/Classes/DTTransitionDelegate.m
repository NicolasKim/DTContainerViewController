//
//  DTTransitionDelegate.m
//  Pods
//
//  Created by 金秋成 on 2016/12/6.
//
//

#import "DTTransitionDelegate.h"
#import "DTTransitionContext.h"
@implementation DTTransitionDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.interactiveController = [[DTTransitionInteractor alloc]init];
        
    }
    return self;
}

-(id<UIViewControllerAnimatedTransitioning>)dt_animationControllerForContainerViewController:(UIViewController<DTContainerViewControllerProtocol> *)containerViewController
                                                                   transitFromViewController:(UIViewController *)fromViewController atIndex:(NSUInteger)fromIndex
                                                                            toViewController:(UIViewController *)toViewController atIndex:(NSUInteger)toIndex{
    //fromindex 和toindex再次只决定滑动方向
    if (fromIndex < toIndex) {
        return [[DTTransitionAnimator alloc]initWithTransitionDirect:DTTransitionDirectRightToLeft];
        
    }
    else{
        return [[DTTransitionAnimator alloc]initWithTransitionDirect:DTTransitionDirectLeftToRight];
    }
}

-(id<UIViewControllerInteractiveTransitioning>)dt_interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController containerViewController:(UIViewController *)containerViewController{
    return  self.interactiveController;
}


@end




