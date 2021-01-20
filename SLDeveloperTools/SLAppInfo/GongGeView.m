//
//  GongGeView.m
//  BXlive
//
//  Created by mac on 2020/7/1.
//  Copyright © 2020 cat. All rights reserved.
//

#import "GongGeView.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import <SDWebImage/SDWebImage.h>

#define ImageTag 111
@interface GongGeView()
@property(nonatomic, strong)UIImageView *imageView;
@end
@implementation GongGeView

-(instancetype)init{
    self = [super init];
    return self;
}
-(void)begainLayImage{
    CGFloat imageWidth =( __ScaleWidth(375)  - 48 ) / 3;
    for (int i = 0; i < 9; i++) {
        _imageView = [[UIImageView alloc]init];
        _imageView.layer.cornerRadius = 5;
        _imageView.layer.masksToBounds = YES;
        if (i >= 6) {
            _imageView.frame = CGRectMake(12 *(i - 6) + imageWidth*(i- 6), 24 + imageWidth * 2, imageWidth, imageWidth);
        }

        else  if (i >= 3) {
            _imageView.frame = CGRectMake(12 *(i - 3) + imageWidth*(i- 3), 12 + imageWidth, imageWidth, imageWidth);
        }
        else{
            _imageView.frame = CGRectMake(12 *(i) + imageWidth*i, 0, imageWidth, imageWidth);
        }
        _imageView.tag = ImageTag + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagAct:)];
        [_imageView addGestureRecognizer:tap];
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
        
    }
}
-(void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    
    if (_imageArray.count == 4) {
        for (int i = 0; i < imageArray.count; i++) {
            if (i >= 2) {
                UIImageView *image = [self viewWithTag:ImageTag + i + 1];
                [image sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:CImage(@"video-placeholder") options:SDWebImageFromCacheOnly];
                image.backgroundColor = [UIColor randomColor];
              
            }else{
                UIImageView *image = [self viewWithTag:ImageTag + i];
                [image sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:CImage(@"video-placeholder") options:SDWebImageFromCacheOnly];
                image.backgroundColor = [UIColor randomColor];

            }
        }
    }
    else{
        for (int i = 0; i < imageArray.count; i++) {
            UIImageView *image = [self viewWithTag:ImageTag + i];
            [image sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:CImage(@"video-placeholder") options:SDWebImageFromCacheOnly];
            image.backgroundColor = [UIColor randomColor];
            image.tag = ImageTag + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagAct:)];
            [image addGestureRecognizer:tap];
            image.userInteractionEnabled = YES;
         
        }
    }
}
//-(void)setImageArray:(NSArray *)imageArray{
//    _imageArray = imageArray;
//    CGFloat imageWidth =( self.frame.size.width  - 48 ) / 3;
//
//    if (_imageArray.count == 3) {
//        for (int i = 0; i< _imageArray.count; i++) {
//            UIImageView *image = [[UIImageView alloc]init];
//            image.layer.cornerRadius = 5;
//            image.layer.masksToBounds = YES;
//            image.backgroundColor = [UIColor randomColor];
//            image.frame = CGRectMake(12 *(i + 1) + imageWidth*i, 12, imageWidth, imageWidth);
//            image.image = [UIImage imageNamed:@""];
//            image.tag = ImageTag + i;
//            [self addSubview:image];
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagAct:)];
//            [image addGestureRecognizer:tap];
//            image.userInteractionEnabled = YES;
//
//        }
//    }
//    else if (_imageArray.count == 4) {
//        for (int i = 0; i< _imageArray.count; i++) {
//            UIImageView *image = [[UIImageView alloc]init];
//            image.backgroundColor = [UIColor randomColor];
//            image.layer.cornerRadius = 5;
//            image.layer.masksToBounds = YES;
//            if (i >= 2) {
//                image.frame = CGRectMake(12 *(i + 1 - 2) + imageWidth*(i- 2), 24 + imageWidth, imageWidth, imageWidth);
//            }else{
//                image.frame = CGRectMake(12 *(i + 1) + imageWidth*i, 12, imageWidth, imageWidth);
//            }
//            image.image = [UIImage imageNamed:@""];
//            image.tag = ImageTag + i;
//            [self addSubview:image];
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagAct:)];
//            [image addGestureRecognizer:tap];
//            image.userInteractionEnabled = YES;
//
//        }
//    }
//    else{
//        for (int i = 0; i< _imageArray.count; i++) {
//            UIImageView *image = [[UIImageView alloc]init];
//            image.backgroundColor = [UIColor randomColor];
//            image.layer.cornerRadius = 5;
//            image.layer.masksToBounds = YES;
//            if (i >= 6) {
//                image.frame = CGRectMake(12 *(i + 1- 6) + imageWidth*(i- 6), 36 + imageWidth * 2, imageWidth, imageWidth);
//            }
//
//            else  if (i >= 3) {
//                image.frame = CGRectMake(12 *(i + 1 - 3) + imageWidth*(i- 3), 24 + imageWidth, imageWidth, imageWidth);
//            }
//            else{
//                image.frame = CGRectMake(12 *(i + 1) + imageWidth*i, 12, imageWidth, imageWidth);
//            }
//            image.image = [UIImage imageNamed:@""];
//            image.tag = ImageTag + i;
//            [self addSubview:image];
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagAct:)];
//            [image addGestureRecognizer:tap];
//            image.userInteractionEnabled = YES;

//        }
//    }
//
//}

-(void)imagAct:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    if (_block) {
        _block([tap.view tag] - ImageTag);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
