//
//  BXMusicModel.m
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXMusicModel.h"
#import "FilePathHelper.h"

@implementation BXMusicModel

-(NSString *)allFilePath{
    NSString *folderName = @"SelectMusic";
    NSString *filePath = [[FilePathHelper getDocumentsPath] stringByAppendingPathComponent:folderName];
    [FilePathHelper createFolder:filePath];
    NSString *fileName = [NSString stringWithFormat:@"%@.mp3",_music_id];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    return filePath;
}

- (NSString *)lyricFilePath {
    NSString *folderName = @"Lyric";
    NSString *filePath = [[FilePathHelper getDocumentsPath] stringByAppendingPathComponent:folderName];
    [FilePathHelper createFolder:filePath];
    NSString *fileName = [NSString stringWithFormat:@"%@.lrc",_music_id];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    return filePath;
}

@end
