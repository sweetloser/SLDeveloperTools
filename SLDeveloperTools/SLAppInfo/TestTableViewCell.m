//
//  TestTableViewCell.m
//  BXlive
//
//  Created by mac on 2020/7/2.
//  Copyright © 2020 cat. All rights reserved.
//

#import "TestTableViewCell.h"
#import "BXInsetsLable.h"
#import "GongGeView.h"
#import "../SLCategory/SLCategory.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLMacro/SLMacro.h"

@interface TestTableViewCell()
@property(nonatomic, strong)GongGeView *ggImageView;
@property(nonatomic, strong)UIImageView *headerImage;
@property(nonatomic, strong)UIImageView *whispersImage;
@property(nonatomic, strong)UIImageView *genderImage;
@property(nonatomic, strong)UILabel *namelable;
@property(nonatomic, strong)UILabel *timelable;
@property(nonatomic, strong)BXInsetsLable *contentlable;
@property(nonatomic, strong)UIView *concenterBackview;
@property(nonatomic, strong)UIView *unfoldBtnbackview;
@property(nonatomic, strong)UILabel *unfoldBtn;

@property(nonatomic, strong)UIImageView *themeImage;

@property(nonatomic, strong)UIImageView *addressimage;
@property(nonatomic, strong)UILabel *addressname;

@property(nonatomic, strong)UIView *quanzibackview;
@property(nonatomic, strong)UIImageView *quanziimage;
@property(nonatomic, strong)UILabel *quanzititle;
@property(nonatomic, strong)UILabel *quanzigaunzhu;

@property(nonatomic, strong)UIView *bottomview;
@property(nonatomic, strong)UIImageView *likeImage;
@property(nonatomic, strong)UILabel *likeNumlable;
@property(nonatomic, strong)UILabel *commentNumlable;

@property(nonatomic, assign)CGFloat contentHeight;
@property(nonatomic, assign)CGFloat lineHeight;




@end
@implementation TestTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView{

    _headerImage = [[UIImageView alloc]init];
    _headerImage.backgroundColor = [UIColor randomColor];
    _headerImage.layer.cornerRadius = 20;

  
    _namelable = [[UILabel alloc]init];
    _namelable.font = [UIFont systemFontOfSize:14];
    _namelable.textAlignment = 0;
    _namelable.textColor = [UIColor blackColor];



    _genderImage = [[UIImageView alloc]init];
    _genderImage.backgroundColor = [UIColor randomColor];
    _genderImage.image = [UIImage imageNamed:@""];


    _timelable = [[UILabel alloc]init];
    _timelable.font = [UIFont systemFontOfSize:12];
    _timelable.textColor = [UIColor blackColor];
    _timelable.textAlignment = 0;

    _whispersImage = [[UIImageView alloc]init];
    _whispersImage.image = [UIImage imageNamed:@""];
    _whispersImage.backgroundColor = [UIColor randomColor];
    UITapGestureRecognizer *whisperstap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whispersAct:)];
    [_whispersImage addGestureRecognizer:whisperstap];
    _whispersImage.userInteractionEnabled = YES;


    _contentlable = [[BXInsetsLable alloc]init];
    _contentlable.topEdge = 3;
