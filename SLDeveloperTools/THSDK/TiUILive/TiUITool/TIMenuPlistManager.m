//
//  TIMenuPlistManager.m
//  TiSDKDemo
//
//  Created by iMacA1002 on 2019/12/3.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

#import "TIMenuPlistManager.h"
#import "TIUITool.h"
#import "TISetSDKParameters.h"

@interface TIMenuPlistManager ()
 
@end


static TIMenuPlistManager *shareManager = NULL;
static dispatch_once_t token;


@implementation TIMenuPlistManager

// MARK: --单例初始化方法--
+ (TIMenuPlistManager *)shareManager {
    dispatch_once(&token, ^{
        shareManager = [[TIMenuPlistManager alloc] init];
    });
    return shareManager;
}
+(void)releaseShareManager{
   token = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
//   [shareManager release];
   shareManager = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self getResourceFromJsonName:@"sticker"];
        [self getResourceFromJsonName:@"gift"]; //网络下载
        [self getResourceFromJsonName:@"watermark"];
        [self getResourceFromJsonName:@"mask"];
        [self getResourceFromJsonName:@"greenscreen"];
//        self.mainModeArr = [TIMenuPlistManager initJsonModeForPath:@"TIMenu"];
//
//        self.meiyanModeArr = [TIMenuPlistManager initJsonModeForPath:@"TIMeiYanMenu"];
//
//        self.meixingModeArr = [TIMenuPlistManager initJsonModeForPath:@"TIMeiXingMenu"];
//
//        self.lvjingModeArr = [TIMenuPlistManager initJsonModeForPath:@"TILvJingMenu"];
//
//        self.doudongModeArr = [TIMenuPlistManager initJsonModeForPath:@"TIDouDongMenu"];
//
//        self.hahajingModeArr = [TIMenuPlistManager initJsonModeForPath:@"TIHaHaJingMenu"];
//
//        self.tiezhiModeArr = [TIMenuPlistManager initJsonModeForPath:@"stickers"];
//
//        self.liwuModeArr = [TIMenuPlistManager initJsonModeForPath:@"gifts"];
//
//        self.shuiyinModeArr = [TIMenuPlistManager initJsonModeForPath:@"watermarks"];
//
//        self.mianjuModeArr = [TIMenuPlistManager initJsonModeForPath:@"masks"];
        
               self.mainModeArr = [self jsonModeForPath:@"TIMenu"];
              
               self.meiyanModeArr = [self jsonModeForPath:@"TIMeiYanMenu"];
               
               self.meixingModeArr = [self jsonModeForPath:@"TIMeiXingMenu"];
               
               self.lvjingModeArr = [self jsonModeForPath:@"TILvJingMenu"];
               
               self.doudongModeArr = [self jsonModeForPath:@"TIDouDongMenu"];
               
               self.hahajingModeArr = [self jsonModeForPath:@"TIHaHaJingMenu"];
               
               self.tiezhiModeArr = [self jsonModeForPath:@"stickers"];
               
               self.liwuModeArr = [self jsonModeForPath:@"gifts"];
               
               self.shuiyinModeArr = [self jsonModeForPath:@"watermarks"];
               
               self.mianjuModeArr = [self jsonModeForPath:@"masks"];
        
               self.lvmuModeArr = [self jsonModeForPath:@"greenscreens"];
        
               self.oneKeyModeArr = [self jsonModeForPath:@"TIOneKeyBeautyMenu"];
        
               self.interactionsArr = [self jsonModeForPath:@"interactions"];
        
         // 获取文件路径
          NSString *path = [[NSBundle mainBundle] pathForResource:@"TIOneKeyBeautyParameter" ofType:@"json"];
           NSData *data = [[NSData alloc] initWithContentsOfFile:path];
         self.oneKeyParameter = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
         
        [TISetSDKParameters initSDK];
        
    }
    return self;
}

-(NSArray *)jsonModeForPath:(NSString *)path
{
    NSMutableDictionary *plistDictionary;
           //获取配置文件
           NSString *plistPath = [[NSBundle mainBundle] pathForResource:path ofType:@"json"];
      
           NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",path]];
            
          NSFileManager *fileManager = [NSFileManager defaultManager];
//            if ([fileManager fileExistsAtPath:filePatch])
//               {
//           NSLog(@"沙盒中存在 %@",path);
//                 plistDictionary = [TIUITool getJsonDataForPath:filePatch];
//                }
//                else
//                {
//            NSLog(@"沙盒中不存在 %@",path);
////     每次启动默认加载本地配置
                plistDictionary = [TIUITool getJsonDataForPath:plistPath];
                [TIUITool setWriteJsonDic:plistDictionary toPath:filePatch];
//            }
           NSArray *plstArr = [plistDictionary objectForKey:@"menu"];
           NSMutableArray *modeArr = [NSMutableArray arrayWithCapacity:plstArr.count];
           for (NSDictionary *dic in plstArr) {
               
               TIMenuMode *mode = [TIMenuMode applicationWithDic:dic];
               
               if ([path isEqualToString:@"stickers"]||[path isEqualToString:@"gifts"]||[path isEqualToString:@"watermarks"]||[path isEqualToString:@"masks"]||[path isEqualToString:@"greenscreens"]||[path isEqualToString:@"interactions"]) {
                   
                   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                   NSString *folderName = [defaults objectForKey:[NSString stringWithFormat:@"%@%ld",mode.name,(long)mode.menuTag]];
                   [defaults synchronize];
                                 if (folderName&&folderName.length!=0) {
                                      NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",folderName]];
                                     if ([fileManager fileExistsAtPath:folderPath])
                                        {
                                            mode.downloaded = TI_DOWNLOAD_STATE_CCOMPLET;
                                     [self modifyObject:@(TI_DOWNLOAD_STATE_CCOMPLET) forKey:@"downloaded" In:mode.menuTag WithPath:[NSString stringWithFormat:@"%@.json",path]];
                                        }
                                 }
               }
                
               
               [modeArr addObject:mode];
           }
           
           return modeArr;
}


