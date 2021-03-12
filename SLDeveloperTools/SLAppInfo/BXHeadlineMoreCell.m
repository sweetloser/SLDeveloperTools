//
//  BXHeadlineMoreCell.m
//  BXlive
//
//  Created by bxlive on 2019/5/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXHeadlineMoreCell.h"
#import <YYText/YYText.h>
#import <SLMacro.h>
#import <Masonry/Masonry.h>
#import <YYWebImage/YYWebImage.h>

@interface BXHeadlineMoreCell ()

@property (nonatomic, strong) YYLabel *titleLb;
@property (nonatomic, strong) UILabel *authorLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *countLb;

@property (nonatomic, strong) NSMutableArray *infoIvs;

@end

@implementation BXHeadlineMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:@"Cell"];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _titleLb = [[YYLabel alloc]init];
        _titleLb.textColor = MainTitleColor;
        _titleLb.font = CFont(16);
        _titleLb.numberOfLines = 2;
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.top.mas_equalTo(13);
            make.height.mas_equalTo(0);
        }];
        
        _authorLb = [[UILabel alloc]init];
        _authorLb.textColor = MinorColor;
        _authorLb.font = CFont(12);
        [self.contentView addSubview:_authorLb];
        [_authorLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLb);
            make.height.mas_equalTo(16);
            make.bottom.mas_equalTo(-12);
        }];
        
        _timeLb = [[UILabel alloc]init];
        _timeLb.textColor = MinorColor;
        _timeLb.font = CFont(12);
        _timeLb.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLb];
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.titleLb);
            make.height.bottom.mas_equalTo(self.authorLb);
            make.left.mas_equalTo(self.authorLb.mas_right).offset(5);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = LineNormalColor;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.titleLb);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        CGFloat width = (__kWidth - 32 -12) / 3.0;
        _infoIvs = [NSMutableArray array];
        UIView *lastView = nil;
        for (NSInteger i = 0; i < 3; i++) {
            UIImageView *infoIv = [[UIImageView alloc]init];
            infoIv.contentMode = UIViewContentModeScaleAspectFill;
            infoIv.userInteractionEnabled = YES;
            infoIv.layer.cornerRadius = 2;
            infoIv.layer.masksToBounds = YES;
            [self.contentView addSubview:infoIv];
            [infoIv mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastView) {
                    make.left.mas_equalTo(lastView.mas_right).offset(4);
                } else {
                    make.left.mas_equalTo(16);
                }
                make.top.mas_equalTo(self.titleLb.mas_bottom).offset(9);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(infoIv.mas_width).multipliedBy(83 / 113.0);
                make.bottom.mas_equalTo(-36);
            }];
            [_infoIvs addObject:infoIv];
            lastView = infoIv;
            
            if (i == 2) {
                _countLb = [[UILabel alloc]init];
                _countLb.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
                _countLb.textColor = [UIColor whiteColor];
                _countLb.layer.cornerRadius = 6.5;
                _countLb.layer.masksToBounds = YES;
                _countLb.font = CFont(10);
                _countLb.textAlignment = NSTextAlignmentCenter;
                _countLb.adjustsFontSizeToFitWidth = YES;
                [self.contentView addSubview:_countLb];
                [_countLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(infoIv.mas_right).offset(-4);
                    make.bottom.mas_equalTo(infoIv.mas_bottom).offset(-4);
                    make.width.mas_equalTo(21);
                    make.height.mas_equalTo(13);
                }];
            }
        }
        
        
    }
    return self;
}

- (void)setHeadline:(BXHeadline *)headline {
    _headline = headline;
    
    for (NSInteger i = 0; i < 3; i++) {
        NSString *imageStr = nil;
        if (i < headline.imageList.count) {
            imageStr = headline.imageList[i];
        }
        UIImageView *infoIv = _infoIvs[i];
        [infoIv yy_setImageWithURL:[NSURL URLWithString:imageStr] placeholder:CImage(@"video-placeholder")];
    }
    
    _countLb.text = [NSString stringWithFormat:@"%@图",headline.imageCount];
    _authorLb.text = headline.author;
    _timeLb.text = headline.release_time;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 5;
    NSDictionary *dic = @{NSFontAttributeName:_titleLb.font, NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:MainTitleColor
                          };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:headline.title attributes:dic];
    _titleLb.attributedText = attributeStr;
    CGFloat height = [self getAttributedTextHeightWithAttributedText:attributeStr width:__kWidth - 32 maximumNumberOfRows:_titleLb.numberOfLines];
    [_titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (CGFloat)getAttributedTextHeightWithAttributedText:(NSAttributedString *)attributedText width:(CGFloat)width maximumNumberOfRows:(NSInteger)maximumNumberOfRows {
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    container.maximumNumberOfRows = maximumNumberOfRows;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedText];
    return layout.textBoundingSize.height;
}

@end
