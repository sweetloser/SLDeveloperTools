//
//  TiUIMenuTowViewCell.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/5.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TiUIMenuTowViewCell.h"
#import "TIConfig.h"
#import "TiUISubMenuTowViewCell.h"
#import "TISetSDKParameters.h"

@interface TiUIMenuTowViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) UICollectionView *menuCollectionView;

@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

@end

static NSString *const TiUIMenuCollectionViewCellId = @"TiUIMainMenuTiUIMenuTowViewCellId";

@implementation TiUIMenuTowViewCell

-(UICollectionView *)menuCollectionView{
    if (_menuCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(TiUISubMenuTowViewTIButtonWidth, TiUISubMenuTowViewTIButtonHeight);
//        // 设置最小行间距
        CGFloat Spacing = (SCREEN_WIDTH -60 - 5*TiUISubMenuTowViewTIButtonWidth)/4;
        
        layout.minimumLineSpacing = Spacing;
        
        _menuCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _menuCollectionView.showsHorizontalScrollIndicator = NO;
        _menuCollectionView.backgroundColor = [UIColor whiteColor];
        _menuCollectionView.dataSource= self;
        _menuCollectionView.delegate = self;
       
        [_menuCollectionView registerClass:[TiUISubMenuTowViewCell class] forCellWithReuseIdentifier:TiUIMenuCollectionViewCellId];
    }
    return _menuCollectionView;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       CGFloat safeBottomHeigh = 0.0f;
             if (@available(iOS 11.0, *)) {
                 safeBottomHeigh = getSafeBottomHeight/2;
             }
        
       [self addSubview:self.menuCollectionView]; 
       [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(self.mas_centerY).with.offset(-safeBottomHeigh);
           make.left.equalTo(self.mas_left).offset(30);
           make.right.equalTo(self.mas_right).offset(-30);
           make.height.mas_equalTo(TiUISubMenuTowViewTIButtonHeight);
       }];
    }
    return self;
}
 

#pragma mark ---UICollectionViewDataSource---
//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    switch (self.mode.menuTag) {
        case 4:
            return [TIMenuPlistManager shareManager].lvjingModeArr.count;
            break;
        case 5:
            return [TIMenuPlistManager shareManager].doudongModeArr.count;
            break;
        case 6:
            return [TIMenuPlistManager shareManager].hahajingModeArr.count;
            break;
        case 10:
            return [TIMenuPlistManager shareManager].oneKeyModeArr.count;;
            break;
        default:
            return 0;
            break;
    }
}
  
 
   
 //返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   TiUISubMenuTowViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:TiUIMenuCollectionViewCellId forIndexPath:indexPath];
    TIMenuMode *subMod = nil;
    switch (self.mode.menuTag) {
        case 4:
        {
          subMod = [TIMenuPlistManager shareManager].lvjingModeArr[indexPath.row];
            [cell setCellType:TI_UI_TOWSUBCELL_TYPE_ONE];
        }
            break;
        case 5:
        {
            subMod = [TIMenuPlistManager shareManager].doudongModeArr[indexPath.row];
            [cell setCellType:TI_UI_TOWSUBCELL_TYPE_ONE];
        }
            break;
        case 6:
        {
            subMod = [TIMenuPlistManager shareManager].hahajingModeArr[indexPath.row];
            [cell setCellType:TI_UI_TOWSUBCELL_TYPE_TWO];
        }
            break;
        case 10:
               {
                   subMod = [TIMenuPlistManager shareManager].oneKeyModeArr[indexPath.row];
                   [cell setCellType:TI_UI_TOWSUBCELL_TYPE_ONE];
               }
            break;
        default:
            break;
    }
    if (subMod.selected)
    {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
     }
    [cell setSubMod:subMod];
    return cell;
}

#pragma mark ---UICollectionViewDelegate---
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     if (self.selectedIndexPath.row==indexPath.row)  return;
    
      switch (self.mode.menuTag) {
          case 4:
          {
           if (self.clickOnCellBlock)
           {
             self.clickOnCellBlock(indexPath.row);
           }
              [TIMenuPlistManager shareManager].lvjingModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(YES) forKey:@"selected" In:indexPath.row WithPath:@"TILvJingMenu.json"];

                 [TIMenuPlistManager shareManager].lvjingModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(NO) forKey:@"selected" In:self.selectedIndexPath.row WithPath:@"TILvJingMenu.json"];
                 
                 if (self.selectedIndexPath) {
                    [collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath,indexPath]];
                  }else{
                    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                  }
              self.selectedIndexPath = indexPath;
            
             [[TiSDKManager shareManager] setFilterEnum:[TISetSDKParameters getTiFilterEnumForIndex:indexPath.row] Param:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_FILTER_SLIDER]];
          }
              break;
              
         case 5:
         {

             [TIMenuPlistManager shareManager].doudongModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(YES) forKey:@"selected" In:indexPath.row WithPath:@"TIDouDongMenu.json"];

             [TIMenuPlistManager shareManager].doudongModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(NO) forKey:@"selected" In:self.selectedIndexPath.row WithPath:@"TIDouDongMenu.json"];
                             
               if (self.selectedIndexPath) {
                  [collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath,indexPath]];
                }else{
                  [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }
                 self.selectedIndexPath = indexPath;
             
             [[TiSDKManager shareManager] setRockEnum:[TISetSDKParameters setRockEnumByIndex:indexPath.row]];
         }
                         break;
              
              case 6:
             {
 
                 [TIMenuPlistManager shareManager].hahajingModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(YES) forKey:@"selected" In:indexPath.row WithPath:@"TIHaHaJingMenu.json"];

                 [TIMenuPlistManager shareManager].hahajingModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(NO) forKey:@"selected" In:self.selectedIndexPath.row WithPath:@"TIHaHaJingMenu.json"];
                                 
                    if (self.selectedIndexPath) {
                      [collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath,indexPath]];
                    }else{
                      [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    }
                     self.selectedIndexPath = indexPath;
                 
                 [[TiSDKManager shareManager] setDistortionEnum:[TISetSDKParameters setDistortionEnumByIndex:indexPath.row]];
                 
                  }
                        break;
                case 10:
                    {
                     if (self.clickOnCellBlock)
                     {
                       self.clickOnCellBlock(indexPath.row);
                     }
                        [TIMenuPlistManager shareManager].oneKeyModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(YES) forKey:@"selected" In:indexPath.row WithPath:@"TIOneKeyBeautyMenu.json"];

                           [TIMenuPlistManager shareManager].oneKeyModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(NO) forKey:@"selected" In:self.selectedIndexPath.row WithPath:@"TIOneKeyBeautyMenu.json"];
                           
                           if (self.selectedIndexPath) {
                              [collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath,indexPath]];
                            }else{
                              [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                            }
                        self.selectedIndexPath = indexPath;
                      
                        [TISetSDKParameters setBeautySlider:[TISetSDKParameters getFloatValueForKey:TI_UIDCK_ONEKEY_SLIDER] forKey:TI_UIDCK_ONEKEY_SLIDER withIndex:indexPath.row];
                    }
                                     break;
              
          default:
              break;
      }
}
     



- (void)setMode:(TIMenuMode *)mode{
    if (mode) {
       _mode = mode;
         
      }
}

@end
