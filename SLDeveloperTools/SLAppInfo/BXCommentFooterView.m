//
//  BXCommentFooterView.m
//  BXlive
//
//  Created by bxlive on 2019/5/10.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXCommentFooterView.h"
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"


@interface BXCommentFooterView ()
@property (nonatomic, strong) UIButton *countBtn;
@property (nonatomic, strong) UILabel *textLb;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BXCommentFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _countBtn = [[UIButton alloc]init];
        [_countBtn addTarget:self action:@selector(countAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_countBtn];
        [_countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(92);
            make.height.mas_equalTo(25);
        }];
        
        _textLb = [[UILabel alloc]init];
        _textLb.userInteractionEnabled = NO;
        _textLb.textColor = SubTitleColor;
        _textLb.font = [UIFont systemFontOfSize:13];
        [_countBtn addSubview:_textLb];
        [_textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.mas_equalTo(0);
        }];
        
        _imageView = [[UIImageView alloc]init];
        [_countBtn addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.textLb.mas_right).offset(4);
            make.width.mas_equalTo(9);
            make.height.mas_equalTo(7);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    return self;
}

-(void)setComment:(BXCommentModel *)comment {
    _comment = comment;
    
    if (comment.showChildCount < [comment.reply_count integerValue]) {
        _countBtn.selected = NO;
        if (comment.showChildCount > 1) {
            _textLb.text = @"展开更多回复";
        } else {
            _textLb.text = [NSString stringWithFormat:@"展开%d条回复",[comment.reply_count integerValue] - 1];
        }
        _imageView.image = CImage(@"icon_comment_openReply");
        
    } else {
        _countBtn.selected = YES;
        _textLb.text = @"收起";
        _imageView.image = CImage(@"icon_comment_closeReply");
    }
}

- (void)countAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showChildCommentWithComment:isOpen:view:)]) {
        [self.delegate showChildCommentWithComment:_comment isOpen:!_countBtn.selected view:self];
    }
}

@end
