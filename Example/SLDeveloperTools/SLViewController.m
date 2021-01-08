//
//  SLViewController.m
//  SLDeveloperTools
//
//  Created by sweetloser on 01/03/2021.
//  Copyright (c) 2021 sweetloser. All rights reserved.
//

#import "SLViewController.h"
//#import <SLDeveloperTools.h>
#import <SLDeveloperTools.h>

@interface SLViewController ()

@end

@implementation SLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    SLShareView *s = [[SLShareView alloc] initWithShareObjects:@[]];
//    self.view.backgroundColor = [UIColor sl_colorWithHex:0x8f8f8f];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
