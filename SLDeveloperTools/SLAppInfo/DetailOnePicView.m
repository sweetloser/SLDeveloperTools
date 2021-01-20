//
//  DetailOnePicView.m
//  BXlive
//
//  Created by mac on 2020/7/30.
//  Copyright © 2020 cat. All rights reserved.
//

#import "DetailOnePicView.h"
#import "HZPhotoBrowser.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <SDWebImage/SDWebImage.h>

@interface DetailOnePicView()<HZPhotoBrowserDelegate>
@property(nonatomic, strong)UIImageView *OneImageView;
@property(nonatomic, strong)UIImageView *identificationImage;
@property(nonatomic, strong)HZPhotoBrowser *browser;
@end
@implementation DetailOnePicView
- (instancetype) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
  
     _OneImageView = [[UIImageView alloc]init];
    _OneImageView.backgroundColor = [UIColor randomColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(liulanAct)];
    [_OneImageView addGestureRecognizer:tap];
    _OneImageView.userInteractionEnabled = YES;
    _OneImageView.contentMode=UIViewContentModeScaleAspectFill;
    _OneImageView.clipsToBounds=YES;//  是否剪切掉超出 UIImageView 范围的图片
    
    _identificationImage = [[UIImageView alloc]init];
    _identificationImage.hidden = YES;

    [self.concenterBackview sd_addSubviews:@[_OneImageView]];
    _OneImageView.sd_layout.leftEqualToView(self.concenterBackview).topEqualToView(self.concenterBackview).rightSpaceToView(self.concenterBackview, 0).bottomSpaceToView(self.concenterBackview, 0);

    [self.OneImageView sd_addSubviews:@[self.identificationImage]];
    self.identificationImage.sd_layout.rightEqualToView(self.OneImageView).bottomEqualToView(self.OneImageView).heightIs(20).widthIs(40);

}
-(void)updateCenterView{
    if ([[NSString stringWithFormat:@"%@", self.model.msgdetailmodel.render_type] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%@", self.model.msgdetailmodel.render_type] isEqualToString:@"5"]) {
          _identificationImage.hidden = YES;
        self.concenterBackview.sd_layout.heightIs(196);
        _OneImageView.sd_resetLayout.leftEqualToView(self.concenterBackview).topEqualToView(self.concenterBackview).widthIs(196).bottomSpaceToView(self.concenterBackview, 0);
    }
    if ([[NSString stringWithFormat:@"%@", self.model.msgdetailmodel.render_type] isEqualToString:@"10"]) {
          _identificationImage.hidden = NO;
        self.concenterBackview.sd_layout.heightIs(196);
        _OneImageView.sd_resetLayout.leftEqualToView(self.concenterBackview).topEqualToView(self.concenterBackview).widthIs(115).bottomSpaceToView(self.concenterBackview, 0);
    }
    if ([[NSString stringWithFormat:@"%@", self.model.msgdetailmodel.render_type] isEqualToString:@"11"]) {
          _identificationImage.hidden = NO;

        self.concenterBackview.sd_layout.heightIs(108);
        _OneImageView.sd_resetLayout.leftEqualToView(self.concenterBackview).topEqualToView(self.concenterBackview).widthIs(108).heightIs(108);
    }
    if (self.model.msgdetailmodel.imgs_detail.count) {
        if ([[self.model.msgdetailmodel.imgs_detail[0] objectForKey:@"badge"] isEqualToString:@"gif"]) {
              _identificationImage.hidden = NO;
            _identificationImage.image = CImage(@"Image_type_gif");
        }
        else if ([[self.model.msgdetailmodel.imgs_detail[0] objectForKey:@"badge"] isEqualToString:@"long"]) {
            _identificationImage.hidden = NO;
           _identificationImage.image = CImage(@"Image_type_long");
        }else{
            _identificationImage.hidden = YES;
        }
    }
    if (self.model.msgdetailmodel.picture.count) {
        NSString *picstr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/300",self.model.msgdetailmodel.picture[0]];
        [_OneImageView sd_setImageWithURL:[NSURL URLWithString:picstr] placeholderImage:CImage(@"video-placeholder")];
    }else{
        [_OneImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:CImage(@"video-placeholder")];
        self.concenterBackview.sd_layout.heightIs(0);
        _OneImageView.sd_resetLayout.leftEqualToView(self.concenterBackview).topEqualToView(self.concenterBackview).widthIs(108).heightIs(0);
    }
}
-(void)liulanAct{

    if (self.model.msgdetailmodel.picture.count) {
        _browser = [[HZPhotoBrowser alloc] init];
        _browser.isFullWidthForLandScape = YES;
        _browser.isNeedLandscape = NO;
        _browser.delegate = self;
        _browser.hiddenbottom = YES;
        _browser.currentImageIndex = 0;
        _browser.imageArray = self.model.msgdetailmodel.picture;
        [_browser show];
    }

}
-(UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已

    return self.OneImageView.image;
}
-(NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
     if ([self.model.msgdetailmodel.picture[0] isKindOfClass:[UIImage class]]) {
         return nil;

    }else{
        NSString *img_url = self.model.msgdetailmodel.picture[0];
        return [NSURL URLWithString:img_url];
    }
}
@end
