//
//  DTTransitionDelegate.h
//  Pods
//
//  Created by 金秋成 on 2016/12/6.
//
//

#import <Foundation/Foundation.h>
#import "DTTransitionAnimator.h"
#import "DTTransitionInteractor.h"

@protocol DTContainerViewControllerProtocol;

@protocol DTTransitionProtocol <NSObject>

-(id<UIViewControllerAnimatedTransitioning>)dt_animationControllerForContainerViewController:(UIViewController<DTContainerViewControllerProtocol> *)containerViewController
                                                                   transitFromViewController:(UIViewController *)fromViewController
                                                                                     atIndex:(NSUInteger)fromIndex
                                                                            toViewController:(UIViewController *)toViewController
                                                                                     atIndex:(NSUInteger)toIndex;

-(id<UIViewControllerInteractiveTransitioning>)dt_interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
                                                                      containerViewController:(UIViewController *)containerViewController;

@end



@interface DTTransitionDelegate : NSObject<DTTransitionProtocol>
@property (nonatomic,strong)DTTransitionInteractor * interactiveController;
@end
