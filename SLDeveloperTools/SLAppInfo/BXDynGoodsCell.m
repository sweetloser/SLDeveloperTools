//
//  BXDynGoodsCell.m
//  BXlive
//
//  Created by mac on 2020/7/4.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynGoodsCell.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <SDWebImage/SDWebImage.h>
#import "../SLMacro/SLMacro.h"
//#import "BXInsetsLable.h"
@interface BXDynGoodsCell()
@property(nonatomic, strong)UIView *backView;
@property(nonatomic, strong)UIImageView *goodsType;
@property(nonatomic, strong)UIImageView *goodsImage;
@property(nonatomic, strong)UILabel *goodsTitle;
@property(nonatomic, strong)UIImageView *goodsDiscounts;
@property(nonatomic, strong)UIImageView *goodsDiscountsShared;
@property (nonatomic, strong) UILabel *goodsPrice;

@property (nonatomic, strong) UILabel *goodsSealNum;
@end
@implementation BXDynGoodsCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
    }
    return self;
}
-(void)setView{
     
    _backView = [[UIView alloc]init];
    _backView.backgroundColor = [UIColor colorWithRed:0.96 green:0.98 blue:0.99 alpha:1.00];
    _backView.layer.cornerRadius = 8;
    _backView.layer.masksToBounds = YES;
    
    _goodsImage = [[UIImageView alloc]init];
//    _goodsImage.backgroundColor = [UIColor randomColor];
    _goodsImage.layer.cornerRadius = 8;
    _goodsImage.layer.masksToBounds = YES;
    
    _goodsType = [[UIImageView alloc]init];
    _goodsType.image = [UIImage imageNamed:@"dyn_issue_goodtype_ziying"];
//    _goodsType.backgroundColor = [UIColor randomColor];
    
    _goodsTitle = [[UILabel alloc]init];
//    _goodsTitle.backgroundColor = [UIColor randomColor];
    _goodsTitle.textColor = [UIColor blackColor];
    _goodsTitle.font = [UIFont systemFontOfSize:14];
    
    _goodsDiscounts = [[UIImageView alloc]init];
//    _goodsDiscounts.backgroundColor = [UIColor randomColor];

    _goodsDiscountsShared = [[UIImageView alloc]init];
//    _goodsDiscountsShared.backgroundColor = [UIColor randomColor];
    
    UIImageView *imagePrice = [[UIImageView alloc]init];
//    imagePrice.backgroundColor = [UIColor randomColor];
    
    _goodsPrice = [[UILabel alloc]init];
    _goodsPrice.textColor = [UIColor redColor];
//    _goodsPrice.backgroundColor = [UIColor randomColor];
    _goodsPrice.textAlignment = 0;
    _goodsPrice.font = [UIFont systemFontOfSize:15];
    
    _goodsSealNum = [[UILabel alloc]init];
    _goodsSealNum.textColor = [UIColor redColor];
//    _goodsSealNum.backgroundColor = [UIColor randomColor];
    _goodsSealNum.font = [UIFont systemFontOfSize:10];
    
    self.concenterBackview.sd_layout.heightIs(110);
    [self.concenterBackview sd_addSubviews:@[self.backView]];
    self.backView.sd_layout.leftEqualToView(self.concenterBackview).topEqualToView(self.concenterBackview).rightEqualToView(self.concenterBackview).bottomSpaceToView(self.concenterBackview, 0);
    
    [self.backView sd_addSubviews:@[self.goodsImage, self.goodsTitle, self.goodsDiscounts, self.goodsDiscountsShared, imagePrice, self.goodsPrice, self.goodsSealNum]];
    self.goodsImage.sd_layout.leftSpaceToView(self.backView, 10).topSpaceToView(self.backView, 10).widthIs(90).heightIs(90);
    self.goodsTitle.sd_layout.leftSpaceToView(self.goodsImage, 5).topEqualToView(self.goodsImage).rightSpaceToView(self.backView, 10).heightIs(30);
    [self.goodsTitle sd_addSubviews:@[self.goodsType]];
    self.goodsType.sd_layout.leftEqualToView(self.goodsTitle).topSpaceToView(self.goodsTitle, 0).heightIs(15).widthIs(25);
    
    self.goodsDiscounts.sd_layout.leftEqualToView(self.goodsTitle).topSpaceToView(self.goodsTitle, 5).widthIs(40).heightIs(20);
    self.goodsDiscountsShared.sd_layout.leftSpaceToView(self.goodsDiscounts, 10).topSpaceToView(self.goodsTitle, 5).widthIs(40).heightIs(20);
    
    imagePrice.sd_layout.leftEqualToView(self.goodsTitle).bottomSpaceToView(self.backView, 10).widthIs(10).heightIs(15);
    self.goodsPrice.sd_layout.leftSpaceToView(imagePrice, 5).centerYEqualToView(imagePrice).widthIs(100).heightIs(20);
    
    self.goodsSealNum.sd_layout.rightEqualToView(self.goodsTitle).centerYEqualToView(self.goodsPrice).widthIs(60).heightIs(20);

}
-(void)updateCenterView{
    self.concenterBackview.sd_layout.heightIs(100);
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:self.model.msgdetailmodel.picture[0]] placeholderImage:CImage(@"video-placeholder")];
//    _goodsTitle.text = self.model.msgdetailmodel.sysModel.title;
    [self FirstLineIndent:self.model.msgdetailmodel.sysModel.title];
    _goodsPrice.text = [NSString stringWithFormat:@"%@", self.model.msgdetailmodel.sysModel.price];
    _goodsSealNum.text = [NSString stringWithFormat:@"%@", self.model.msgdetailmodel.sysModel.comfrom];

}

-(void)FirstLineIndent:(NSString *)updateStr{
    NSMutableAttributedString *attrStr0 = [[NSMutableAttributedString alloc] initWithString:updateStr];
    [attrStr0 addAttribute:NSForegroundColorAttributeName
                     value:[UIColor grayColor]
                     range:NSMakeRange(0, updateStr.length)];
    [attrStr0 addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, updateStr.length)];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 5;// 字体的行间距
    paragraph.firstLineHeadIndent = 30.0f;//首行缩进
    paragraph.alignment = NSTextAlignmentLeft;
    
    [attrStr0 addAttribute:NSParagraphStyleAttributeName
                     value:paragraph
                     range:NSMakeRange(0, [updateStr length])];
    
    //自动换行
    _goodsTitle.numberOfLines = 0;
    //设置label的富文本
    _goodsTitle.attributedText = attrStr0;
    //label高度自适应
    [_goodsTitle sizeToFit];
}

@end
