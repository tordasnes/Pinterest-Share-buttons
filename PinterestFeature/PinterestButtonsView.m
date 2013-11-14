//
//  PinterestButtonsView.m
//  PinterestFeature
//
//  Created by Tord Åsnes on 10/11/13.
//  Copyright (c) 2013 Tord Åsnes. All rights reserved.
//

#import "PinterestButtonsView.h"

static float const kRedRingMoveLimit = 30;
static float const kRedRingReactivate = 25;

@interface PinterestButtonsView () <UIGestureRecognizerDelegate>
{
    CGFloat firstCircleX;
    CGFloat firstCircleY;
    CGFloat secondCircleX;
    CGFloat secondCircleY;
    CGFloat thirdCircleX;
    CGFloat thirdCircleY;
    
    CGFloat circleScale1;
    double lastDistance1;
    CGFloat offsetCircle1Y;
}

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, assign) CGPoint priorPoint;
@property (nonatomic, assign) CGPoint touchDownPoint;

@end

@implementation PinterestButtonsView

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializer];
    }
    return self;
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
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

#pragma mark - Handle Gestures

- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer*)gesture
{
    UIView *view = gesture.view;
    CGPoint point = [gesture locationInView:view.superview];
    
    static CGAffineTransform originalTransform;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        [self addBackgroundOverlayView];
        
        self.touchDownPoint = point;
        self.shouldPan = YES;
        [self.redRing setImage:[UIImage imageNamed:@"redRing"]];
        
        NSLog(@"%.0f,%.0f, %.0f", point.x, point.y, self.touchDownPoint.x);
        
        originalTransform = self.firstCircle.transform;
        circleScale1 = 1;
        lastDistance1 = 80;
        offsetCircle1Y = 0;

        // Check where the the tap is on the view
        int direction = 0;
        CGSize size = self.frame.size;
        
        // Decide which way the circles pop out
        if (self.touchDownPoint.x >= size.width/2 && self.touchDownPoint.y >= size.height/4) {
            direction = 1; // Left - UP
        } else if (self.touchDownPoint.x <= size.width/2 && self.touchDownPoint.y >= size.height/4){
            direction = 2; // Right - Up
        } else if (self.touchDownPoint.x >= size.width/2 && self.touchDownPoint.y <= size.height/4) {
            direction = 3; // Left - Down
        } else if (self.touchDownPoint.x <= size.width/2 && self.touchDownPoint.y <= size.height/4) {
            direction = 4; // Right - Down
        } else {
            direction = 1;
        }
        
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
            [UIView animateWithDuration:0.16 animations:^{
                self.redRing.center = self.touchDownPoint;
            }];
        }
        
        if (1 == 1) { // Add - Check which direction
            
            
            
            }
//            double distanceFirstCircle = [self getDistanceFromPoint:point cirlce:self.firstCircle];
//            NSLog(@"%f", distanceFirstCircle);
//            
//            if (distanceFirstCircle < lastDistance1 && distanceFirstCircle > 15) {
//                lastDistance1 = distanceFirstCircle;
//                circleScale1 += 0.007;
//                if (offsetCircle1Y > -30) {
//                    offsetCircle1Y -= 0.6;
//
//                }
//                if (distanceFirstCircle < 50) {
//                    [self.firstCircle setImage:[UIImage imageNamed:@"popupCircleRed"]];
//                }
//            } else if (distanceFirstCircle > lastDistance1 && circleScale1 >= 1) {
//                lastDistance1 = distanceFirstCircle;
//                circleScale1 -= 0.01;
//                if (offsetCircle1Y < 0) {
//                    offsetCircle1Y += 1;
//                }
//                if (distanceFirstCircle > 50) {
//                    [self.firstCircle setImage:[UIImage imageNamed:@"popupCircle"]];
//
//                }
//            } else {
//                [self.firstCircle setImage:[UIImage imageNamed:@"popupCircle"]];
//            }
//            
//            CGAffineTransform scaleTransform = CGAffineTransformScale(originalTransform, circleScale1, circleScale1);
//            
//            CGAffineTransform position = CGAffineTransformTranslate(originalTransform, firstCircleX + originalTransform.tx, firstCircleY + originalTransform.ty + offsetCircle1Y);
//            
//            self.firstCircle.transform = CGAffineTransformConcat(scaleTransform, position);
        
        
        
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self removeBackgroundOverlayView];
        [self removeCircles];
    }
}

