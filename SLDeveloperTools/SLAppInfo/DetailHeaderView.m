//
//  DetailHeaderView.m
//  BXlive
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 cat. All rights reserved.
//

#import "DetailHeaderView.h"
#import <YYCategories/YYCategories.h>
#import "../SLCategory/SLCategory.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <SDWebImage/SDWebImage.h>
@interface DetailHeaderView()
@property(nonatomic, strong)UILabel *NotCommentLable;
@property(nonatomic, strong)UILabel *allcommentLabel;
@end
@implementation DetailHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setView];
    }
    return self;
}
-(void)setView{
    _topView = [[UIView alloc]init];
    _topView.backgroundColor = [UIColor colorWithRed:0.96 green:0.98 blue:0.99 alpha:1.00];
    _topView.layer.cornerRadius = 5;
    _topView.layer.masksToBounds = YES;
    
    _topHeaderImage = [[UIImageView alloc]init];
    _topHeaderImage.backgroundColor = [UIColor randomColor];
    _topHeaderImage.layer.cornerRadius = 5;
    _topHeaderImage.layer.masksToBounds = YES;
    
    _topTitlelable = [[UILabel alloc]init];
    _topTitlelable.backgroundColor = [UIColor randomColor];
    _topTitlelable.textAlignment = 0;
    _topTitlelable.font = [UIFont systemFontOfSize:14];
    
    _topConcentlable = [UILabel new];
    _topConcentlable.backgroundColor = [UIColor randomColor];
    _topConcentlable.textAlignment = 0;
    _topConcentlable.textColor = UIColorHex(#8C8C8C);
    _topConcentlable.font = [UIFont systemFontOfSize:12];
    
    UIImageView *rightRowImage = [[UIImageView alloc]init];
    rightRowImage.image = [UIImage imageNamed:@""];
    
    _headerImage = [[UIImageView alloc]init];
    _headerImage.backgroundColor = [UIColor randomColor];
    _headerImage.layer.cornerRadius = 20;
    
    
    _namelable = [[UILabel alloc]init];
    _namelable.font = [UIFont systemFontOfSize:14];
    _namelable.textAlignment = 0;
    _namelable.textColor = [UIColor blackColor];
    
    
    
    _genderImage = [[UIImageView alloc]init];
    _genderImage.image = [UIImage imageNamed:@"dyn_issue_gender_boy"];
    
    
    _timelable = [[UILabel alloc]init];
    _timelable.font = [UIFont systemFontOfSize:12];
    _timelable.textColor = [UIColor blackColor];
    _timelable.textAlignment = 0;

    
    _contentlable = [[BXInsetsLable alloc]init];
    _contentlable.topEdge = 3;
    _contentlable.font = [UIFont systemFontOfSize:16];
    _contentlable.numberOfLines = 0;
    
    _contentlable.textColor = [UIColor blackColor];
    
    _concenterBackview = [[UIView alloc]init];
    
    _unfoldBtn = [[UILabel alloc]init];
    _unfoldBtn.textColor = [UIColor blueColor];
    _unfoldBtn.text = @"展开";
    _unfoldBtn.font = [UIFont systemFontOfSize: 14];
    UITapGestureRecognizer *unfoldtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(unfoldAct:)];
    [_unfoldBtn addGestureRecognizer:unfoldtap];
    _unfoldBtn.userInteractionEnabled = YES;
    
    
    
    _bottomview = [[UIView alloc]init];
//    _bottomview.backgroundColor = [UIColor randomColor];
    
    
    _likeImage = [[UIImageView alloc]init];
    _likeImage.image = [UIImage imageNamed:@"dyn_issue_like"];
    UITapGestureRecognizer *liketap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeAct:)];
    [_likeImage addGestureRecognizer:liketap];
    _likeImage.userInteractionEnabled = YES;
    
    
    _likeNumlable = [[UILabel alloc]init];
    _likeNumlable.text = @"1.0w";
    _likeNumlable.font = [UIFont systemFontOfSize:12];
    
    
    UIImageView *comimage = [[UIImageView alloc]init];
    comimage.image = [UIImage imageNamed:@"dyn_issue_recommend"];
    UITapGestureRecognizer *comtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comAct:)];
    [comimage addGestureRecognizer:comtap];
    comimage.userInteractionEnabled = YES;
    
    
    _commentNumlable = [[UILabel alloc]init];
    _commentNumlable.text = @"10";
    _commentNumlable.font = [UIFont systemFontOfSize:12];
    
    
    UIImageView *shareimage = [[UIImageView alloc]init];
    shareimage.image = [UIImage imageNamed:@"dyn_issue_share"];
    UITapGestureRecognizer *sharetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareAct:)];
    [shareimage addGestureRecognizer:sharetap];
    shareimage.userInteractionEnabled = YES;
    
    
    UIImageView *moreimage = [[UIImageView alloc]init];
    moreimage.image = [UIImage imageNamed:@"dyn_issue_more"];
    UITapGestureRecognizer *moretap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreAct:)];
    [moreimage addGestureRecognizer:moretap];
    moreimage.userInteractionEnabled = YES;
    
    
    _addressimage = [[UIImageView alloc]init];
    _addressimage.image = [UIImage imageNamed:@"dyn_issue_adress"];

    
    
    _addressname = [[UILabel alloc]init];
    _addressname.font = [UIFont systemFontOfSize:12];
    
    _quanzibackview = [[UIView alloc]init];
    _quanzibackview.backgroundColor = [UIColor colorWithRed:0.96 green:0.98 blue:0.99 alpha:1.00];
    _quanzibackview.layer.cornerRadius = 10;
    _quanzibackview.layer.masksToBounds = YES;
    
    
    _quanziimage = [[UIImageView alloc]init];
    _quanziimage.image = [UIImage imageNamed:@"dyn_issue_new_quanzi"];
