//
//  BXDynNewOnePicCell.m
//  BXlive
//
//  Created by mac on 2020/7/6.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynNewOnePicCell.h"
#import "HZPhotoBrowser.h"
#import "BXDynamicDetailsVC.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "../SLMacro/SLMacro.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <SDWebImage/SDWebImage.h>
#import <YYCategories/YYCategories.h>
#import "../SLCategory/SLCategory.h"


@interface BXDynNewOnePicCell()<HZPhotoBrowserDelegate>
@property(nonatomic, strong)FLAnimatedImageView *OneImageView;
@property(nonatomic, strong)UIImageView *identificationImage;
@property(nonatomic, strong)HZPhotoBrowser *browser;
@end
@implementation BXDynNewOnePicCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
//        [self initView];
    }
    return self;
}

-(void)setView{
  
     _OneImageView = [[FLAnimatedImageView alloc]init];
    
//    [[SDImageCache sharedImageCache] setShouldGroupAccessibilityChildren:NO];
//    [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(liulanAct)];
    [_OneImageView addGestureRecognizer:tap];
    _OneImageView.userInteractionEnabled = YES;
    _OneImageView.layer.masksToBounds = YES;
    _OneImageView.layer.cornerRadius = 5;
    _OneImageView.contentMode=UIViewContentModeScaleAspectFill;
    _OneImageView.clipsToBounds=YES;//  是否剪切掉超出 UIImageView 范围的图片
    _OneImageView.backgroundColor = UIColorHex(F5F9FC);
    _identificationImage = [[UIImageView alloc]init];
    _identificationImage.image = CImage(@"Image_type_gif");
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
    
    if ( [self.model.msgdetailmodel.imgs_detail isArray] && self.model.msgdetailmodel.imgs_detail.count) {
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
//        NSString *picstr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/300",self.model.msgdetailmodel.picture[0]];
      NSString  *picstr = [NSString stringWithFormat:@"%@",self.model.msgdetailmodel.smallpicture[0]];
        [_OneImageView sd_setImageWithURL:[NSURL URLWithString:picstr]];
    }else{
        [_OneImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
        self.concenterBackview.sd_layout.heightIs(0);
        _OneImageView.sd_resetLayout.leftEqualToView(self.concenterBackview).topEqualToView(self.concenterBackview).widthIs(108).heightIs(0);
    }

}
-(void)liulanAct{
//    if (self.DidPicIndex) {
//        self.DidPicIndex(3);
//    }
    WS(weakSelf);
    if (self.model.msgdetailmodel.picture.count) {
        _browser = [[HZPhotoBrowser alloc] init];
        _browser.isFullWidthForLandScape = YES;
        _browser.delegate = self;
        _browser.DidClick = ^(NSInteger type) {
                NSInteger render_type = [weakSelf.model.msgdetailmodel.render_type integerValue];
            if (render_type == 0 || render_type == 10 ||render_type == 11 ||render_type == 1 ||render_type == 2 ||render_type == 3 ||render_type == 4 ||render_type == 6) {
                BXDynamicDetailsVC *vc = [[BXDynamicDetailsVC alloc]initWithType:weakSelf.model.msgdetailmodel.render_type model:weakSelf.model];
                vc.model = weakSelf.model;
                [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
            }
        };
        _browser.isNeedLandscape = NO;
        _browser.currentImageIndex = 0;
//        _browser.model = self.model;
        [_browser updateCommentNumlableText:[NSString stringWithFormat:@"%@", self.model.msgdetailmodel.comment_num]];
        [_browser updateLikeNumlableText:[NSString stringWithFormat:@"%@",self.model.msgdetailmodel.like_num]];
       if ([[NSString stringWithFormat:@"%@",self.model.msgdetailmodel.extend_already_live] isEqualToString:@"1"]) {
           [_browser updateLikeImage:CImage(@"dyn_issue_liked")];
       }else{
           [_browser updateLikeImage:CImage(@"dyn_issue_like_whiteBack")];
       }
        
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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
