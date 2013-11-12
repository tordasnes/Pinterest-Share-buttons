//
//  PinterestButtonsView.m
//  PinterestFeature
//
//  Created by Tord Åsnes on 10/11/13.
//  Copyright (c) 2013 Tord Åsnes. All rights reserved.
//

#import "PinterestButtonsView.h"

static float const kRedRingMoveLimit = 25;
static float const kRedRingReactivate = 15;

@interface PinterestButtonsView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, assign) CGPoint priorPoint;
@property (nonatomic, assign) CGPoint touchDownPoint;

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
    [self.longPressGestureRecognizer setDelegate:self];
    
    self.backgroundOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    self.firstCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popupCircle"]];
    self.secondCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popupCircle"]];
    self.thirdCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popupCircle"]];
    self.redRing = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redRing"]];

    [self prepareImageView:self.firstCircle];
    [self prepareImageView:self.secondCircle];
    [self prepareImageView:self.thirdCircle];
    [self prepareImageView:self.redRing];
    
    self.isShowingCircles = NO;
    self.shouldPan = YES;

    
}

- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer*)gesture
{
    UIView *view = gesture.view;
    CGPoint point = [gesture locationInView:view.superview];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        [self addBackgroundOverlayView];
        
        self.touchDownPoint = point;
        self.shouldPan = YES;
        [self.redRing setImage:[UIImage imageNamed:@"redRing"]];
        
        NSLog(@"%.0f,%.0f, %.0f", point.x, point.y, self.touchDownPoint.x);

        // Add check for where the the tap is on the view
        int direction = 1;
        
        [self showCirclesAtPosition:point withDirection:direction];

    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint redRingCenter = self.redRing.center;

        if (self.shouldPan) {
            redRingCenter.x += point.x - _priorPoint.x;
            redRingCenter.y += point.y - _priorPoint.y;
            self.redRing.center = redRingCenter;
            _priorPoint = redRingCenter;
        } else {
            if (point.x <= (self.touchDownPoint.x + kRedRingReactivate) &&
                point.x >= (self.touchDownPoint.x - kRedRingReactivate) &&
                point.y <= (self.touchDownPoint.y + kRedRingReactivate) &&
                point.y >= (self.touchDownPoint.y - kRedRingReactivate)) {
                self.shouldPan = YES;
                _priorPoint = point;
                [self.redRing setImage:[UIImage imageNamed:@"redRing"]];
                [UIView animateWithDuration:0.1 animations:^{
                    self.redRing.center = point;
                }];

            
            }
        }

        // Limit the panning of the red ring
        if (point.x >= (self.touchDownPoint.x + kRedRingMoveLimit) ||
            point.x <= (self.touchDownPoint.x - kRedRingMoveLimit) ||
            point.y >= (self.touchDownPoint.y + kRedRingMoveLimit) ||
            point.y <= (self.touchDownPoint.y - kRedRingMoveLimit)) {
            
            self.shouldPan = NO;
            [self.redRing setImage:[UIImage imageNamed:@"grayRing"]];
            [UIView animateWithDuration:0.13 animations:^{
                self.redRing.center = self.touchDownPoint;
            }];
        }
        
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
        self.backgroundOverlay.alpha = 0.1;
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
    [self setCirclePosition:self.redRing position:position];

    self.isShowingCircles = YES;
    
    if (direction == 1) { // Left - Up
        
    }
    
    self.redRing.transform = CGAffineTransformMakeScale(1.8, 1.8);
    
    [UIView animateWithDuration:0.22 animations:^{
        self.firstCircle.alpha = 1;
        self.secondCircle.alpha = 1;
        self.thirdCircle.alpha = 1;
        self.redRing.alpha = 1;
        
        self.firstCircle.transform = CGAffineTransformMakeTranslation(0, -86);
        self.secondCircle.transform = CGAffineTransformMakeTranslation(-71, -71);
        self.thirdCircle.transform = CGAffineTransformMakeTranslation(-86, 0);
        self.redRing.transform = CGAffineTransformMakeScale(1, 1);
        
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
    self.redRing.alpha = 0;
    
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
