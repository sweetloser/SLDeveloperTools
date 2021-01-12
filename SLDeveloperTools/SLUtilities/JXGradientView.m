//
//  JXGradientView.m
//  BXlive
//
//  Created by bxlive on 2019/9/3.
//  Copyright © 2019 cat. All rights reserved.
//

#import "JXGradientView.h"

@implementation JXGradientView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)self.layer;
}

@end
