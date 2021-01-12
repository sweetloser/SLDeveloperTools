//
//  TIMenuPlistManager.h
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/3.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct TiIndexPath{
           NSInteger section;
           NSInteger row;
       } IndexPath;
       
  
@interface TIMenuPlistManager : NSObject
/**
*   初始化单例
*/
+ (TIMenuPlistManager *)shareManager;

+(void)releaseShareManager;

@property(nonatomic,strong)NSArray *mainModeArr;

@property(nonatomic,strong)NSArray *meiyanModeArr;

@property(nonatomic,strong)NSArray *meixingModeArr;

@property(nonatomic,strong)NSArray *lvjingModeArr;

@property(nonatomic,strong)NSArray *doudongModeArr;

@property(nonatomic,strong)NSArray *hahajingModeArr;

@property(nonatomic,strong)NSArray *tiezhiModeArr;

@property(nonatomic,strong)NSArray *liwuModeArr;

@property(nonatomic,strong)NSArray *shuiyinModeArr;

@property(nonatomic,strong)NSArray *mianjuModeArr;
 
@property(nonatomic,strong)NSArray *lvmuModeArr;

@property(nonatomic,strong)NSArray *oneKeyModeArr;
@property(nonatomic,strong)NSArray *oneKeyParameter;

@property(nonatomic,strong)NSArray *interactionsArr;

-(NSArray *)modifyObject:(id)obj forKey:(NSString *)key In:(NSUInteger)index WithPath:(NSString *)path; 

@end
 
@interface TIMenuMode : NSObject
 
typedef NS_ENUM(NSInteger, DownloadedState) {
    TI_DOWNLOAD_STATE_NOTBEGUN = 0, // 未开始
    TI_DOWNLOAD_STATE_BEBEING = 1, // 正在下载
     TI_DOWNLOAD_STATE_CCOMPLET = 2,// 完成
    
};

@property(nonatomic,strong) NSString *name;
@property(nonatomic,assign) NSInteger menuTag;
@property(nonatomic,assign) BOOL selected;
@property(nonatomic,assign) BOOL totalSwitch;
@property(nonatomic,strong) NSString *subMenu;

@property(nonatomic,strong) NSString *thumb;
@property(nonatomic,strong) NSString *normalThumb;
@property(nonatomic,strong) NSString *selectedThumb;
@property(nonatomic,assign) DownloadedState downloaded;

@property(nonatomic,assign) NSInteger x;
@property(nonatomic,assign) NSInteger y;
@property(nonatomic,assign) NSInteger ratio;

@property(nonatomic,strong) NSString *dir;
@property(nonatomic,strong) NSString *category;
@property(nonatomic,assign) BOOL voiced;
@property(nonatomic,strong) NSString *hint;

+(instancetype)applicationWithDic:(NSDictionary*)dic;

@end
 
