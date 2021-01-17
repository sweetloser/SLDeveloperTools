//
//  BXCustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "BXCustomAnnotationView.h"
#import "../SLMacro/SLMacro.h"

@interface BXCustomAnnotationView ()

@property (nonatomic, strong) UIImageView *portraitImageView;

@end

@implementation BXCustomAnnotationView

@synthesize calloutView;
@synthesize portraitImageView   = _portraitImageView;

#pragma mark - Override

- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}

- (void)setSelected:(BOOL)selected {

    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected) {
        return;
    }
    
    if (selected) {
        if (self.canPop) {
            if (self.calloutView == nil) {
                /* Construct custom callout. */
                self.calloutView = [[BXCustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
                self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                      -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            }
            self.calloutView.titleLb.text = self.annotation.title;
            self.calloutView.subTitleLb.text = self.annotation.subtitle;
            [self addSubview:self.calloutView];
        }
    }
    else {
        [self.calloutView removeFromSuperview];
    }
    [super setSelected:selected animated:animated];
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bounds = CGRectMake(0.f, 0.f, 60, 62);
        self.backgroundColor = [UIColor clearColor];
        
        self.portraitImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.portraitImageView.image = CImage(@"location-map-weizhi");
        [self addSubview:self.portraitImageView];
    }
    
    return self;
}

@end
