//
//  TiUISubMenuThreeViewCell.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/6.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TiUISubMenuThreeViewCell.h"
#import "TIUITool.h"
#import "../../TiUITool/TIConfig.h"
#import <YYCategories/YYCategories.h>

@interface TiUISubMenuThreeViewCell ()

@property(nonatomic ,strong)TIButton *cellButton;

@end

@implementation TiUISubMenuThreeViewCell


-(TIButton *)cellButton{
    if (_cellButton==nil) {
        _cellButton = [[TIButton alloc]initWithScaling:0.7];
        _cellButton.userInteractionEnabled = NO;
    }
    return _cellButton;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { 
        [self addSubview:self.cellButton];
        [self.cellButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self);
        }];
          
        [self.cellButton setBorderWidth:0.0 BorderColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.cellButton setBorderWidth:2.0 BorderColor:TI_Color_Default_Background_Pink forState:UIControlStateSelected];
        
    }
    return self;
}


- (void)setSubMod:(TIMenuMode *)subMod WithTag:(NSInteger)tag
{
    if (subMod) {
    _subMod = subMod;
    
        if (subMod.menuTag) {
            WeakSelf;
            NSString *iconUrl = @"";
            NSString *folder = @"";
            switch (tag) {
                    case 2:
                    iconUrl = [TiSDK getStickerIconURL];
                    folder = @"sticker_icon";
                                       break;
                    case 3:
                    iconUrl = [TiSDK getGiftIconURL];
                    folder = @"gift_icon";
                                       break;
                    case 7:
                    iconUrl = [TiSDK getWatermarkIconURL];
                    folder = @"watermark_icon";
                                       break;
                    case 8:
                    iconUrl = [TiSDK getMaskIconURL];
                    folder = @"mask_icon";
                                       break;
                     case 9:
                        iconUrl = [TiSDK getGreenScreenIconURL];
                        folder = @"greenscreen_icon";
                        break;
                    
                    case 11:
                        iconUrl = [TiSDK getInteractionIconURL];
                        folder = @"interaction_icon";
                        break;
                    
                default:
                    break;
            }
            iconUrl = iconUrl?iconUrl:@"";
            [TIUITool getImageFromeURL:[NSString stringWithFormat:@"%@%@", iconUrl, subMod.thumb] WithFolder:folder downloadComplete:^(UIImage *image) {

                          [weakSelf.cellButton setTitle:nil
                                               withImage:image
                                           withTextColor:nil
                                                forState:UIControlStateNormal];

                           [weakSelf.cellButton setTitle:nil
                                               withImage:image
                                           withTextColor:nil
                                                forState:UIControlStateSelected];
                   }];
            
            switch (subMod.downloaded) {
                case TI_DOWNLOAD_STATE_CCOMPLET://完成
                    [self endAnimation];
                    [self.cellButton setDownloaded:YES];
                    
                        break;
                    case TI_DOWNLOAD_STATE_NOTBEGUN://未开始
                    
                    [self endAnimation];
                    [self.cellButton setDownloaded:NO];
                    
                        break;
                    case TI_DOWNLOAD_STATE_BEBEING://正在
                    
                      [self startAnimation];
                      [self.cellButton setDownloaded:YES];
                        break;
                default:
                    break;
            }
            
            
        }else{

            
            [self.cellButton setTitle:nil
                            withImage:[UIImage imageNamed:subMod.thumb]
                        withTextColor:nil
                             forState:UIControlStateNormal];
                                 
            [self.cellButton setTitle:nil
                            withImage:[UIImage imageNamed:subMod.thumb]
                        withTextColor:nil
                             forState:UIControlStateSelected];
            [self endAnimation];
            [self.cellButton setDownloaded:YES];
        }
        
        [self.cellButton setSelected:subMod.selected];
    }
}

-(void)startAnimation{
    [self.cellButton startAnimation];
}
-(void)endAnimation{
    [self.cellButton endAnimation]; 
}
 
@end
