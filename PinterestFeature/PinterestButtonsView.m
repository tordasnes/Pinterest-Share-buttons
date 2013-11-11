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
    [self.longPressGestureRecognizer setMinimumPressDuration:0.3];
    [self addGestureRecognizer:self.longPressGestureRecognizer];
    
    self.backgroundOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    self.firstCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popupCircle"]];
    self.secondCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popupCircle"]];
    self.thirdCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popupCircle"]];

    [self prepareImageView:self.firstCircle];
    [self prepareImageView:self.secondCircle];
    [self prepareImageView:self.thirdCircle];

    
}

- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        [self addBackgroundOverlayView];
        
        CGPoint touchPosition = [gesture locationInView:self];
        NSLog(@"%.0f,%.0f", touchPosition.x, touchPosition.y);

        // Add check for where the the tap is on the view
        int direction = 1;
        
        [self showCirclesAtPosition:touchPosition withDirection:direction];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self removeBackgroundOverlayView];
        [self removeCircles];
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



- (void)showCirclesAtPosition:(CGPoint)position withDirection:(int)direction
{
    [self setCirclePosition:self.firstCircle position:position];
    [self setCirclePosition:self.secondCircle position:position];
    [self setCirclePosition:self.thirdCircle position:position];

    
    if (direction == 1) { // Left - Up
        
    }
    
    [UIView animateWithDuration:0.22 animations:^{
        self.firstCircle.alpha = 1;
        self.secondCircle.alpha = 1;
        self.thirdCircle.alpha = 1;
        
        self.firstCircle.transform = CGAffineTransformMakeTranslation(0, -86);
        self.secondCircle.transform = CGAffineTransformMakeTranslation(-71, -71);
        self.thirdCircle.transform = CGAffineTransformMakeTranslation(-86, 0);
        
    } completion:^(BOOL finished) {
       [UIView animateWithDuration:0.22 animations:^{
           self.firstCircle.transform = CGAffineTransformMakeTranslation(0, -80);
           self.secondCircle.transform = CGAffineTransformMakeTranslation(-65, -65);
           self.thirdCircle.transform = CGAffineTransformMakeTranslation(-80, 0);
       }];
    }];
}

- (void)removeCircles
{
    self.firstCircle.alpha = 0;
    self.secondCircle.alpha = 0;
    self.thirdCircle.alpha = 0;
    
    self.firstCircle.transform = CGAffineTransformMakeTranslation(0, 0);
    self.secondCircle.transform = CGAffineTransformMakeTranslation(0, 0);
    self.thirdCircle.transform = CGAffineTransformMakeTranslation(0, 0);
}

# pragma mark - Helper methods

- (void)setCirclePosition:(UIImageView*)circle position:(CGPoint)position
{
    [circle setCenter:position];
}

- (void)prepareImageView:(UIImageView*)image
{
    image.alpha = 0;
    //image.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [self addSubview:image];
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
