//
//  BXDynRecommendCell.m
//  BXlive
//
//  Created by mac on 2020/7/6.
//  Copyright © 2020 cat. All rights reserved.
//

#import "BXDynRecommendCell.h"
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import <SDWebImage/SDWebImage.h>
#import "../SLMaskTools/SLMaskTools.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import "HttpMakeFriendRequest.h"
#import "BXDynFindCirlceVC.h"
#import "BXDynRollCircleCategory.h"
@interface BXDynRecommendCell()
@property(nonatomic, strong)UIImageView *titleImageLeft;
@property(nonatomic, strong)UILabel *titleLableLeft;
@property(nonatomic, strong)UILabel *numLableLeft;

@property(nonatomic, strong)UIImageView *titleImageCenter;
@property(nonatomic, strong)UILabel *titleLableCenter;
@property(nonatomic, strong)UILabel *numLableCenter;

@property(nonatomic, strong)UIImageView *titleImageRight;
@property(nonatomic, strong)UILabel *titleLableRight;
@property(nonatomic, strong)UILabel *numLableRight;
@property(nonatomic, assign)NSInteger page;
@end
@implementation BXDynRecommendCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
    }
    return self;
}
-(void)initView{
    UILabel *recommendlabel = [[UILabel alloc]init];
    recommendlabel.text = @"推荐圈子";
    recommendlabel.font = [UIFont systemFontOfSize:16];
    recommendlabel.textAlignment = 0;
    recommendlabel.textColor = UIColorHex(#8C8C8C);
    
    UILabel *changeLabel = [[UILabel alloc]init];
    changeLabel.text = @"换一批";
    changeLabel.font = [UIFont systemFontOfSize:12];
    changeLabel.textColor = UIColorHex(#8C8C8C);
    UITapGestureRecognizer *changetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAct)];
    [changeLabel addGestureRecognizer:changetap];
    changeLabel.userInteractionEnabled = YES;

    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = [UIColor grayColor];

    UILabel *alllabel = [[UILabel alloc]init];
    alllabel.text = @"全部";
    alllabel.font = [UIFont systemFontOfSize:12];
    alllabel.textColor = UIColorHex(#8C8C8C);
    UITapGestureRecognizer *alltap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AllAct)];
    [alllabel addGestureRecognizer:alltap];
    alllabel.userInteractionEnabled = YES;

    [self.contentView sd_addSubviews:@[recommendlabel, changeLabel,lineLabel,alllabel]];
    recommendlabel.sd_layout.leftSpaceToView(self.contentView, 12).topSpaceToView(self.contentView, 15).widthIs(80).heightIs(22);
    changeLabel.sd_layout.rightSpaceToView(self.contentView, 12).topEqualToView(recommendlabel).widthIs(60).heightIs(20);
    lineLabel.sd_layout.rightSpaceToView(changeLabel, 12).topEqualToView(changeLabel).widthIs(1).heightIs(20);
    alllabel.sd_layout.rightSpaceToView(lineLabel, 12).topEqualToView(changeLabel).widthIs(30).heightIs(20);

    
    UIView *backLeftView = [[UIView alloc]init];
    backLeftView.layer.cornerRadius = 5;
    backLeftView.layer.masksToBounds = YES;
    backLeftView.backgroundColor = UIColorHex(#F5F9FC);
    UITapGestureRecognizer *backlefttap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backLeftAct)];
    [backLeftView addGestureRecognizer:backlefttap];
    backLeftView.userInteractionEnabled = YES;
    
    UIView *backCenterView = [[UIView alloc]init];
    backCenterView.layer.cornerRadius = 5;
    backCenterView.layer.masksToBounds = YES;
    backCenterView.backgroundColor = UIColorHex(#F5F9FC);
    UITapGestureRecognizer *backcentertap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backCenterAct)];
    [backCenterView addGestureRecognizer:backcentertap];
    backCenterView.userInteractionEnabled = YES;
    
    UIView *backRightView = [[UIView alloc]init];
    backRightView.layer.cornerRadius = 5;
    backRightView.layer.masksToBounds = YES;
    backRightView.backgroundColor = UIColorHex(#F5F9FC);
    UITapGestureRecognizer *backrighttap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backRightAct)];
    [backRightView addGestureRecognizer:backrighttap];
    backRightView.userInteractionEnabled = YES;
    
    [self.contentView sd_addSubviews:@[backLeftView, backCenterView, backRightView]];
    backLeftView.sd_layout.leftSpaceToView(self.contentView, 12).topSpaceToView(recommendlabel, 10).widthIs(__ScaleWidth(110)).heightIs(__ScaleHeight(173));
    backCenterView.sd_layout.leftSpaceToView(backLeftView, 10).topEqualToView(backLeftView).widthIs(__ScaleWidth(110)).heightIs(__ScaleHeight(173));
    backRightView.sd_layout.leftSpaceToView(backCenterView, 10).topEqualToView(backLeftView).widthIs(__ScaleWidth(110)).heightIs(__ScaleHeight(173));
    
    [self setLeftView];
    [self setCenterView];
    [self setRightView];
    
    [backLeftView sd_addSubviews:@[_titleImageLeft, _titleLableLeft, _numLableLeft]];
    _titleImageLeft.sd_layout.topSpaceToView(backLeftView, 13).leftSpaceToView(backLeftView, 14).widthIs(__ScaleWidth(82)).heightIs(__ScaleWidth(82));
    _titleLableLeft.sd_layout.leftSpaceToView(backLeftView, 8).rightSpaceToView(backLeftView, 8).heightIs(20).topSpaceToView(_titleImageLeft, 8);
    _numLableLeft.sd_layout.leftSpaceToView(backLeftView, 8).rightSpaceToView(backLeftView, 8).heightIs(17).topSpaceToView(_titleLableLeft, 2);
    
    [backCenterView sd_addSubviews:@[_titleImageCenter, _titleLableCenter, _numLableCenter]];
    _titleImageCenter.sd_layout.topSpaceToView(backCenterView, 13).leftSpaceToView(backCenterView, 14).widthIs(__ScaleWidth(82)).heightIs(__ScaleWidth(82));
    _titleLableCenter.sd_layout.leftSpaceToView(backCenterView, 8).rightSpaceToView(backCenterView, 8).heightIs(20).topSpaceToView(_titleImageCenter, 8);
    _numLableCenter.sd_layout.leftSpaceToView(backCenterView, 8).rightSpaceToView(backCenterView, 8).heightIs(17).topSpaceToView(_titleLableCenter, 2);
    
    [backRightView sd_addSubviews:@[_titleImageRight, _titleLableRight, _numLableRight]];
    _titleImageRight.sd_layout.topSpaceToView(backRightView, 12).leftSpaceToView(backRightView, 14).widthIs(__ScaleWidth(82)).heightIs(__ScaleWidth(82));
    _titleLableRight.sd_layout.leftSpaceToView(backRightView, 8).rightSpaceToView(backRightView, 8).heightIs(20).topSpaceToView(_titleImageRight, 8);
    _numLableRight.sd_layout.leftSpaceToView(backRightView, 8).rightSpaceToView(backRightView, 8).heightIs(17).topSpaceToView(_titleLableRight, 2);
    
    UILabel *downlinelabel = [[UILabel alloc]init];
     downlinelabel.backgroundColor = [UIColor colorWithRed:0.93 green:0.96 blue:0.99 alpha:1.00];
     [self.contentView sd_addSubviews:@[downlinelabel]];
     downlinelabel.sd_layout.topSpaceToView(backRightView, 10).rightEqualToView(self.contentView).leftEqualToView(self.contentView).heightIs(8);
    
    [self setupAutoHeightWithBottomView:backRightView bottomMargin:28];

}
-(void)setModel:(BXDynCircleModel *)model{
    _model = model;


}
-(void)setArray:(NSArray *)array{
    _array = array;
    if (array.count == 3) {
          [_titleImageLeft sd_setImageWithURL:[NSURL URLWithString:[array[0] circle_cover_img]] placeholderImage:CImage(@"video-placeholder")];
          _titleLableLeft.text = [array[0] circle_name];
          _numLableLeft.text = [NSString stringWithFormat:@"%@", [array[0]  follow]];
          
          [_titleImageCenter sd_setImageWithURL:[NSURL URLWithString:[array[1] circle_cover_img]] placeholderImage:CImage(@"video-placeholder") ];
          _titleLableCenter.text = [array[1] circle_name];
          _numLableCenter.text = [NSString stringWithFormat:@"%@", [array[1]  follow]];
          
          [_titleImageRight sd_setImageWithURL:[NSURL URLWithString:[array[2] circle_cover_img]] placeholderImage:CImage(@"video-placeholder")];
          _titleLableRight.text = [array[2]  circle_name];
          _numLableRight.text = [NSString stringWithFormat:@"%@", [array[2]  follow]];
      }
    _page = 1;
}
    
