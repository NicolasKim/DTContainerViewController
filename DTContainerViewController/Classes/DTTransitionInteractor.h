//
//  DTTransitionInteractor.h
//  Pods
//
//  Created by 金秋成 on 2016/12/6.
//
//

#import <Foundation/Foundation.h>
@class DTTransitionContext;

@interface DTTransitionInteractor : NSObject<UIViewControllerInteractiveTransitioning>
@property (nonatomic,weak)DTTransitionContext * containerTransitionContext;

-(void)updateInteractiveTransition:(CGFloat)percentComplete;

-(void)cancelInteractiveTransition;

-(void)finishInteractiveTransition;

@end
