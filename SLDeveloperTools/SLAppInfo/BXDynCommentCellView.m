//
//  BXDynCommentView.m
//  BXlive
//
//  Created by mac on 2020/7/6.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynCommentCellView.h"
#import <Aspects/Aspects.h>
#import <YYText/YYText.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"


@interface BXDynCommentCellView()
@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) NSArray *commentItemsArray;
@property (nonatomic, strong) NSMutableArray *commentLabelsArray;
@property (nonatomic, strong) UIView *likeLableBottomLine;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@end

@implementation BXDynCommentCellView



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = PageSubBackgroundColor;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _likeLabel = [UILabel new];
    _likeLabel.font = [UIFont systemFontOfSize:12];
    _likeLabel.isAttributedContent = YES;
    _likeLabel.textColor = SubTitleColor;
    [self addSubview:_likeLabel];
    
    _likeLableBottomLine = [UIView new];
    _likeLableBottomLine.backgroundColor = LineDeeplColor;
    [self addSubview:_likeLableBottomLine];
    
    
    _likeLabel.sd_layout
    .leftSpaceToView(self, 12)
    .rightSpaceToView(self, 12)
    .topSpaceToView(self, 8)
    .heightIs(15);
    
    _likeLableBottomLine.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1)
    .topSpaceToView(_likeLabel, 8);
    
    
    
    self.commentBtn = [UIButton buttonWithFrame:CGRectZero Title:@"添加评论…" Font:CFont(14) Color:MinorColor Image:CImage(@"xiaoshipin_icon_quxiaoguanzhu") Target:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.commentBtn];
    
    self.commentBtn.sd_layout.leftSpaceToView(self, 12).bottomSpaceToView(self, 0).heightIs(34).rightSpaceToView(self, 12);
    self.commentBtn.imageView.sd_layout.leftSpaceToView(self.commentBtn, 0).widthIs(15).heightIs(14).centerYEqualToView(self.commentBtn); self.commentBtn.titleLabel.sd_layout.leftSpaceToView(self.commentBtn.imageView, 5).centerYEqualToView(self.commentBtn).heightIs(19).rightSpaceToView(self.commentBtn, 0);
    
    
    self.moreBtn = [UIButton buttonWithFrame:CGRectZero Title:@"查看全部0条评论" Font:CBFont(14) Color:SubTitleColor Image:nil Target:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.moreBtn];
    
    self.moreBtn.sd_layout.leftSpaceToView(self, 12).bottomSpaceToView(self.commentBtn, 0).heightIs(24).rightSpaceToView(self, 12);
    self.moreBtn.imageView.sd_layout.leftSpaceToView(self.moreBtn, 0).widthIs(0).heightIs(0).centerYEqualToView(self.moreBtn); self.moreBtn.titleLabel.sd_layout.leftSpaceToView(self.moreBtn.imageView, 0).centerYEqualToView(self.moreBtn).heightIs(16).rightSpaceToView(self.moreBtn, 0);
    
    self.moreBtn.hidden = YES;

    
}
-(void)commentBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(didClickcCommentButtonInView)]) {
        [self.delegate didClickcCommentButtonInView];
    }
}
-(void)moreBtnClick{
    if ([self.delegate respondsToSelector:@selector(didClickMoreButtonInView)]) {
        [self.delegate didClickMoreButtonInView];
    }
}

- (void)setCommentItemsArray:(NSArray *)commentItemsArray
{
    _commentItemsArray = commentItemsArray;
    for (int i = 0; i < commentItemsArray.count; i++) {
        if (i<2) {
            YYLabel  *label = [[YYLabel alloc] init];
            UIEdgeInsets textContainerInset = label.textContainerInset;
            label.clearContentsBeforeAsynchronouslyDisplay = NO;
            textContainerInset.top = 0;
            textContainerInset.bottom = 0;
            label.textContainerInset = textContainerInset;
            label.numberOfLines = 0 ;
            label.font = CFont(15);
            label.textAlignment = NSTextAlignmentLeft;
            label.tag = i;
            [self addSubview:label];
            [self.commentLabelsArray addObject:label];
        
        }
    }
    
    for (int i = 0; i < commentItemsArray.count; i++) {
        if (i<2) {
            BXCommentModel *model = commentItemsArray[i];
            YYLabel *label = self.commentLabelsArray[i];
            label.attributedText = model.attentionAttatties;
        }
    }
}


- (NSMutableArray *)commentLabelsArray
{
    if (!_commentLabelsArray) {
        _commentLabelsArray = [NSMutableArray new];
    }
    return _commentLabelsArray;
}

- (void)setupWithLikeItemsCount:(NSInteger )likeItemsCount commentCount:(NSInteger)commentCount commentItemsArray:(NSArray *)commentItemsArray
{
    self.commentItemsArray = commentItemsArray;
    
    if (self.commentLabelsArray.count) {
        [self.commentLabelsArray enumerateObjectsUsingBlock:^(YYLabel *label, NSUInteger idx, BOOL *stop) {
            [label sd_clearAutoLayoutSettings];
            label.hidden = YES; //重用时先隐藏所以评论label，然后根据评论个数显示label
        }];
    }
    _likeLabel.text = [NSString stringWithFormat:@"%ld人赞过",(long)likeItemsCount];

    UIView *lastView = _likeLableBottomLine;
    CGFloat height = 0;
    for (int i = 0; i < self.commentItemsArray.count; i++) {
        if (i<2) {
            BXCommentModel *model = self.commentItemsArray[i];
            YYLabel *label = (YYLabel *)self.commentLabelsArray[i];
            label.hidden = NO;
            label.sd_layout
            .leftSpaceToView(self, 12)
            .rightSpaceToView(self, 12)
            .topSpaceToView(lastView,6)
            .heightIs(model.attentionHight);
            lastView = label;
            height += model.attentionHight + (i>0?10:6);
        }
    }
    if (self.commentItemsArray.count<=2) {
        self.fixedHeight = @(32+34+height);
        self.moreBtn.hidden = YES;
    }else{
        self.moreBtn.hidden = NO;
        [self.moreBtn setTitle:[NSString stringWithFormat:@"查看全部%ld条评论",(long)commentCount] forState:BtnNormal];
        self.fixedHeight = @(32+34+24+height);
    }

}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    for (YYLabel *label in self.commentLabelsArray) {
        if (CGRectContainsPoint(label.frame, point)) {
             BXCommentModel *model = self.commentItemsArray[label.tag];
            if ([self.delegate respondsToSelector:@selector(didClickSelfInView:)]) {
                [self.delegate didClickSelfInView:model];
            }
            break;
        }
    }
    
}


@end