//    _quanziimage.backgroundColor = [UIColor randomColor];
    
    
    _quanzititle = [[UILabel alloc]init];
    _quanzititle.font = [UIFont systemFontOfSize:12];
    _quanzititle.text = @"潮服时装";
    _quanzititle.textColor = [UIColor redColor];
    
    
    _quanzigaunzhu = [[UILabel alloc]init];
    _quanzigaunzhu.font = [UIFont systemFontOfSize:12];
    _quanzigaunzhu.text = @"关注";
    _quanzigaunzhu.textAlignment = 1;
    _quanzigaunzhu.textColor = [UIColor blueColor];
    UITapGestureRecognizer *guanzhutap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(guanzhuAct)];
    [_quanzigaunzhu addGestureRecognizer:guanzhutap];
    _quanzigaunzhu.userInteractionEnabled = YES;
    
    UILabel *linelable = [[UILabel alloc]init];
    linelable.backgroundColor = [UIColor blackColor];
    
    UILabel *downLabel = [[UILabel alloc]init];
    downLabel.backgroundColor = UIColorHex(#EAEAEA);
    
    _NotCommentLable = [UILabel new];
    _NotCommentLable.text = @"暂无评论";
    _NotCommentLable.textColor = UIColorHex(#B2B2B2);
    _NotCommentLable.font = [UIFont systemFontOfSize:14];
    
    _allcommentLabel = [UILabel new];
    _allcommentLabel.text = @"所有评论";
    _allcommentLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    
    
    [self sd_addSubviews:@[self.topView, self.headerImage, self.namelable, self.genderImage, self.timelable, self.concenterBackview, self.contentlable,self.unfoldBtn, self.quanzibackview,self.addressname, self.addressimage,self.bottomview, downLabel, self.allcommentLabel, self.NotCommentLable]];
    
    _topView.sd_layout.leftSpaceToView(self, 12).topSpaceToView(self, 20).rightSpaceToView(self, 12).heightIs(62);

    [_topView sd_addSubviews:@[_topHeaderImage, _topTitlelable, _topConcentlable, rightRowImage]];

    _topHeaderImage.sd_layout.leftSpaceToView(_topView, 7).centerYEqualToView(_topView).widthIs(48).heightIs(48);
    _topTitlelable.sd_layout.leftSpaceToView(_topHeaderImage, 5).topSpaceToView(_topView, 10).rightSpaceToView(_topView, 20).heightIs(20);
    _topConcentlable.sd_layout.leftSpaceToView(_topHeaderImage, 5).topSpaceToView(_topTitlelable, 5).rightSpaceToView(_topView, 20).heightIs(17);
    rightRowImage.sd_layout.rightSpaceToView(_topView, 5).centerYEqualToView(_topView).widthIs(5).heightIs(10);
    
    _headerImage.sd_layout.leftSpaceToView(self, 12).topSpaceToView(self.topView, 20).widthIs(40).heightIs(40);
    _namelable.sd_layout.leftSpaceToView(_headerImage, 10).topEqualToView(_headerImage).widthIs(50).heightIs(20);
    _genderImage.sd_layout.leftSpaceToView(_namelable, 5).centerYEqualToView(_namelable).widthIs(10).heightIs(10);
    _timelable.sd_layout.leftSpaceToView(_headerImage, 10).topSpaceToView(_namelable, 0).widthIs(100).heightIs(20);
    _contentlable.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_headerImage, 10).rightSpaceToView(self, 90).heightIs(100);
    _unfoldBtn.sd_layout.leftEqualToView(_contentlable).topSpaceToView(_contentlable, 0).widthIs(40).heightIs(30);
    _concenterBackview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self, 12).topSpaceToView(_unfoldBtn, 5).heightIs(200);
    _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 0).widthIs(100).heightIs(20);
    _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_quanzibackview, 5).widthIs(20).heightIs(20);
    _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).widthIs(100).heightIs(20);
    _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self, 12).topSpaceToView(_addressimage, 5).heightIs(25);
    
    
    [_quanzibackview sd_addSubviews:@[_quanziimage, _quanzititle, _quanzigaunzhu, linelable]];
    _quanziimage.sd_layout.leftEqualToView(_quanzibackview).offset(5).centerYEqualToView(_quanzibackview).widthIs(15).heightIs(15);
    _quanzititle.sd_layout.leftSpaceToView(_quanziimage, 5).offset(5).centerYEqualToView(_quanzibackview).widthIs(50).heightIs(20);
    _quanzigaunzhu.sd_layout.leftSpaceToView(_quanzititle, 0).centerYEqualToView(_quanzibackview).widthIs(40).heightIs(20);
    linelable.sd_layout.leftEqualToView(_quanzigaunzhu).offset(2.5).centerYEqualToView(_quanzibackview).widthIs(1).heightIs(15);
    
    [_bottomview sd_addSubviews:@[_likeImage, _likeNumlable, comimage, _commentNumlable, shareimage, moreimage]];
    _likeImage.sd_layout.leftEqualToView(_bottomview).centerYEqualToView(_bottomview).widthIs(22).heightIs(19);
    _likeNumlable.sd_layout.leftSpaceToView(_likeImage, 5).bottomEqualToView(_bottomview).widthIs(80).heightIs(15);
    comimage.sd_layout.leftSpaceToView(_likeNumlable, 5).centerYEqualToView(_bottomview).widthIs(20).heightIs(20);
    _commentNumlable.sd_layout.leftSpaceToView(comimage, 5).bottomEqualToView(_bottomview).widthIs(80).heightIs(15);
    shareimage.sd_layout.leftSpaceToView(_commentNumlable, 5).centerYEqualToView(_bottomview).widthIs(20).heightIs(20);
    moreimage.sd_layout.rightSpaceToView(_bottomview, 0).centerYEqualToView(_bottomview).widthIs(20).heightIs(5);
    
    _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 5).widthIs(100).heightIs(20);
    _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_quanzibackview, 5).widthIs(20).heightIs(20);
    _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).widthIs(100).heightIs(20);
    _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self, 12).topSpaceToView(_addressimage, 5).heightIs(25);
    _quanzititle.sd_layout.widthIs([UILabel getWidthWithTitle:_quanzititle.text font:_quanzititle.font]);
    _quanzibackview.sd_layout.widthIs([UILabel getWidthWithTitle:_quanzititle.text font:_quanzititle.font] + 20 + 55);
    
    downLabel.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(_bottomview, 5).heightIs(1);
    
    _NotCommentLable.sd_layout.centerXEqualToView(self).topSpaceToView(downLabel, 5).heightIs(20).widthIs(60);
    _allcommentLabel.sd_layout.topSpaceToView(downLabel, 5).leftSpaceToView(self, 12).widthIs(60).heightIs(20);
    _allcommentLabel.hidden = YES;

    [self GetConcentHeight];
}
-(void)GetConcentHeight{
    [self layoutIfNeeded];
    [self.contentlable sizeToFit];
    //获取contentlable的高度
    CGFloat  textH = [self.contentlable sizeThatFits:CGSizeMake(self.contentlable.frame.size.width, MAXFLOAT)].height;
    self.contentHeight = textH;
    //获取行数
    CGFloat lineHeight = self.contentlable.font.lineHeight;
    self.lineHeight = lineHeight;
    NSInteger  lineCount = textH / lineHeight;
    if (lineCount <= 3) {
        _unfoldBtn.hidden = YES;
        
        _concenterBackview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self, 12).topSpaceToView(_contentlable, 5).heightIs(200);
        
        _contentlable.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_headerImage, 10).rightSpaceToView(self, 90).heightIs(textH);
        
    }else{
        
        _concenterBackview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self, 12).topSpaceToView(_unfoldBtn, 5).heightIs(200);
        _contentlable.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_headerImage, 10).rightSpaceToView(self, 90).heightIs(lineHeight * 3);
        _unfoldBtn.text = @"展开";
        _unfoldBtn.hidden = NO;
        
    }
}
-(void)setModel:(BXDynNewModel *)model{
    [self layoutIfNeeded];
    
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"icon_dyn_placeholder"]];
    [self GetConcentHeight];
    [self updateHeaderView];
    [self updateCenterView];
    [self updateDownView];
    self.headerheight = self.frame.size.height;
}

