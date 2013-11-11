//
//  PinterestButtonsView.h
//  PinterestFeature
//
//  Created by Tord Åsnes on 10/11/13.
//  Copyright (c) 2013 Tord Åsnes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinterestButtonsView : UIView

@property (nonatomic, copy) NSString *firstButtonTitle;
@property (nonatomic, copy) NSString *secondButtonTitle;
@property (nonatomic, copy) NSString *thirdButtonTitle;

@property (nonatomic, strong) UIView *backgroundOverlay;



@end
