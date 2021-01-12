//
//  TiUIMenuThreeViewCell.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/6.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TiUIMenuThreeViewCell.h"
#import "TIConfig.h"
#import "TiUISubMenuThreeViewCell.h"
#import "TIDownloadZipManager.h"

@interface TiUIMenuThreeViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) UICollectionView *menuCollectionView;

@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

@end

static NSString *const TiUIMenuCollectionViewCellId = @"TiUIMainMenuTiUIMenuThreeViewCellId";

@implementation TiUIMenuThreeViewCell

-(UICollectionView *)menuCollectionView{
    if (_menuCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(TiUISubMenuTowViewTIButtonWidth, TiUISubMenuTowViewTIButtonWidth);
//        // 设置最小行间距
//        CGFloat spacing2 = ((TiUIViewBoxTotalHeight- TiUIMenuViewHeight - TiUISliderRelatedViewHeight) -10 - 3*TiUISubMenuTowViewTIButtonWidth) /2;
        
        CGFloat spacing1 = (SCREEN_WIDTH - 70 - 5*TiUISubMenuTowViewTIButtonWidth) /4;
         
        layout.minimumLineSpacing = spacing1;
        layout.minimumInteritemSpacing = spacing1;
        
        _menuCollectionView =[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _menuCollectionView.showsVerticalScrollIndicator = NO;
        _menuCollectionView.backgroundColor = [UIColor whiteColor];
        _menuCollectionView.dataSource= self;
        _menuCollectionView.delegate = self;
       
        [_menuCollectionView registerClass:[TiUISubMenuThreeViewCell class] forCellWithReuseIdentifier:TiUIMenuCollectionViewCellId];
    }
    return _menuCollectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       [self.contentView addSubview:self.menuCollectionView];
       [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.mas_top).offset(15);
           make.bottom.equalTo(self.mas_bottom).offset(-5);
           make.left.equalTo(self.contentView.mas_left).offset(35);
           make.right.equalTo(self.contentView.mas_right).offset(-35);
       }];
        
    }
    return self;
}


#pragma mark ---UICollectionViewDataSource---
//设置每个section包含的item数目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    switch (self.mode.menuTag) {
        case 2:
            return [TIMenuPlistManager shareManager].tiezhiModeArr.count;
                  break;
        case 3:
            return [TIMenuPlistManager shareManager].liwuModeArr.count;
                break;
        case 7:
            return [TIMenuPlistManager shareManager].shuiyinModeArr.count;
                break;
        case 8:
                  return [TIMenuPlistManager shareManager].mianjuModeArr.count;
             break;
        case 9:
                 return [TIMenuPlistManager shareManager].lvmuModeArr.count;
            break;
        case 11:
                return [TIMenuPlistManager shareManager].interactionsArr.count;
                       break;
        default:
            return 0;
            break;
    }
}
   
 //返回对应indexPath的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   TiUISubMenuThreeViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:TiUIMenuCollectionViewCellId forIndexPath:indexPath];
    
    TIMenuMode *subMod = nil;
    switch (self.mode.menuTag) {
        case 2:
        {
          subMod = [TIMenuPlistManager shareManager].tiezhiModeArr[indexPath.row];
            
            [cell setSubMod:subMod WithTag:2];
        }
            break;
        case 3:
        {
            subMod = [TIMenuPlistManager shareManager].liwuModeArr[indexPath.row];
            [cell setSubMod:subMod WithTag:3];
        }
            break;
        case 7:
        {
            subMod = [TIMenuPlistManager shareManager].shuiyinModeArr[indexPath.row];
            [cell setSubMod:subMod WithTag:7];
        }
             break;
        case 8:
        {
            subMod = [TIMenuPlistManager shareManager].mianjuModeArr[indexPath.row];
            [cell setSubMod:subMod WithTag:8];
        }
        break;
        case 9:
        {
            subMod = [TIMenuPlistManager shareManager].lvmuModeArr[indexPath.row];
            [cell setSubMod:subMod WithTag:9];
        }
        break;
        case 11:
              {
                  subMod = [TIMenuPlistManager shareManager].interactionsArr[indexPath.row];
                  [cell setSubMod:subMod WithTag:11];
              }
              break;
        default:
            break;
    }
    if (subMod.selected)
    {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
     }

    return cell;
}

