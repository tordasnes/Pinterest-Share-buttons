//
//  MainViewController.m
//  PinterestFeature
//
//  Created by Tord Åsnes on 10/11/13.
//  Copyright (c) 2013 Tord Åsnes. All rights reserved.
//

#import "MainViewController.h"
#import "PinterestButtonsView.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    PinterestButtonsView *pinterestView = [[PinterestButtonsView alloc] init];
    [self.view addSubview:pinterestView];

}


@end
