//
//  BXCustomAnnotationView.h
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "BXCustomCalloutView.h"

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0

@interface BXCustomAnnotationView : MAAnnotationView

@property (nonatomic, strong) UIImage *portrait;
@property (nonatomic, strong) BXCustomCalloutView *calloutView;

@property (nonatomic, assign) BOOL canPop;

@end