//    _contentlable.textInsets = UIEdgeInsetsMake(3, 0, 0, 0);
    _contentlable.font = [UIFont systemFontOfSize:16];
    _contentlable.numberOfLines = 0;
    
    _contentlable.textColor = [UIColor blackColor];

    _concenterBackview = [[UIView alloc]init];
    _concenterBackview.backgroundColor = [UIColor randomColor];

    _unfoldBtn = [[UILabel alloc]init];
    _unfoldBtn.textColor = [UIColor blueColor];
    _unfoldBtn.text = @"展开";
    _unfoldBtn.font = [UIFont systemFontOfSize: 14];
    UITapGestureRecognizer *unfoldtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(unfoldAct:)];
    [_unfoldBtn addGestureRecognizer:unfoldtap];
    _unfoldBtn.userInteractionEnabled = YES;

    
    _themeImage = [[UIImageView alloc]init];
    _themeImage.backgroundColor = [UIColor randomColor];
    _themeImage.layer.cornerRadius = 7;
    _themeImage.layer.masksToBounds = YES;
    UITapGestureRecognizer *themetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageAct:)];
    [_themeImage addGestureRecognizer:themetap];
    _themeImage.userInteractionEnabled = YES;

    _bottomview = [[UIView alloc]init];
    _bottomview.backgroundColor = [UIColor randomColor];

    
    _likeImage = [[UIImageView alloc]init];
    _likeImage.backgroundColor = [UIColor randomColor];
    UITapGestureRecognizer *liketap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeAct:)];
    [_likeImage addGestureRecognizer:liketap];
    _likeImage.userInteractionEnabled = YES;

    
    _likeNumlable = [[UILabel alloc]init];
    _likeNumlable.textAlignment = 0;
    _likeNumlable.font = [UIFont systemFontOfSize:12];

    
    UIImageView *comimage = [[UIImageView alloc]init];
    comimage.image = [UIImage imageNamed:@""];
    comimage.backgroundColor = [UIColor randomColor];
    UITapGestureRecognizer *comtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comAct:)];
    [comimage addGestureRecognizer:comtap];
    comimage.userInteractionEnabled = YES;

    
    _commentNumlable = [[UILabel alloc]init];
    _commentNumlable.textAlignment = 0;
    _commentNumlable.font = [UIFont systemFontOfSize:12];

    
    UIImageView *shareimage = [[UIImageView alloc]init];
    shareimage.image = [UIImage imageNamed:@""];
    shareimage.backgroundColor = [UIColor randomColor];
    UITapGestureRecognizer *sharetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareAct:)];
    [shareimage addGestureRecognizer:sharetap];
    shareimage.userInteractionEnabled = YES;

    
    UIImageView *moreimage = [[UIImageView alloc]init];
    moreimage.image = [UIImage imageNamed:@""];
    moreimage.backgroundColor = [UIColor randomColor];
    UITapGestureRecognizer *moretap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreAct:)];
    [moreimage addGestureRecognizer:moretap];
    moreimage.userInteractionEnabled = YES;

    
    _addressimage = [[UIImageView alloc]init];
    _addressimage.image = [UIImage imageNamed:@""];
    _addressimage.backgroundColor = [UIColor randomColor];

    
    _addressname = [[UILabel alloc]init];
    _addressname.font = [UIFont systemFontOfSize:12];

    _quanzibackview = [[UIView alloc]init];
    _quanzibackview.backgroundColor = [UIColor colorWithRed:0.96 green:0.98 blue:0.99 alpha:1.00];
    _quanzibackview.layer.cornerRadius = 10;
    _quanzibackview.layer.masksToBounds = YES;

    
    _quanziimage = [[UIImageView alloc]init];
    _quanziimage.image = [UIImage imageNamed:@""];
    _quanziimage.backgroundColor = [UIColor randomColor];

    
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

    
    [self.contentView sd_addSubviews:@[self.headerImage, self.namelable, self.genderImage, self.timelable, self.whispersImage, self.concenterBackview, self.contentlable,self.unfoldBtn, self.quanzibackview,self.addressname, self.addressimage,self.bottomview]];
    self.headerImage.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).widthIs(self.contentView.frame.size.width).heightIs(self.contentView.frame.size.height);

    _headerImage.sd_layout.leftSpaceToView(self.contentView, 12).topSpaceToView(self.contentView, 20).widthIs(40).heightIs(40);
    _namelable.sd_layout.leftSpaceToView(_headerImage, 10).topEqualToView(_headerImage).widthIs(50).heightIs(20);
    _genderImage.sd_layout.leftSpaceToView(_namelable, 5).centerYEqualToView(_namelable).widthIs(10).heightIs(10);
    _timelable.sd_layout.leftSpaceToView(_headerImage, 10).topSpaceToView(_namelable, 0).widthIs(100).heightIs(20);
    _whispersImage.sd_layout.rightSpaceToView(self.contentView, 12).centerYEqualToView(_headerImage).widthIs(80).heightIs(30);
    _contentlable.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_headerImage, 10).rightEqualToView(_whispersImage).heightIs(100);
    _unfoldBtn.sd_layout.leftEqualToView(_contentlable).topSpaceToView(_contentlable, 0).widthIs(40).heightIs(30);
    _concenterBackview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self.contentView, 12).topSpaceToView(_unfoldBtn, 5).heightIs(200);
    _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 0).widthIs(100).heightIs(20);
    _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_quanzibackview, 5).widthIs(20).heightIs(20);
    _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).widthIs(100).heightIs(20);
    _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self.contentView, 12).topSpaceToView(_addressimage, 5).heightIs(30);
   
        _ggImageView = [[GongGeView alloc]init];
        [_ggImageView begainLayImage];
        [self.concenterBackview sd_addSubviews:@[_ggImageView]];
        _ggImageView.sd_layout.leftEqualToView(self.concenterBackview).topEqualToView(self.concenterBackview).rightSpaceToView(self.concenterBackview, 0).bottomSpaceToView(self.concenterBackview, 0);
 

    [_quanzibackview sd_addSubviews:@[_quanziimage, _quanzititle, _quanzigaunzhu, linelable]];
    _quanziimage.sd_layout.leftEqualToView(_quanzibackview).offset(5).centerYEqualToView(_quanzibackview).widthIs(15).heightIs(15);
    _quanzititle.sd_layout.leftSpaceToView(_quanziimage, 5).offset(5).centerYEqualToView(_quanzibackview).widthIs(50).heightIs(20);
    _quanzigaunzhu.sd_layout.leftSpaceToView(_quanzititle, 0).centerYEqualToView(_quanzibackview).widthIs(35).heightIs(20);
    linelable.sd_layout.leftEqualToView(_quanzigaunzhu).offset(2.5).centerYEqualToView(_quanzibackview).widthIs(1).heightIs(15);
    
    [_bottomview sd_addSubviews:@[_likeImage, _likeNumlable, comimage, _commentNumlable, shareimage, moreimage]];
    _likeImage.sd_layout.leftEqualToView(_bottomview).centerYEqualToView(_bottomview).widthIs(20).heightIs(20);
    _likeNumlable.sd_layout.leftSpaceToView(_likeImage, 5).bottomEqualToView(_bottomview).widthIs(80).heightIs(15);
    comimage.sd_layout.leftSpaceToView(_likeNumlable, 5).centerYEqualToView(_bottomview).widthIs(20).heightIs(20);
    _commentNumlable.sd_layout.leftSpaceToView(comimage, 5).bottomEqualToView(_bottomview).widthIs(80).heightIs(15);
    shareimage.sd_layout.leftSpaceToView(_commentNumlable, 5).centerYEqualToView(_bottomview).widthIs(20).heightIs(20);
    moreimage.sd_layout.rightSpaceToView(_bottomview, 0).centerYEqualToView(_bottomview).widthIs(60).heightIs(20);

}
-(void)layoutSubviews{
    
}
-(void)setModel:(BXDynNewModel *)model{
    [self.contentView layoutIfNeeded];

    _model = model;
    _ggImageView.imageArray = _model.ImageArray;
    _ggImageView.block = ^(NSInteger tag) {
        NSLog(@"%ld", (long)tag);
    };
    _namelable.text = @"潮服时装";

     _namelable.sd_layout.leftSpaceToView(_headerImage, 10).topEqualToView(_headerImage).widthIs([UILabel getWidthWithTitle:_namelable.text font:_namelable.font]).heightIs(20);
    _timelable.text = @"20分钟前";
    _contentlable.text = @"122333129172313797189287912879127春风式还是地位3/n81782/n3871278937178973879127春风式还是地位3/n81782/n3871278937178293879128973879127春风式还是地位低是不微博对我的";
    
    _addressname.text = @"安徽合肥市";
    _likeNumlable.text = @"2321";
    _commentNumlable.text = @"23";
    
    _quanzititle.text = @"潮服时装";
    
    
    [_contentlable sizeToFit];
    //获取contentlable的高度
    CGFloat  textH = [_contentlable sizeThatFits:CGSizeMake(_contentlable.frame.size.width, MAXFLOAT)].height;
    _contentHeight = textH;
    //获取行数
    CGFloat lineHeight = _contentlable.font.lineHeight;
    _lineHeight = lineHeight;
    NSInteger  lineCount = textH / lineHeight;

    
    if (lineCount <= 3) {
        self.unfoldBtn.hidden = YES;
        self.contentlable.sd_layout.leftEqualToView(self.headerImage).topSpaceToView(self.headerImage, 10).rightSpaceToView(self.whispersImage, 0).heightIs(textH);

        if (self.model.ImageArray.count <= 3) {
            self.concenterBackview.sd_layout.leftEqualToView(self.headerImage).rightSpaceToView(self.contentView, 12).topSpaceToView(self.contentlable, 5).heightIs((__ScaleWidth(375) - 48) / 3 );
        }else if ( self.model.ImageArray.count <= 6){
             self.concenterBackview.sd_layout.leftEqualToView(self.headerImage).rightSpaceToView(self.contentView, 12).topSpaceToView(self.contentlable, 5).heightIs((__ScaleWidth(375) - 48) / 3 * 2 + 12);
        }else{
             self.concenterBackview.sd_layout.leftEqualToView(self.headerImage).rightSpaceToView(self.contentView, 12).topSpaceToView(self.contentlable, 5).heightIs((__ScaleWidth(375) - 48) + 24 );
        }

    }else{
        self.contentlable.sd_layout.leftEqualToView(self.headerImage).topSpaceToView(self.headerImage, 10).rightSpaceToView(self.whispersImage, 0).heightIs(lineHeight * 3);
        if (self.model.ImageArray.count <= 3) {
            self.concenterBackview.sd_layout.leftEqualToView(self.headerImage).rightSpaceToView(self.contentView, 12).topSpaceToView(self.unfoldBtn, 5).heightIs((__ScaleWidth(375) - 48) / 3 );
        }else if ( self.model.ImageArray.count <= 6){
             self.concenterBackview.sd_layout.leftEqualToView(self.headerImage).rightSpaceToView(self.contentView, 12).topSpaceToView(self.unfoldBtn, 5).heightIs((__ScaleWidth(375) - 48) / 3 * 2 + 12);

        }else{
             self.concenterBackview.sd_layout.leftEqualToView(self.headerImage).rightSpaceToView(self.contentView, 12).topSpaceToView(self.unfoldBtn, 5).heightIs((__ScaleWidth(375) - 48) + 24);
        }

        self.unfoldBtn.hidden = NO;

    }

    
    [self updateView];
    
    [self setupAutoHeightWithBottomView:self.bottomview bottomMargin:10];
    [self updateLayout];

}