-(void)guanzhuAct{
//     [self.delegate DidClickType:3];
}
-(void)moreAct:(id)sender{
//     [self.delegate DidClickType:2];
}
-(void)shareAct:(id)sender{
//    [self.delegate DidClickType:1];
}
-(void)comAct:(id)sender{
    
}
-(void)likeAct:(id)sender{
//    [self.delegate DidClickType:0];
}
-(void)whispersAct:(id)sender{
    
}
-(void)imageAct:(id)sender{
    
}
-(void)unfoldAct:(UILabel *)btn{
    
}
-(void)updateHeaderView{
    
    if (_topView.hidden){
        _topView.sd_layout.leftSpaceToView(self, 12).topSpaceToView(self, 20).rightSpaceToView(self, 15).heightIs(62);
        _headerImage.sd_layout.leftSpaceToView(self, 12).topSpaceToView(self, 20).widthIs(40).heightIs(40);
    }else{
        _topView.sd_layout.leftSpaceToView(self, 12).topSpaceToView(self, 20).rightSpaceToView(self, 15).heightIs(62);
        _headerImage.sd_layout.leftSpaceToView(self, 12).topSpaceToView(self.topView, 15).widthIs(40).heightIs(40);
       
    }
}
-(void)updateCenterView{
    
}
-(void)updateDownView{

    if (_addressimage.hidden && !_quanzibackview.hidden) {
        _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 5).widthIs(100).heightIs(20);
        _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_quanzibackview, 5).widthIs(20).heightIs(20);
        _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).widthIs(100).heightIs(20);
        _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self, 12).topSpaceToView(_quanzibackview, 5).heightIs(25);
    }
    else if (!_addressimage.hidden && _quanzibackview.hidden){
        _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 5).widthIs(100).heightIs(20);
        _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 5).widthIs(20).heightIs(20);
        _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).widthIs(100).heightIs(20);
        _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self, 12).topSpaceToView(_quanzibackview, 5).heightIs(25);
    }else if(_addressimage.hidden && _quanzibackview.hidden){
        _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 0).widthIs(100).heightIs(20);
        _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 5).widthIs(20).heightIs(20);
        _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).widthIs(100).heightIs(20);
        _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self, 12).topSpaceToView(_concenterBackview, 5).heightIs(25);
    }else{
        _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 5).widthIs(100).heightIs(20);
        _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_quanzibackview, 5).widthIs(20).heightIs(20);
        _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).widthIs(100).heightIs(20);
        _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self, 12).topSpaceToView(_addressimage, 5).heightIs(25);
    }
    

    if (_quanzigaunzhu.hidden) {
        _quanzititle.sd_layout.widthIs([UILabel getWidthWithTitle:_quanzititle.text font:_quanzititle.font]);
        _quanzibackview.sd_layout.widthIs([UILabel getWidthWithTitle:_quanzititle.text font:_quanzititle.font] + 20);
    }else{
        
        _quanzititle.sd_layout.widthIs([UILabel getWidthWithTitle:_quanzititle.text font:_quanzititle.font]);
        _quanzibackview.sd_layout.widthIs([UILabel getWidthWithTitle:_quanzititle.text font:_quanzititle.font] + 20 + 55);
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
