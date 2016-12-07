//
//  DTTransitionContext.h
//  Pods
//
//  Created by 金秋成 on 2016/12/6.
//
//

#import <Foundation/Foundation.h>
#import "DTTransitionDelegate.h"


@protocol DTContainerViewControllerProtocol <NSObject>
@required
-(void)contextDidStartTransition;
-(void)contextTransitionProgress:(CGFloat)progress;
-(void)contextDidFinishTransition:(BOOL)isCanceled;
@end


@interface DTTransitionContext : NSObject<UIViewControllerContextTransitioning>
@property (nonatomic,weak)UIViewController * fromViewController;
@property (nonatomic,assign)NSUInteger fromIndex;
@property (nonatomic,weak)UIViewController * toViewController;
@property (nonatomic,assign)NSUInteger toIndex;

//转场代理
@property (nonatomic,strong,readonly)DTTransitionDelegate * trasitionDelegate;

-(instancetype)initWithContainerViewController:(UIViewController *)containerViewController
                                 containerView:(UIView *)containerView;
//开始动画转场
-(void)startAnimationTrasition;

-(void)startInteractiveTransition;

-(void)activateInteractiveTransition;

-(void)updateInteractiveTransition:(CGFloat)percentComplete;

-(void)cancelInteractiveTransition;

-(void)finishInteractiveTransition;


@end
