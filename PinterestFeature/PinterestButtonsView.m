//
//  PinterestButtonsView.m
//  PinterestFeature
//
//  Created by Tord Åsnes on 10/11/13.
//  Copyright (c) 2013 Tord Åsnes. All rights reserved.
//

#import "PinterestButtonsView.h"

@interface PinterestButtonsView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end


@implementation PinterestButtonsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializer];
    }
    return self;
}

- (void)initializer
{
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
    [self addGestureRecognizer:_longPressGestureRecognizer];
    
    _backgroundOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        [self addBackgroundOverlayView];
        
        
        CGPoint touchLocation = [gesture locationInView:self];
        
        
        NSLog(@"%.0f,%.0f", touchLocation.x, touchLocation.y);
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self removeBackgroundOverlayView];
    }
}


- (void)addBackgroundOverlayView
{
    [_backgroundOverlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    _backgroundOverlay.alpha = 0;
    [self addSubview:_backgroundOverlay];
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundOverlay.alpha = 0.12;
    }];
}

- (void)removeBackgroundOverlayView
{
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundOverlay.alpha = 0;
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