# pragma mark - Utils

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
    
    CGFloat firstCircleOffsetX;
    CGFloat firstCircleOffsetY;
    CGFloat secondCircleOffsetX;
    CGFloat secondCircleOffsetY;
    CGFloat thirdCircleOffsetX;
    CGFloat thirdCircleOffsetY;

    
    switch (direction) {
        case 1: // Left - Up
            firstCircleX = 0;
            firstCircleY = -80;
            secondCircleX = -65;
            secondCircleY = -65;
            thirdCircleX = -80;
            thirdCircleY = 0;
            
            firstCircleOffsetX = 0;
            firstCircleOffsetY = -6;
            secondCircleOffsetX = -6;
            secondCircleOffsetY = -6;
            thirdCircleOffsetX = -6;
            thirdCircleOffsetY = 0;
            break;
            
        case 2: // Right - Up
            firstCircleX = 0;
            firstCircleY = -80;
            secondCircleX = 65;
            secondCircleY = -65;
            thirdCircleX = 80;
            thirdCircleY = 0;
            
            firstCircleOffsetX = 0;
            firstCircleOffsetY = -6;
            secondCircleOffsetX = 6;
            secondCircleOffsetY = -6;
            thirdCircleOffsetX = 6;
            thirdCircleOffsetY = 0;
            break;
            
        case 3: // Left - Down
            firstCircleX = -80;
            firstCircleY = 0;
            secondCircleX = -65;
            secondCircleY = 65;
            thirdCircleX = 0;
            thirdCircleY = 80;
            
            firstCircleOffsetX = -6;
            firstCircleOffsetY = 0;
            secondCircleOffsetX = -6;
            secondCircleOffsetY = 6;
            thirdCircleOffsetX = 0;
            thirdCircleOffsetY = 6;
            break;
            
        case 4: // Right - Down
            firstCircleX = 0;
            firstCircleY = 80;
            secondCircleX = 65;
            secondCircleY = 65;
            thirdCircleX = 80;
            thirdCircleY = 0;
            
            firstCircleOffsetX = 0;
            firstCircleOffsetY = 6;
            secondCircleOffsetX = 6;
            secondCircleOffsetY = 6;
            thirdCircleOffsetX = 6;
            thirdCircleOffsetY = 0;
            break;
            
        default: // Left - Up
            firstCircleX = 0;
            firstCircleY = -80;
            secondCircleX = -65;
            secondCircleY = -65;
            thirdCircleX = -80;
            thirdCircleY = 0;
            
            firstCircleOffsetX = 0;
            firstCircleOffsetY = -6;
            secondCircleOffsetX = -6;
            secondCircleOffsetY = -6;
            thirdCircleOffsetX = -6;
            thirdCircleOffsetY = 0;
            break;
    }
    
    self.redRing.transform = CGAffineTransformMakeScale(2, 2);
    
    [UIView animateWithDuration:0.22 animations:^{
        self.firstCircle.alpha = 1;
        self.secondCircle.alpha = 1;
        self.thirdCircle.alpha = 1;
        self.redRing.alpha = 1;
        
        self.firstCircle.transform = CGAffineTransformMakeTranslation(firstCircleX + firstCircleOffsetX,
                                                                      firstCircleY + firstCircleOffsetY);
        self.secondCircle.transform = CGAffineTransformMakeTranslation(secondCircleX + secondCircleOffsetX,
                                                                       secondCircleY + secondCircleOffsetY);
        self.thirdCircle.transform = CGAffineTransformMakeTranslation(thirdCircleX + thirdCircleOffsetX,
                                                                      thirdCircleY + thirdCircleOffsetY);
        self.redRing.transform = CGAffineTransformMakeScale(1, 1);
        
    } completion:^(BOOL finished) {
       [UIView animateWithDuration:0.22 animations:^{
           self.firstCircle.transform = CGAffineTransformMakeTranslation(firstCircleX, firstCircleY);
           self.secondCircle.transform = CGAffineTransformMakeTranslation(secondCircleX, secondCircleY);
           self.thirdCircle.transform = CGAffineTransformMakeTranslation(thirdCircleX, thirdCircleY);
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

- (void)setCirclePosition:(UIImageView*)circle position:(CGPoint)position
{
    [circle setCenter:position];
}

- (double)getDistanceFromPoint:(CGPoint)point cirlce:(UIImageView*)circle
{
    return sqrt(pow(((circle.center.x) - point.x), 2)
                + pow(((circle.center.y) - point.y), 2));
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