-(NSArray *)modifyObject:(id)obj forKey:(NSString *)key In:(NSUInteger)index WithPath:(NSString *)path{
 
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",path]];
    
    NSMutableDictionary *plistDictionary = [TIUITool getJsonDataForPath:filePatch];
//    //修改字典里面的内容,先按照结构取到你想修改内容的小字典
    NSMutableArray *nmArr = [NSMutableArray arrayWithArray:[plistDictionary objectForKey:@"menu"]];
    NSMutableDictionary *nmDic = [NSMutableDictionary dictionaryWithDictionary:nmArr[index]];
    [nmDic setObject:obj forKey:key];
    
    //修改完成组建成大字典写入本地
    [nmArr setObject:nmDic atIndexedSubscript:index];
    [plistDictionary setValue:nmArr forKey:@"menu"];
    [TIUITool setWriteJsonDic:plistDictionary toPath:filePatch];
    
     //修改mode数组
    NSMutableArray *modeArr;
    if([@"TIMenu.json" rangeOfString:path].location !=NSNotFound)//_roaldSearchText
     {
         modeArr = [NSMutableArray arrayWithArray:self.mainModeArr];
     }
     else if([@"TIMeiYanMenu.json" rangeOfString:path].location !=NSNotFound)
     {
         modeArr = [NSMutableArray arrayWithArray:self.meiyanModeArr];
     }
     else if([@"TIMeiXingMenu.json" rangeOfString:path].location !=NSNotFound)
     {
         modeArr = [NSMutableArray arrayWithArray:self.meixingModeArr];
     }
     else if([@"TILvJingMenu.json" rangeOfString:path].location !=NSNotFound)
     {
         modeArr = [NSMutableArray arrayWithArray:self.lvjingModeArr];
     }
     else if([@"TIDouDongMenu.json" rangeOfString:path].location !=NSNotFound)
     {
         modeArr = [NSMutableArray arrayWithArray:self.doudongModeArr];
     }
     else if([@"TIHaHaJingMenu.json" rangeOfString:path].location !=NSNotFound)
     { 
         modeArr = [NSMutableArray arrayWithArray:self.hahajingModeArr];
     }
     else if([@"stickers.json" rangeOfString:path].location !=NSNotFound)
     {
        modeArr = [NSMutableArray arrayWithArray:self.tiezhiModeArr];
     }
    else if([@"gifts.json" rangeOfString:path].location !=NSNotFound)
    {
       modeArr = [NSMutableArray arrayWithArray:self.liwuModeArr];
    }
    else if([@"watermarks.json" rangeOfString:path].location !=NSNotFound)
    {
       modeArr = [NSMutableArray arrayWithArray:self.shuiyinModeArr];
    }
    else if([@"masks.json" rangeOfString:path].location !=NSNotFound)
    {
       modeArr = [NSMutableArray arrayWithArray:self.mianjuModeArr];
    }
    else if([@"greenscreens.json" rangeOfString:path].location !=NSNotFound)
    {
       modeArr = [NSMutableArray arrayWithArray:self.lvmuModeArr];
    }
    else if([@"TIOneKeyBeautyMenu.json" rangeOfString:path].location !=NSNotFound)
    {
       modeArr = [NSMutableArray arrayWithArray:self.oneKeyModeArr];
    }
    else if([@"interactions.json" rangeOfString:path].location !=NSNotFound)
    {
       modeArr = [NSMutableArray arrayWithArray:self.interactionsArr];
    }
    
    if (modeArr.count) {
        
    TIMenuMode *dome = [TIMenuMode applicationWithDic:nmDic];
    [modeArr setObject:dome atIndexedSubscript:index];
    
    }
    
    return modeArr;
}

