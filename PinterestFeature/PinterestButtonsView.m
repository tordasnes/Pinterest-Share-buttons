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
    
    _backgroundOverlay = [[CALayer alloc] init];
}

- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        [self backgroundOverlay];
        
        
        CGPoint touchLocation = [gesture locationInView:self];
        
        
        NSLog(@"%.0f,%.0f", touchLocation.x, touchLocation.y);
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {

    }
}


- (void)backgroundOverlay
{    
    [_backgroundOverlay setBounds:CGRectMake(0, 0, self.superview.bounds.size.height, self.superview.bounds.size.height)];
    [_backgroundOverlay setBackgroundColor:[[UIColor blackColor] CGColor]];
    [_backgroundOverlay setOpacity:0.1];
    [_backgroundOverlay setPosition:CGPointMake(0, 0)];
    [self.layer addSublayer:_backgroundOverlay];
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
