//
//  DTTransitionInteractor.m
//  Pods
//
//  Created by 金秋成 on 2016/12/6.
//
//

#import "DTTransitionInteractor.h"
#import "DTTransitionContext.h"
@implementation DTTransitionInteractor
-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    self.containerTransitionContext  = transitionContext;
    [self.containerTransitionContext activateInteractiveTransition];
    
}
-(void)updateInteractiveTransition:(CGFloat)percentComplete{
    [self.containerTransitionContext updateInteractiveTransition:percentComplete];
}

-(void)cancelInteractiveTransition{
    [self.containerTransitionContext cancelInteractiveTransition];
}

-(void)finishInteractiveTransition{
    [self.containerTransitionContext finishInteractiveTransition];
}
@end