-(void)backLeftAct{
    if (!self.array.count) {
        return;
    }
    BXDynRollCircleCategory *vc = [[BXDynRollCircleCategory alloc]init];
    vc.isOwn = YES;
    BXDynCircleModel *model = [[BXDynCircleModel alloc]init];
//    [model updateWithJsonDic:self.array[0]];
    model = self.array[0];
    model.isHiddenTop = YES;
    vc.model = model;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
-(void)backCenterAct{
//    if (self.DidPicIndex) {
//        self.DidPicIndex([_model.msgdetailmodel.circle_recomedArray[1]  circle_id]);
//    }
    if (self.array.count >= 2) {

    BXDynRollCircleCategory *vc = [[BXDynRollCircleCategory alloc]init];
    vc.isOwn = YES;
    BXDynCircleModel *model = [[BXDynCircleModel alloc]init];
//    [model updateWithJsonDic:self.array[1]];
    model.isHiddenTop = YES;
    model = self.array[1];
    vc.model = model;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}
-(void)backRightAct{
//    if (self.DidPicIndex) {
//        self.DidPicIndex([_model.msgdetailmodel.circle_recomedArray[2]  circle_id]);
//    }
    if (self.array.count >= 3) {

    BXDynRollCircleCategory *vc = [[BXDynRollCircleCategory alloc]init];
    vc.isOwn = YES;
    BXDynCircleModel *model = [[BXDynCircleModel alloc]init];
//    [model updateWithJsonDic:self.array[2]];
    model = self.array[2];
    model.isHiddenTop = YES;
    vc.model = model;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}
-(void)AllAct{
    BXDynFindCirlceVC *vc = [[BXDynFindCirlceVC alloc]init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
-(void)changeAct{
    _page++;
    [self getData];
}
-(void)getData{
    [HttpMakeFriendRequest CircleRecomedWithpage_index:[NSString stringWithFormat:@"%ld", (long)_page] page_size:@"3" Success:^(NSDictionary * _Nonnull jsonDic, BOOL flag, NSMutableArray * _Nonnull models) {
        if (flag) {
            NSArray *array = jsonDic[@"data"][@"data"];
            if (array && [array isArray]) {
                if (array.count >= 3) {
//                        BXDynCircleModel *model = [[BXDynCircleModel alloc]init];
                    //    [model updateWithJsonDic:self.array[2]];
                    [self getMoreArray:array];
                }else{
                    [BGProgressHUD showInfoWithMessage:@"没有更多数据了"];
                }
            }
        }else{
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } Failure:^(NSError * _Nonnull error) {
        [BGProgressHUD showInfoWithMessage:@"操作失败"];
    }];
}
-(void)getMoreArray:(NSArray *)array{
    if (array.count == 3) {
        BXDynCircleModel *model1 = [BXDynCircleModel new];
        [model1 updateWithJsonDic:array[0]];
        BXDynCircleModel *model2 = [BXDynCircleModel new];
        [model2 updateWithJsonDic:array[1]];
        BXDynCircleModel *model3 = [BXDynCircleModel new];
        [model3 updateWithJsonDic:array[2]];
        [_titleImageLeft sd_setImageWithURL:[NSURL URLWithString:model1.circle_cover_img] placeholderImage:CImage(@"video-placeholder")];
          _titleLableLeft.text = [array[0] circle_name];
        _numLableLeft.text = [NSString stringWithFormat:@"%@人", model1.follow];
          
        [_titleImageCenter sd_setImageWithURL:[NSURL URLWithString:model2.circle_cover_img] placeholderImage:CImage(@"video-placeholder") ];
          _titleLableCenter.text = [array[1] circle_name];
        _numLableCenter.text = [NSString stringWithFormat:@"%@人", model2.follow];
          
        [_titleImageRight sd_setImageWithURL:[NSURL URLWithString:model3.circle_cover_img] placeholderImage:CImage(@"video-placeholder")];
          _titleLableRight.text = [array[2]  circle_name];
        _numLableRight.text = [NSString stringWithFormat:@"%@人", model3.follow];
    }
}
-(void)setLeftView{
    _titleImageLeft = [[UIImageView alloc]init];
    _titleImageLeft.layer.cornerRadius = 5;
    _titleImageLeft.layer.masksToBounds = YES;
    
    _titleLableLeft = [[UILabel alloc]init];
    _titleLableLeft.textColor = UIColorHex(#282828);
    _titleLableLeft.textAlignment = 1;
    _titleLableLeft.font = [UIFont systemFontOfSize:14];
    
    _numLableLeft = [[UILabel alloc]init];
    _numLableLeft.textAlignment = 1;
    _numLableLeft.textColor = UIColorHex(#8C8C8C);
    _numLableLeft.font = [UIFont systemFontOfSize:12];
}
-(void)setCenterView{
    _titleImageCenter = [[UIImageView alloc]init];
    _titleImageCenter.layer.cornerRadius = 5;
    _titleImageCenter.layer.masksToBounds = YES;
    
    _titleLableCenter = [[UILabel alloc]init];
    _titleLableCenter.textColor = UIColorHex(#282828);
    _titleLableCenter.textAlignment = 1;
    _titleLableCenter.font = [UIFont systemFontOfSize:14];
    
    _numLableCenter = [[UILabel alloc]init];
    _numLableCenter.textColor = UIColorHex(#8C8C8C);
    _numLableCenter.textAlignment = 1;
    _numLableCenter.font = [UIFont systemFontOfSize:12];
}
-(void)setRightView{
    _titleImageRight = [[UIImageView alloc]init];
    _titleImageRight.layer.cornerRadius = 5;
    _titleImageRight.layer.masksToBounds = YES;
    
    _titleLableRight = [[UILabel alloc]init];
    _titleLableRight.textColor = UIColorHex(#282828);
    _titleLableRight.textAlignment = 1;
    _titleLableRight.font = [UIFont systemFontOfSize:14];
    
    _numLableRight = [[UILabel alloc]init];
    _numLableRight.textColor = UIColorHex(#8C8C8C);
    _numLableRight.textAlignment = 1;
    _numLableRight.font = [UIFont systemFontOfSize:12];
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
