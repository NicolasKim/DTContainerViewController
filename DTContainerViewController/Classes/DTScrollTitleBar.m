//
//  DTScrollTitleBar.m
//  Pods
//
//  Created by 金秋成 on 2017/1/23.
//
//

#import "DTScrollTitleBar.h"

@implementation DTScrollTitleBar
{
    DTScrollTitleBarNumberBlock  _titleCountHandle;
    DTScrollTitleBarTitleBlock   _titleHandle;
    DTScrollTitleBarSelectBlock  _onSelectHandle;
    NSMutableArray<UIButton *> *  _btnArr;
    NSMutableArray<NSString *> *  _btnFrames;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    _btnArr = [NSMutableArray new];
    _btnFrames = [NSMutableArray new];
    _hEdge = UIEdgeInsetsMake(0, 10, 0, 10);
    _hSpace = 40;
    
    _titleFont = [UIFont systemFontOfSize:14];
    _titleColor = [UIColor blackColor];
    _selectedTitleColor = [UIColor redColor];
    _indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, self.bounds.size.height)];
    _indicatorView.backgroundColor = [UIColor yellowColor];
    [self addSubview:_indicatorView];
}



-(instancetype)titleForTitleBar:(DTScrollTitleBarTitleBlock)block{
    _titleHandle = [block copy];
    return self;
}

-(instancetype)numberOfTitle:(DTScrollTitleBarNumberBlock)block{
    _titleCountHandle = [block copy];
    return self;
}

-(instancetype)onSelect:(DTScrollTitleBarSelectBlock)block{
    _onSelectHandle = [block copy];
    return self;
}

-(void)reloadData{
    
    [_btnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_btnFrames removeAllObjects];
    [_btnArr removeAllObjects];

    
    NSInteger count = 0;
    if (_titleCountHandle) {
        count = _titleCountHandle();
    }
    if (count <= 0) return;
    
    if (self.selectedIndex >= count) {
        _selectIndex = count-1;
    }
    
    switch (self.titleBarStyle) {
        case DTScrollTitleBarType_Average:
        {
            CGFloat titleWidth = (self.bounds.size.width - self.hEdge.left - self.hEdge.right - self.hSpace * (count-1)) / count;
            if (titleWidth <= 0) return;
        
            for (NSInteger i = 0; i < count; i++) {
                UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(self.hEdge.left + (titleWidth + self.hSpace)*i, 0, titleWidth, self.bounds.size.height)];
                if (_titleHandle) {
                    NSString * title = _titleHandle(i);
                    [button setTitle:title forState:UIControlStateNormal];
                    [button setTitleColor:self.titleColor forState:UIControlStateNormal];
                    [button setTitleColor:self.selectedTitleColor forState:UIControlStateSelected];
                    button.tag = 1000+i;
                    [button addTarget:self action:@selector(didSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
                }
                [_btnFrames addObject:NSStringFromCGRect(button.frame)];
                [_btnArr addObject:button];
                [self addSubview:button];
            }
            self.selectIndex = self.selectedIndex;
        }
            break;
        case DTScrollTitleBarType_fitToTitleSize:
        {
            for (NSInteger i = 0; i < count; i++) {

                if (_titleHandle) {
                    NSString * title = _titleHandle(i);
                    
                    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.bounds.size.height)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName : self.titleFont}
                                                           context:nil];
                    
                    UIButton * button = [[UIButton alloc]initWithFrame:CGRectZero];
                    
                    CGRect lastTitleRect = CGRectZero;
                    if (_btnFrames.lastObject) {
                        lastTitleRect = CGRectFromString(_btnFrames.lastObject);
                        titleRect.origin.x = CGRectGetMaxX(lastTitleRect) + self.hSpace;
                        titleRect.origin.y = 0;
                        
                    }
                    else{
                        titleRect.origin.x = self.hEdge.left;
                        titleRect.origin.y = 0;
                    }
                    titleRect.size.height = self.bounds.size.height;
                    button.frame = titleRect;
                    [button setTitle:title forState:UIControlStateNormal];
                    button.titleLabel.font = self.titleFont;
                    [button setTitleColor:self.titleColor forState:UIControlStateNormal];
                    [button setTitleColor:self.selectedTitleColor forState:UIControlStateSelected];
                    button.tag = 1000+i;
                    [button addTarget:self action:@selector(didSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [_btnFrames addObject:NSStringFromCGRect(button.frame)];
                    [_btnArr addObject:button];
                    [self addSubview:button];
                }
                
                CGFloat contentWidth = CGRectGetMaxX(CGRectFromString(_btnFrames.lastObject)) + self.hEdge.right;
                self.contentSize = CGSizeMake(contentWidth, self.bounds.size.height);
                
                
            }
            
            self.selectIndex = self.selectedIndex;
            
        }
            break;
        default:
            break;
    }
}


-(void)didSelectBtn:(UIButton *)sender{

    if (self.selectedIndex == (sender.tag - 1000)) {
        return;
    }
    
    [self setSelectIndex:sender.tag -1000 animated:YES];
    if (_onSelectHandle) {
        _onSelectHandle(sender.tag - 1000);
    }
    
    
    
    
    
    
}


-(void)setSelectIndex:(NSInteger)selectIndex{
    [self setSelectIndex:selectIndex animated:NO];
}

-(void)setSelectIndex:(NSInteger)selectIndex animated:(BOOL)animated{
    
    
    if (selectIndex >= _btnArr.count)return;
    _selectIndex = selectIndex;
    
    for (UIButton * btn in _btnArr) {
        if (btn.tag == selectIndex + 1000) {
            btn.selected = YES;
        }
        else{
            btn.selected = NO;
        }
    }

    CGRect btnRect = CGRectFromString([_btnFrames objectAtIndex:selectIndex]);
   
    if (animated) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _indicatorView.frame = CGRectMake(btnRect.origin.x, 0, btnRect.size.width, self.bounds.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        _indicatorView.frame = CGRectMake(btnRect.origin.x, 0, btnRect.size.width, self.bounds.size.height);
    }
    
    
    if (self.titleBarStyle == DTScrollTitleBarType_fitToTitleSize) {

        CGRect btnRect = CGRectFromString(_btnFrames[selectIndex]);

        CGFloat offsetX = btnRect.origin.x + btnRect.size.width/2 - self.bounds.size.width/2;
        
        if (offsetX> 0 && offsetX < self.contentSize.width - self.bounds.size.width) {
            [self setContentOffset:CGPointMake(offsetX, 0) animated:animated];
        }
        else if (offsetX <= 0){
            [self setContentOffset:CGPointMake(0, 0) animated:animated];
        }
        else if (offsetX >= self.contentSize.width - self.bounds.size.width ){
            [self setContentOffset:CGPointMake(self.contentSize.width - self.bounds.size.width, 0) animated:animated];
        }
    }
}

@end
