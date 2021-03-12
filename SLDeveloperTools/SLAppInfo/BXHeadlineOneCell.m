//
//  BXHeadlineOneCell.m
//  BXlive
//
//  Created by bxlive on 2019/5/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXHeadlineOneCell.h"
#import <SLMacro.h>
#import <Masonry/Masonry.h>
#import <SLCategory.h>
#import <YYWebImage/YYWebImage.h>
@interface BXHeadlineOneCell ()

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIImageView *infoIv;
@property (nonatomic, strong) UILabel *authorLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *countLb;
@property (nonatomic, strong) UIView *whiteView;

@end

@implementation BXHeadlineOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:@"Cell"];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
//        时间
        _timeLb = [[UILabel alloc]init];
        _timeLb.textColor = sl_textSubColors;
        _timeLb.font = SLPFFont(__ScaleWidth(12));
        _timeLb.textAlignment = 1;
        [self.contentView addSubview:_timeLb];
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(__ScaleWidth(17));
            make.top.mas_equalTo(__ScaleWidth(10));
//            make..mas_equalTo(self.authorLb.mas_right).offset(5);
        }];
        
        WS(weakSelf);
        UIView *whiteView = [UIView new];
        whiteView.layer.masksToBounds = YES;
        whiteView.layer.cornerRadius = 12;
        whiteView.backgroundColor = [UIColor sl_colorWithHex:0xFFFFFF];
        [self.contentView addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(__ScaleWidth(12));
            make.right.mas_equalTo(-__ScaleWidth(12));
            make.top.equalTo(weakSelf.timeLb.mas_bottom).offset(__ScaleWidth(15));
            make.bottom.mas_equalTo(__ScaleWidth(-10));
        }];
        self.whiteView = whiteView;
        
         _infoIv = [[UIImageView alloc]init];
                _infoIv.contentMode = UIViewContentModeScaleAspectFill;
                _infoIv.layer.cornerRadius = 2;
                _infoIv.layer.masksToBounds = YES;
                [self.whiteView addSubview:_infoIv];
                [_infoIv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.mas_equalTo(0);
                    make.height.mas_equalTo(__ScaleWidth(123));
        //            make.right.mas_equalTo(-16);
        //            make.top.mas_equalTo(12);
        //            make.bottom.mas_equalTo(-12);
        //            make.width.mas_equalTo(self.infoIv.mas_height).multipliedBy(113.0 / 83);
                }];
        
        
        _titleLb = [[UILabel alloc]init];
        _titleLb.textColor = sl_textColors;
        _titleLb.font = SLBFont(__ScaleWidth(16));
        _titleLb.numberOfLines = 1;
        [self.whiteView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(__ScaleWidth(15));
            make.right.mas_equalTo(-__ScaleWidth(15));
            make.top.equalTo(weakSelf.infoIv.mas_bottom).offset(__ScaleWidth(20));
            make.height.mas_equalTo(__ScaleWidth(22));
        }];
        
        _authorLb = [[UILabel alloc]init];
        _authorLb.textColor = sl_textSubColors;
        _authorLb.numberOfLines = 0;
        _authorLb.font = SLPFFont(__ScaleWidth(14));
        [self.whiteView addSubview:_authorLb];
        [_authorLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(weakSelf.titleLb);
            make.height.mas_equalTo(__ScaleWidth(20));
            make.top.mas_equalTo(weakSelf.titleLb.mas_bottom).offset(__ScaleWidth(8));
        }];
        
//        _countLb = [[UILabel alloc]init];
//        _countLb.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
//        _countLb.textColor = sl_textSubColors;
//        _countLb.layer.cornerRadius = 6.5;
//        _countLb.layer.masksToBounds = YES;
//        _countLb.font = SLPFFont(__ScaleWidth(14));
//        _countLb.textAlignment = NSTextAlignmentCenter;
//        _countLb.adjustsFontSizeToFitWidth = YES;
//        [self.whiteView addSubview:_countLb];
//        [_countLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.mas_equalTo(weakSelf.titleLb);
//            make.top.mas_equalTo(weakSelf.titleLb.mas_bottom).offset(__ScaleWidth(8));
////            make.width.mas_equalTo(21);
////            make.height.mas_equalTo(13);
//        }];
        
       
        
        
        
        
        
        
        
//        _authorLb = [[UILabel alloc]init];
//        _authorLb.textColor = MinorColor;
//        _authorLb.font = CFont(12);
//        [self.contentView addSubview:_authorLb];
//        [_authorLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.titleLb);
//            make.height.mas_equalTo(16);
//            make.bottom.mas_equalTo(-15);
//        }];
//
        
        
//        UIView *lineView = [[UIView alloc]init];
//        lineView.backgroundColor = sl_divideLineColor;
//        [self.contentView addSubview:lineView];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.titleLb);
//            make.right.mas_equalTo(self.infoIv);
//            make.bottom.mas_equalTo(0);
//            make.height.mas_equalTo(1);
//        }];
    }
    return self;
}

- (void)setHeadline:(BXHeadline *)headline {
    _headline = headline;
    
    NSString *imageStr = nil;
    if (headline.imageList && headline.imageList.count) {
        imageStr = headline.imageList[0];
        [_infoIv yy_setImageWithURL:[NSURL URLWithString:imageStr] placeholder:CImage(@"video-placeholder")];
        [_infoIv mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(__ScaleWidth(123));
        }];
    }else{
        [_infoIv mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(__ScaleWidth(0));
        }];
    }
//    _countLb.text = [NSString stringWithFormat:@"%@图",headline.imageCount];
    _authorLb.text = headline.author;
    _timeLb.text = headline.release_time;
    
    CGFloat authorH = [UILabel getHeightByWidth:__ScaleWidth(321) title:headline.author font:SLPFFont(14)];
    [_authorLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(authorH);
    }];
    
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineSpacing = 5;
//    NSDictionary *dic = @{NSFontAttributeName:_titleLb.font, NSParagraphStyleAttributeName:paraStyle
//                          };
//    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:headline.title attributes:dic];
    _titleLb.text = headline.title;
    
//    if (headline.imageList.count) {
//        _countLb.hidden = NO;
//        [_titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(16);
//            make.right.mas_equalTo(self.infoIv.mas_left).offset(-13);
//            make.top.mas_equalTo(13);
//        }];
//    } else {
//        _countLb.hidden = YES;
//        _infoIv.hidden = YES;
//        [_titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(16);
//            make.right.mas_equalTo(self.infoIv);
//            make.top.mas_equalTo(13);
//        }];
//    }
//    _infoIv.hidden = _countLb.hidden;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
