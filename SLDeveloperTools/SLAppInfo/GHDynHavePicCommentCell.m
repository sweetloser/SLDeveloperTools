//
//  GHDynHavePicCommentCell.m
//  BXlive
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 cat. All rights reserved.
//

#import "GHDynHavePicCommentCell.h"
#import "DetailSendcomCollectionViewCell.h"
#import <YYCategories/YYCategories.h>
#import <YYText/YYText.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLMacro/SLMacro.h"
#import "../SLUtilities/SLUtilities.h"

@interface GHDynHavePicCommentCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** 昵称 */
//@property (strong, nonatomic) YYLabel *nickNameLabel;
@property (nonatomic , strong) UIButton * nickNameBtn;

/** 回复昵称按钮 */
@property (nonatomic , strong) UIButton * replyNickNameBtn;
/** 内容 */
@property (strong, nonatomic) YYLabel *contentLabel;

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * commentReplyArray;

@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *PicArray;

@end
@implementation GHDynHavePicCommentCell
-(NSMutableArray *)commentReplyArray{
    if(!_commentReplyArray){
        _commentReplyArray = [NSMutableArray array];
    }
    return _commentReplyArray;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}
- (void)createUI
{


    //内容
    self.contentLabel = [[YYLabel alloc]init];
    self.contentLabel.clearContentsBeforeAsynchronouslyDisplay = NO;
    UIEdgeInsets textContainerInset = self.contentLabel.textContainerInset;
    textContainerInset.top = 0;
    textContainerInset.bottom = 0;
    self.contentLabel.textContainerInset = textContainerInset;
    self.contentLabel.numberOfLines = 0 ;
    self.contentLabel.font = CFont(14);
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.sd_layout.leftSpaceToView(self.contentView, 60).topSpaceToView(self.contentView, 4).heightIs(20).rightSpaceToView(self.contentView, 60);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[DetailSendcomCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.contentView addSubview:self.collectionView];
    self.collectionView.sd_layout.leftSpaceToView(self.contentView, 60).topSpaceToView(self.contentLabel, 5).heightIs(70).rightSpaceToView(self.contentView, 60);

    
}

-(void)setModel:(BXDynCommentModel *)model{
    [self.contentView layoutIfNeeded];
    _model = model;
//    if (model.is_anchor) {
//
//        self.contentLabel.text = model.content;
//    }
//    else{
//        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text];
//
//        [att addAttribute:NSForegroundColorAttributeName value:UIColorHex(#91B8F4) range:[self.contentLabel.text rangeOfString:model.reply_nickname]];
//        [att addAttribute:@"name" value:@"name" range:[self.contentLabel.text rangeOfString:model.reply_nickname]];
//
//        self.contentLabel.text = [NSString stringWithFormat:@"%@:%@", model.reply_nickname, model.content];
//    }
    [self.contentLabel sizeToFit];
    CGFloat  textH = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)].height;
    //    CGFloat lineHeight = self.contentLabel.font.lineHeight;
    
    float nickNameWidth = [BXCalculate calculateRowWidth:self.nickNameBtn.titleLabel.text Font:CFont(13)];
    if (nickNameWidth > 195) {
        nickNameWidth = 195;
    } else if (__kWidth <= 320) {
        if (nickNameWidth > 130) {
            nickNameWidth = 130;
        }
    }
    self.nickNameBtn.sd_layout.widthIs(nickNameWidth);
    
//    self.contentLabel.attributedText = model.attatties;
    self.contentLabel.sd_layout.heightIs(textH);
    [self setupAutoHeightWithBottomView:self.collectionView bottomMargin:10];
}

- (void)setColorType:(NSInteger)colorType {
    if (colorType) {
        [self.nickNameBtn setTitleColor:CHHCOLOR_D(0x4A4F4F) forState:BtnNormal];
    } else {
        [self.nickNameBtn setTitleColor:UIColorHex(A8AFAF) forState:BtnNormal];
    }
}

#pragma mark - 点击头像和昵称跳转个人主页
- (void)avatarOrNicknameDidClicked
{
//    if (self.toPersonHome) {
//        self.toPersonHome();
//    }
}
#pragma mark - UICollectionViewDelegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.PicArray.count) {
        return 0;
    }
    return self.PicArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailSendcomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.picImage.image = _PicArray[indexPath.row];
    cell.type = @"1";
//    cell.backgroundColor = [UIColor redColor];

    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        if (self.didPicture) {
            self.didPicture(indexPath.row);
        }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    return CGSizeMake(69, 69);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
   
        return 0;
 
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

        return 12;

}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 12, 0, 0);
}

@end