-(void)getResourceFromJsonName:(NSString *)name{
    NSString *stickerPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name];
            if (![[NSFileManager defaultManager] fileExistsAtPath:stickerPath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:stickerPath withIntermediateDirectories:NO attributes:nil error:nil];
            }
    
    
    NSString *bundleJson = @"";
    
    if ([name isEqualToString:@"sticker"])
    {
        bundleJson = @"stickers.json";
    }
    else if([name isEqualToString:@"gift"])
    {
        bundleJson = @"gifts.json";
    }
    else if ([name isEqualToString:@"watermark"])
    {
        bundleJson = @"watermarks.json";
    }
    else if([name isEqualToString:@"mask"])
    {
        bundleJson = @"masks.json";
    }
    else if([name isEqualToString:@"greenscreen"])
    {
        bundleJson = @"greenscreens.json";
    }
    else if([name isEqualToString:@"interactions"])
    {
        bundleJson = @"interactions.json";
    }
    
    NSString *configPath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:bundleJson];
    if (![[NSFileManager defaultManager] fileExistsAtPath:configPath isDirectory:NULL]) {
                NSLog(@"The general configuration file for the json in the resource directory does not exist");
                return ;
            }
        NSError *error = nil;
     NSData *data = [NSData dataWithContentsOfFile:configPath];
     NSDictionary *oldDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
          if (!oldDict || error) {
              NSLog(@"Resource directory under the general configuration file to read the jsonS failed:%@",error);
              return ;
          }
    
    
    //拷贝本地贴纸到沙盒
       NSString *localPath =
               [[[NSBundle mainBundle] pathForResource:@"TiSDKResource" ofType:@"bundle"] stringByAppendingPathComponent:name];

       NSArray *dirArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localPath error:NULL];
       for (NSString *stickerName in dirArr) {
 
               if (![[NSFileManager defaultManager] fileExistsAtPath:[stickerPath stringByAppendingPathComponent:stickerName]]) {
                   
                   [[NSFileManager defaultManager] copyItemAtPath:[localPath stringByAppendingPathComponent:stickerName] toPath:[stickerPath stringByAppendingPathComponent:stickerName] error:NULL];
                   
               }
           //判断bundle中是否含有json文件 如果有 将json文件赋值给UITool 配置json文件
                if ([stickerName containsString:@".json"]) {
//                  NSString *bundlePath  =  [localPath stringByAppendingPathComponent:stickerName];
//
//                   NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:stickerName];
//
//                    NSDictionary  *bundleDictionary = [TIUITool getJsonDataForPath:bundlePath];
//                    NSDictionary  *fileDictionary = [TIUITool getJsonDataForPath:filePatch];
//
//                    NSArray * bundleArr = bundleDictionary.allValues.lastObject;
//                    NSArray * fileArr = fileDictionary.allValues.lastObject;
//
////                    for (NSDictionary *mod1 in bundleArr) {
//
//
//
//                    for (int i = 0; i < bundleArr.count; i++) {
//                         NSDictionary *mod1 = bundleArr[i];
//                        NSString *name1 = [mod1 objectForKey:@"name"];
//                        BOOL isContains = NO;
//                        for (NSDictionary *mod2 in fileArr) {
//                        NSString *name2 = [mod2 objectForKey:@"name"];
//                            if ([name1 isEqualToString:name2]) {
//                                isContains = YES;
//                            }
//                        }
//                        if (!isContains) {
////                            mod1 addto fileArr
//
//
//                            NSMutableDictionary *newDic =[NSMutableDictionary dictionary];
//                            [newDic setObject:mod1[@"name"] forKey:@"name"];
//                            [newDic setObject:@(i) forKey:@"menuTag"];
//                            [newDic setObject:mod1[@"selected"]?mod1[@"selected"]:@"" forKey:@"selected"];
//                            [newDic setObject:mod1[@"totalSwitch"]?mod1[@"totalSwitch"]:@"" forKey:@"totalSwitch"];
//                            [newDic setObject:mod1[@"subMenu"]?mod1[@"subMenu"]:@"" forKey:@"subMenu"];
//                            [newDic setObject:mod1[@"thumb"]?mod1[@"thumb"]:@"" forKey:@"thumb"];
//                            [newDic setObject:mod1[@"normalThumb"]?mod1[@"normalThumb"]:@"" forKey:@"normalThumb"];
//                            [newDic setObject:mod1[@"selectedThumb"]?mod1[@"selectedThumb"]:@"" forKey:@"selectedThumb"];
//                            [newDic setObject:mod1[@"downloaded"]?mod1[@"downloaded"]:@"" forKey:@"downloaded"];
//
//                            [newDic setObject:mod1[@"x"]?mod1[@"x"]:@"" forKey:@"x"];
//                            [newDic setObject:mod1[@"y"]?mod1[@"y"]:@"" forKey:@"y"];
//                            [newDic setObject:mod1[@"ratio"]?mod1[@"ratio"]:@"" forKey:@"ratio"];
//
//
//                            NSLog(@"%@",newDic);
//
//                        }
//
//                    }
//
//
//                    NSLog(@" ----%@---\n%@--- ",bundleDictionary,fileDictionary);
//
                }
           //修改配置文件json
       }
}


@end



@implementation TIMenuMode

 - (instancetype)initWithDic:(NSDictionary *)dic
 {
     if (self = [super init]) {
         // KVC
         [self setValuesForKeysWithDictionary:dic];
     }
     return  self;
 }

 +(instancetype)applicationWithDic:(NSDictionary*)dic
 {
     TIMenuMode * mode = [[TIMenuMode alloc] initWithDic:dic];
     return mode;
}
 
@end

 

