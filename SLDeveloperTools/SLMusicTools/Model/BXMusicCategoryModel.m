//
//  BXMusicCategoryModel.m
//  BXlive
//
//  Created by bxlive on 2019/4/16.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXMusicCategoryModel.h"

@implementation BXMusicCategoryModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _itemArray = [NSMutableArray array];
    }
    return self;
}
- (void)updateWithJsonDic:(NSDictionary *)jsonDic {
    [super updateWithJsonDic:jsonDic];
    _category_id = jsonDic[@"category_id"];
    _icon = jsonDic[@"icon"];
    _title = jsonDic[@"title"];
    
    NSArray *items = jsonDic[@"item"];
    if (items && items.count) {
        for (NSDictionary *dic in items) {
            BXMusicModel *musicModel = [[BXMusicModel alloc]init];
            musicModel.music_id = dic[@"music_id"];
            musicModel.title = dic[@"title"];
            musicModel.singer = dic[@"singer"];
            musicModel.image = dic[@"image"];
            musicModel.is_collect = dic[@"is_collect"];
            musicModel.link = dic[@"link"];
            musicModel.lrc = dic[@"lrc"];
            [_itemArray addObject:musicModel];
        }
    }
    
}
@end
