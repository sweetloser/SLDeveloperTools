//
//  TiUISubMenuOneViewCell.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/5.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TiUIMenuOneViewCell.h"
#import "TIConfig.h"
#import "TIButton.h"
#import "TiUISubMenuOneViewCell.h"
#import <YYCategories/YYCategories.h>

@interface TiUIMenuOneViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)TIButton *totalSwitch;
@property(nonatomic,strong)UIView *lineView;

@property(nonatomic,strong) UICollectionView *menuCollectionView;

@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

@end

static NSString *const TiUIMenuCollectionViewCellId = @"TiUIMainMenuCollectionViewnOneCellId";
  
@implementation TiUIMenuOneViewCell
 
-(TIButton *)totalSwitch{
    if (_totalSwitch==nil) {
        _totalSwitch = [[TIButton alloc]initWithScaling:0.9];
        [_totalSwitch addTarget:self action:@selector(totalSwitch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _totalSwitch;
}

-(UIView *)lineView{
    if (_lineView==nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = TI_Color_Default_Text_Black;
    }
    return _lineView;
}

-(UICollectionView *)menuCollectionView{
    if (_menuCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(TiUISubMenuOneViewTIButtonWidth, TiUISubMenuOneViewTIButtonHeight);
//        // 设置最小行间距
        layout.minimumLineSpacing = 15;
        
        _menuCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _menuCollectionView.showsHorizontalScrollIndicator = NO;
        _menuCollectionView.backgroundColor = [UIColor whiteColor];
        _menuCollectionView.dataSource= self;
        _menuCollectionView.delegate = self;
       
        [_menuCollectionView registerClass:[TiUISubMenuOneViewCell class] forCellWithReuseIdentifier:TiUIMenuCollectionViewCellId];
    }
    return _menuCollectionView;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       [self addSubview:self.totalSwitch];
       [self addSubview:self.lineView];
       
       [self addSubview:self.menuCollectionView];
        
        CGFloat safeBottomHeigh = 0.0f;
        if (@available(iOS 11.0, *)) {
            safeBottomHeigh = getSafeBottomHeight/2;
        } 
        
       [self.totalSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(self.mas_centerY).with.offset(-safeBottomHeigh);
           make.left.equalTo(self.mas_left).offset(35);
           make.width.mas_equalTo(TiUISubMenuOneViewTIButtonWidth-12);
           make.height.mas_equalTo(TiUISubMenuOneViewTIButtonHeight);
       }];
       [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(self.mas_centerY).with.offset(-safeBottomHeigh);
           make.left.equalTo(self.totalSwitch.mas_right).offset(20);
           make.width.mas_equalTo(0.25);
           make.height.mas_equalTo(TiUISubMenuOneViewTIButtonHeight);
       }];
        
       [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(self.mas_centerY).with.offset(-safeBottomHeigh);
           make.left.equalTo(self.lineView.mas_right).offset(25);
           make.right.equalTo(self.mas_right).offset(-20);
           make.height.mas_equalTo(TiUISubMenuOneViewTIButtonHeight);
       }]; 
    }
    return self;
}
 

#pragma mark ---UICollectionViewDataSource---
//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (self.mode.menuTag) {
        case 0:
             return [TIMenuPlistManager shareManager].meiyanModeArr.count;
            break;
        case 1:
            return [TIMenuPlistManager shareManager].meixingModeArr.count;
          break;
        default:
            return 0;
           break;
    }

}
  
 
   
 //返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   TiUISubMenuOneViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:TiUIMenuCollectionViewCellId forIndexPath:indexPath];
     
    switch (self.mode.menuTag) {
        case 0:
        {
          TIMenuMode * subMod = [[TIMenuPlistManager shareManager].meiyanModeArr objectAtIndex:indexPath.row];
            if (subMod.selected)
               {
                   self.selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                }
            [cell setSubMod:subMod];
        }
            break;
        case 1:
            {
             TIMenuMode * subMod = [[TIMenuPlistManager shareManager].meixingModeArr objectAtIndex:indexPath.row];
                if (subMod.selected)
                   {
                    self.selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                   }
            [cell setSubMod:subMod];
        }
            break;
        case 6:
            {
             TIMenuMode * subMod = [[TIMenuPlistManager shareManager].hahajingModeArr objectAtIndex:indexPath.row];
                if (subMod.selected)
                    {
                      self.selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                    }
            [cell setSubMod:subMod];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
         
}

#pragma mark ---UICollectionViewDelegate---
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
        if(indexPath.row == self.selectedIndexPath.row) return;
    
    if (self.clickOnCellBlock)
    {
            self.clickOnCellBlock(indexPath.row);
      }
    
    switch (self.mode.menuTag) {
        case 0:
        {
            [TIMenuPlistManager shareManager].meiyanModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(YES) forKey:@"selected" In:indexPath.row WithPath:@"TIMeiYanMenu.json"];

            [TIMenuPlistManager shareManager].meiyanModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(NO) forKey:@"selected" In:self.selectedIndexPath.row WithPath:@"TIMeiYanMenu.json"];
                            
                 if (self.selectedIndexPath) {
                        [collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath,indexPath]];
                    }else{
                        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    }
               self.selectedIndexPath = indexPath;
             
           }
        
            break;
        case 1:
        {
 
            [TIMenuPlistManager shareManager].meixingModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(YES) forKey:@"selected" In:indexPath.row WithPath:@"TIMeiXingMenu.json"];

            [TIMenuPlistManager shareManager].meixingModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(NO) forKey:@"selected" In:self.selectedIndexPath.row WithPath:@"TIMeiXingMenu.json"];
                            
                if (self.selectedIndexPath) {
                        [collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath,indexPath]];
                    }else{
                            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                     }
               self.selectedIndexPath = indexPath;
            }
                break;
            
        default:
            break;
    } 
}
 
-(void)totalSwitch:(TIButton *)sender
{
  [TIMenuPlistManager shareManager].mainModeArr  = [[TIMenuPlistManager shareManager] modifyObject:@(!self.mode.totalSwitch) forKey:@"totalSwitch" In:self.mode.menuTag WithPath:@"TIMenu.json"];
    TIMenuMode *newMod = [TIMenuPlistManager shareManager].mainModeArr[self.mode.menuTag];
    _mode = newMod;
    [self.totalSwitch setSelected:newMod.totalSwitch];
    
    if (newMod.menuTag ==0)
    {
        [[TiSDKManager shareManager] setBeautyEnable:newMod.totalSwitch];
    }
    else if(newMod.menuTag==1)
    {
        [[TiSDKManager shareManager] setFaceTrimEnable:newMod.totalSwitch];
    }
}
 

- (void)setMode:(TIMenuMode *)mode{
    if (mode) {
       _mode = mode;
    [self.totalSwitch setTitle:[NSString stringWithFormat:@"%@:关",mode.name] withImage:[UIImage imageNamed:@"btn_close"] withTextColor:TI_Color_Default_Text_Black forState:UIControlStateNormal];
    [self.totalSwitch setTitle:[NSString stringWithFormat:@"%@:开",mode.name] withImage:[UIImage imageNamed:@"btn_open"] withTextColor:[UIColor colorWithHexString:@"#FF2D52"] forState:UIControlStateSelected];
    [self.totalSwitch setSelected:mode.totalSwitch];
         
      }
}


@end
