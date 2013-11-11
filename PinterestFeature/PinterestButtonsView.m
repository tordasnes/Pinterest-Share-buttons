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
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
    [self.longPressGestureRecognizer setMinimumPressDuration:0.35];
    [self addGestureRecognizer:self.longPressGestureRecognizer];
    
    self.backgroundOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    self.firstCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popupCircle"]];
    self.secondCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popupCircle"]];
    self.thirdCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popupCircle"]];
    
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
    [self.backgroundOverlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    self.backgroundOverlay.alpha = 0;
    [self addSubview:self.backgroundOverlay];
    [UIView animateWithDuration:0.26 animations:^{
        self.backgroundOverlay.alpha = 0.12;
    }];
}

- (void)removeBackgroundOverlayView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundOverlay.alpha = 0;
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