-(void)guanzhuAct{
    
}
-(void)moreAct:(UIImageView *)imagebtn{
    
}
-(void)shareAct:(UIImageView *)imagebtn{
    
}
-(void)comAct:(UIImageView *)imagebtn{
    
}
-(void)likeAct:(UIImageView *)imagebtn{
    
}
-(void)whispersAct:(UIImageView *)imagebtn{
    
}
-(void)imageAct:(UIImageView *)imagebtn{
    
}
-(void)unfoldAct:(UILabel *)btn{
    if (_unfoldflag) {
       _contentlable.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_headerImage, 10).rightSpaceToView(_whispersImage, 0).heightIs(_lineHeight * 3);


        _unfoldBtn.text = @"展开";
        _unfoldflag = NO;


    }else{
        _contentlable.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_headerImage, 10).rightSpaceToView(_whispersImage, 0).heightIs(_contentHeight);

        _unfoldBtn.text = @"收起";
        _unfoldflag = YES;


    }
//    [self.delegate didClickUnfoldInCell:self ];


}

-(void)updateView{

    if (_addressimage.hidden && !_quanzibackview.hidden) {
        _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 0).widthIs(100).heightIs(20);
        _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_quanzibackview, 5).widthIs(20).heightIs(20);
        _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).widthIs(100).heightIs(20);
        _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self.contentView, 12).topSpaceToView(_quanzibackview, 5).heightIs(25);
    }
    else if (!_addressimage.hidden && _quanzibackview.hidden){
        _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 5).widthIs(100).heightIs(20);
        _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 5).widthIs(20).heightIs(20);
        _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).widthIs(100).heightIs(20);
        _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self.contentView, 12).topSpaceToView(_quanzibackview, 5).heightIs(25);
    }else if(_addressimage.hidden && _quanzibackview.hidden){
        _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 5).widthIs(100).heightIs(20);
        _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 5).widthIs(20).heightIs(20);
        _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).widthIs(100).heightIs(20);
        _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self.contentView, 12).topSpaceToView(_concenterBackview, 5).heightIs(25);
    }else{
        _quanzibackview.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_concenterBackview, 5).widthIs(100).heightIs(20);
        _addressimage.sd_layout.leftEqualToView(_headerImage).topSpaceToView(_quanzibackview, 5).widthIs(20).heightIs(20);
        _addressname.sd_layout.leftSpaceToView(_addressimage, 5).centerYEqualToView(_addressimage).widthIs(100).heightIs(20);
        _bottomview.sd_layout.leftEqualToView(_headerImage).rightSpaceToView(self.contentView, 12).topSpaceToView(_addressimage, 5).heightIs(25);
    }
    

    if (_quanzigaunzhu.hidden) {
        _quanzititle.sd_layout.widthIs([UILabel getWidthWithTitle:_quanzititle.text font:_quanzititle.font]);
        _quanzibackview.sd_layout.widthIs([UILabel getWidthWithTitle:_quanzititle.text font:_quanzititle.font] + 20);
    }else{
        
        _quanzititle.sd_layout.widthIs([UILabel getWidthWithTitle:_quanzititle.text font:_quanzititle.font]);
        _quanzibackview.sd_layout.widthIs([UILabel getWidthWithTitle:_quanzititle.text font:_quanzititle.font] + 20 + 55);
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
