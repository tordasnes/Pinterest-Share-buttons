//
//  PinterestButtonsView.h
//  PinterestFeature
//
//  Created by Tord Åsnes on 10/11/13.
//  Copyright (c) 2013 Tord Åsnes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinterestButtonsView : UIView

@property (nonatomic, copy) NSString *firstCircleTitle;
@property (nonatomic, copy) NSString *secondCircleTitle;
@property (nonatomic, copy) NSString *thirdCircleTitle;

@property (nonatomic, strong) UIView *backgroundOverlay;

@property (nonatomic, strong) UIImageView *firstCircle;
@property (nonatomic, strong) UIImageView *secondCircle;
@property (nonatomic, strong) UIImageView *thirdCircle;
@property (nonatomic, strong) UIImageView *redRing;

@property (nonatomic, assign) BOOL isShowingCircles;

@end