#pragma mark ---UICollectionViewDelegate---
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndexPath.row==indexPath.row) {
        return;//选中同一个cell不做处理
    }
        switch (self.mode.menuTag) {
            case 2:
            {
                TIMenuMode *mode = [TIMenuPlistManager shareManager].tiezhiModeArr[indexPath.row];
                if (mode.downloaded==TI_DOWNLOAD_STATE_CCOMPLET)
                {
                      [TIMenuPlistManager shareManager].tiezhiModeArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(YES) forKey:@"selected" In:indexPath.row WithPath:@"stickers.json"];
                    
                      [TIMenuPlistManager shareManager].tiezhiModeArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(NO) forKey:@"selected" In:self.selectedIndexPath.row WithPath:@"stickers.json"];
        
                                   if (self.selectedIndexPath) {
                                       [collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath,indexPath]];
                                   }else{
                                       [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                                   }
                                   self.selectedIndexPath = indexPath;
                
                    [[TiSDKManager shareManager] setStickerName:mode.name];
                }
                else if (mode.downloaded==TI_DOWNLOAD_STATE_NOTBEGUN)
                {
                    // 开始下载
                  [TIMenuPlistManager shareManager].tiezhiModeArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(TI_DOWNLOAD_STATE_BEBEING) forKey:@"downloaded" In:indexPath.row WithPath:@"stickers.json"];
                    
                  [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    WeakSelf;
                 [[TIDownloadZipManager shareManager] downloadSuccessedType:TI_DOWNLOAD_TYPE_Sticker MenuMode:mode completeBlock:^(BOOL successful) {
                        DownloadedState state = TI_DOWNLOAD_STATE_BEBEING;
                        if (successful) {
                            // 开始下载
                            state = TI_DOWNLOAD_STATE_CCOMPLET;
                        }else{
                            state = TI_DOWNLOAD_STATE_NOTBEGUN;
                        }
                           [TIMenuPlistManager shareManager].tiezhiModeArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(state) forKey:@"downloaded" In:indexPath.row WithPath:@"stickers.json"];
                        
                     [weakSelf.menuCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                        
                    }];
                }
            }
                break;
            case 3:
            {
                TIMenuMode *mode = [TIMenuPlistManager shareManager].liwuModeArr[indexPath.row];
                           if (mode.downloaded==TI_DOWNLOAD_STATE_CCOMPLET)
                           {
                                 [TIMenuPlistManager shareManager].liwuModeArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(YES) forKey:@"selected" In:indexPath.row WithPath:@"gifts.json"];
                               
                                 [TIMenuPlistManager shareManager].liwuModeArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(NO) forKey:@"selected" In:self.selectedIndexPath.row WithPath:@"gifts.json"];
                   
                                              if (self.selectedIndexPath) {
                                                  [collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath,indexPath]];
                                              }else{
                                                  [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                                              }
                                              self.selectedIndexPath = indexPath;
                           
                               [[TiSDKManager shareManager] setGift:mode.name];
                           }
                           else if (mode.downloaded==TI_DOWNLOAD_STATE_NOTBEGUN)
                           {
                               // 开始下载
                             [TIMenuPlistManager shareManager].liwuModeArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(TI_DOWNLOAD_STATE_BEBEING) forKey:@"downloaded" In:indexPath.row WithPath:@"gifts.json"];
                               
                             [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                               WeakSelf;
                            [[TIDownloadZipManager shareManager] downloadSuccessedType:TI_DOWNLOAD_STATE_Gift MenuMode:mode completeBlock:^(BOOL successful) {
                                   DownloadedState state = TI_DOWNLOAD_STATE_BEBEING;
                                   if (successful) {
                                       // 开始下载
                                       state = TI_DOWNLOAD_STATE_CCOMPLET;
                                   }else{
                                       state = TI_DOWNLOAD_STATE_NOTBEGUN;
                                   }
                                      [TIMenuPlistManager shareManager].liwuModeArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(state) forKey:@"downloaded" In:indexPath.row WithPath:@"gifts.json"];
                                   
                                [weakSelf.menuCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                                   
                               }];
                           }
                 
            }
                break;
            case 7:
            {
                TIMenuMode *mode = [TIMenuPlistManager shareManager].shuiyinModeArr[indexPath.row];
                                          if (mode.downloaded==TI_DOWNLOAD_STATE_CCOMPLET)
                                          {
                                                [TIMenuPlistManager shareManager].shuiyinModeArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(YES) forKey:@"selected" In:indexPath.row WithPath:@"watermarks.json"];
                                              
                                                [TIMenuPlistManager shareManager].shuiyinModeArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(NO) forKey:@"selected" In:self.selectedIndexPath.row WithPath:@"watermarks.json"];
                                  
                                                             if (self.selectedIndexPath) {
                                                                 [collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath,indexPath]];
                                                             }else{
                                                                 [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                                                             }
                                                             self.selectedIndexPath = indexPath;
                                          
                                              if (indexPath.row)
                                              {
                                                  [[TiSDKManager shareManager] setWatermark:YES Left:(int)mode.x Top:(int)mode.y Ratio:(int)mode.ratio FileName:mode.name];
                                              }
                                              else
                                              {
                                                  [[TiSDKManager shareManager] setWatermark:NO Left:0 Top:0 Ratio:0 FileName:@"watermark.png"];
                                              }
                                              
                                          }
                                          else if (mode.downloaded==TI_DOWNLOAD_STATE_NOTBEGUN)
                                          {
                                              // 开始下载
                                            [TIMenuPlistManager shareManager].shuiyinModeArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(TI_DOWNLOAD_STATE_BEBEING) forKey:@"downloaded" In:indexPath.row WithPath:@"watermarks.json"];
                                              
                                            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                                              WeakSelf;
                                           [[TIDownloadZipManager shareManager] downloadSuccessedType:TI_DOWNLOAD_STATE_Watermark MenuMode:mode completeBlock:^(BOOL successful) {
                                                  DownloadedState state = TI_DOWNLOAD_STATE_BEBEING;
                                                  if (successful) {
                                                      // 开始下载
                                                      state = TI_DOWNLOAD_STATE_CCOMPLET;
                                                  }else{
                                                      state = TI_DOWNLOAD_STATE_NOTBEGUN;
                                                  }
                                                     [TIMenuPlistManager shareManager].shuiyinModeArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(state) forKey:@"downloaded" In:indexPath.row WithPath:@"watermarks.json"];
                                                  
                                               [weakSelf.menuCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                                                  
                                              }];
                                          }
            }
                break;
            
            case 8:
                { 
                    TIMenuMode *mode = [TIMenuPlistManager shareManager].mianjuModeArr[indexPath.row];
                                if (mode.downloaded==TI_DOWNLOAD_STATE_CCOMPLET)
                                {
                                    [TIMenuPlistManager shareManager].mianjuModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(YES) forKey:@"selected" In:indexPath.row WithPath:@"masks.json"];
                                    [TIMenuPlistManager shareManager].mianjuModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(NO) forKey:@"selected" In:self.selectedIndexPath.row WithPath:@"masks.json"];
                                                    
                                    if (self.selectedIndexPath) {
                                      [collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath,indexPath]];
                                    }else{
                                        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                                     }
                                        self.selectedIndexPath = indexPath;
                                    
                                    [[TiSDKManager shareManager] setMask:mode.name];

                                    }
                                    else if (mode.downloaded==TI_DOWNLOAD_STATE_NOTBEGUN)
                                              {
                                                  // 开始下载
                                                [TIMenuPlistManager shareManager].mianjuModeArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(TI_DOWNLOAD_STATE_BEBEING) forKey:@"downloaded" In:indexPath.row WithPath:@"masks.json"];

                                                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                                                  WeakSelf;
                                               [[TIDownloadZipManager shareManager] downloadSuccessedType:TI_DOWNLOAD_STATE_Mask MenuMode:mode completeBlock:^(BOOL successful) {
                                                      DownloadedState state = TI_DOWNLOAD_STATE_BEBEING;
                                                      if (successful) {
                                                          // 开始下载
                                                          state = TI_DOWNLOAD_STATE_CCOMPLET;
                                                      }else{
                                                          state = TI_DOWNLOAD_STATE_NOTBEGUN;
                                                      }
                                                         [TIMenuPlistManager shareManager].mianjuModeArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(state) forKey:@"downloaded" In:indexPath.row WithPath:@"masks.json"];

                                                   [weakSelf.menuCollectionView reloadItemsAtIndexPaths:@[indexPath]];

                                                  }];
                                              }
    
                      }
                          break;
                case 9:
                    {
                 TIMenuMode *mode = [TIMenuPlistManager shareManager].lvmuModeArr[indexPath.row];
                if (mode.downloaded==TI_DOWNLOAD_STATE_CCOMPLET)
                {
                    [TIMenuPlistManager shareManager].lvmuModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(YES) forKey:@"selected" In:indexPath.row WithPath:@"greenscreens.json"];
                    [TIMenuPlistManager shareManager].lvmuModeArr   =  [[TIMenuPlistManager shareManager] modifyObject:@(NO) forKey:@"selected" In:self.selectedIndexPath.row WithPath:@"greenscreens.json"];
                                                                  
                    if (self.selectedIndexPath) {
                        [collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath,indexPath]];
                    }else{
                        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                        }
                self.selectedIndexPath = indexPath;
                                                
                [[TiSDKManager shareManager] setGreenScreen:mode.name];
                    
                }
                else if (mode.downloaded==TI_DOWNLOAD_STATE_NOTBEGUN)
                {
                    // 开始下载
                   [TIMenuPlistManager shareManager].lvmuModeArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(TI_DOWNLOAD_STATE_BEBEING) forKey:@"downloaded" In:indexPath.row WithPath:@"greenscreens.json"];
                    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                              WeakSelf;
                     [[TIDownloadZipManager shareManager] downloadSuccessedType:TI_DOWNLOAD_STATE_Lvmu MenuMode:mode completeBlock:^(BOOL successful) {
                        DownloadedState state = TI_DOWNLOAD_STATE_BEBEING;
                       if (successful) {
                        // 开始下载
                        state = TI_DOWNLOAD_STATE_CCOMPLET;
                            }else{
                        state = TI_DOWNLOAD_STATE_NOTBEGUN;
                                        }
                    [TIMenuPlistManager shareManager].lvmuModeArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(state) forKey:@"downloaded" In:indexPath.row WithPath:@"greenscreens.json"];

                                    [weakSelf.menuCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                           }];
                                        }
                  
                                    }
                                        break;
                case 11:
                           {
                               TIMenuMode *mode = [TIMenuPlistManager shareManager].interactionsArr[indexPath.row];
                               if (mode.downloaded==TI_DOWNLOAD_STATE_CCOMPLET)
                               {
                                     [TIMenuPlistManager shareManager].interactionsArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(YES) forKey:@"selected" In:indexPath.row WithPath:@"interactions.json"];
                                   
                                     [TIMenuPlistManager shareManager].interactionsArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(NO) forKey:@"selected" In:self.selectedIndexPath.row WithPath:@"interactions.json"];
                       
                                                  if (self.selectedIndexPath) {
                                                      [collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath,indexPath]];
                                                  }else{
                                                      [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                                                  }
                                                  self.selectedIndexPath = indexPath;
                               
                                   [[TiSDKManager shareManager] setInteraction:mode.name];
                                   [[TiUIManager shareManager] setInteractionHintL:mode.hint];
                               }
                               else if (mode.downloaded==TI_DOWNLOAD_STATE_NOTBEGUN)
                               {
                                   // 开始下载
                                 [TIMenuPlistManager shareManager].interactionsArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(TI_DOWNLOAD_STATE_BEBEING) forKey:@"downloaded" In:indexPath.row WithPath:@"interactions.json"];
                                   
                                 [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                                   WeakSelf;
                                [[TIDownloadZipManager shareManager] downloadSuccessedType:TI_DOWNLOAD_STATE_Interactions MenuMode:mode completeBlock:^(BOOL successful) {
                                       DownloadedState state = TI_DOWNLOAD_STATE_BEBEING;
                                       if (successful) {
                                           // 开始下载
                                           state = TI_DOWNLOAD_STATE_CCOMPLET;
                                       }else{
                                           state = TI_DOWNLOAD_STATE_NOTBEGUN;
                                       }
                                          [TIMenuPlistManager shareManager].interactionsArr  =  [[TIMenuPlistManager shareManager] modifyObject:@(state) forKey:@"downloaded" In:indexPath.row WithPath:@"interactions.json"];
                                       
                                    [weakSelf.menuCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                                       
                                   }];
                               }
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
