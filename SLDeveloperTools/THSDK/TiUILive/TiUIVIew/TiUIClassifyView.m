//
//  TiUIClassifyView.m
//  TiFancy
//
//  Created by iMacA1002 on 2020/4/26.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TiUIClassifyView.h"
#import "TIConfig.h"
#import "TIButton.h"


#define MINIMUMLINESPACING  (SCREEN_WIDTH - 5*TiUISubMenuOneViewTIButtonWidth)/6

@interface TiUIClassifyView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) NSArray *modArr;

@property(nonatomic,strong) UICollectionView *classifyMenuView;

@end

@implementation TiUIClassifyView
static NSString *const TiUIClassifyViewCellId = @"TiUIClassifyViewCellId";

-(NSArray *)modArr{
    if (_modArr==nil) {
        _modArr= @[
            @{
                @"name":@"美颜",
                @"icon":@"icon_function_meiyan.png",
                @"TIMenuClassify":@[@(0)]
            },
            @{
                @"name":@"美型",
                @"icon":@"icon_function_meixing.png",
                @"TIMenuClassify":@[@(1)]
            },
            @{
                @"name":@"萌颜",
                @"icon":@"icon_function_mengyan.png",
                @"TIMenuClassify":@[@(2),@(11),@(3),@(6),@(8),@(9)]
            },
            @{
                @"name":@"滤镜",
                @"icon":@"icon_function_lvjing.png",
                @"TIMenuClassify":@[@(4),@(5),@(7)]
            },
            @{
                @"name":@"一键美颜",
                @"icon":@"icon_function_yijian.png",
                @"TIMenuClassify":@[@(10)]
            },
        ];
    }
    return _modArr;
}

 -(UICollectionView *)classifyMenuView{
     if (_classifyMenuView == nil) {
         UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
         layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
         layout.itemSize = CGSizeMake(TiUISubMenuOneViewTIButtonWidth, TiUISubMenuOneViewTIButtonHeight);

         _classifyMenuView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
         _classifyMenuView.showsHorizontalScrollIndicator = NO;
         _classifyMenuView.backgroundColor=[UIColor whiteColor];
         _classifyMenuView.dataSource= self;
         _classifyMenuView.delegate = self;
         [_classifyMenuView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:TiUIClassifyViewCellId];
         
     }
     return _classifyMenuView;
 }


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.classifyMenuView];
        [self.classifyMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(75);
        }];
        
    }
    return self;
}

#pragma mark ---UICollectionViewDataSource---
//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
     return 5;
}
   
 //返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:TiUIClassifyViewCellId forIndexPath:indexPath];
    
    NSDictionary *dic = self.modArr[indexPath.row];
    
    TIButton *cellBtn = [[TIButton alloc]initWithScaling:0.9];
    cellBtn.userInteractionEnabled = NO;
    [cellBtn setTitle:[dic valueForKey:@"name"] withImage:[UIImage imageNamed:[dic valueForKey:@"icon"]] withTextColor:TI_Color_Default_Text_Black forState:UIControlStateNormal];
    
    [cell.contentView addSubview:cellBtn];
    
    [cellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView.mas_left).offset(6);
        make.right.equalTo(cell.contentView.mas_right).offset(-6);
    }];
   
                   
    return cell;
  
}


// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // UIEdgeInsets insets = {top, left, bottom, right};
    return UIEdgeInsetsMake(0, MINIMUMLINESPACING, 0, MINIMUMLINESPACING);
}
 
// 两行cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return MINIMUMLINESPACING;
}
  

#pragma mark ---UICollectionViewDelegate---
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *arr = [self.modArr[indexPath.row] objectForKey:@"TIMenuClassify"];
    if (_clickOnTheClassificationBlock) {
        _clickOnTheClassificationBlock(arr);
    }
    [self hiddenView];
}

-(void)showView{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.frame;
        rect.origin.y = 0;
        [self setFrame:rect];
       self.alpha = 1;
    }];
    
    
    if (self.executeShowOrHiddenBlock) {
        self.executeShowOrHiddenBlock(YES);
    }
 
}

-(void)hiddenView{
    
    
    [UIView animateWithDuration:0.3 animations:^{
           CGRect rect = self.frame;
           rect.origin.y = TiUIViewBoxTotalHeight;
           [self setFrame:rect];
          self.alpha = 0;
      }];
    
    if (self.executeShowOrHiddenBlock) {
           self.executeShowOrHiddenBlock(NO);
       }
}


@end
