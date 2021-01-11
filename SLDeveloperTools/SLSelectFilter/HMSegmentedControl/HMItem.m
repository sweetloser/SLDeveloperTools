//
//  HMItem.m
//  BXlive
//
//  Created by bxlive on 2019/5/21.
//  Copyright © 2019 cat. All rights reserved.
//

#import "HMItem.h"
#import "../../SLUtilities/SLUtilities.h"

@implementation HMItem

- (void)updateWithJsonDic:(NSDictionary *)jsonDic {
    [super updateWithJsonDic:jsonDic];
    
    NSString *allPath = [self allFilePath];
    if ([FilePathHelper fileIsExistsAtPath:allPath]) {
        self.status = 0;
    } else {
        self.status = 1;
    }
}

- (NSString *)allFilePath {
    if (!_name || !_file_url) {
        return nil;
    }
    return [HMItem allFilePathWithName:_name];
    
}

+ (NSString *)allFilePathWithName:(NSString *)name {
    NSString *folderName = @"HMItem";
    NSString *filePath = [[FilePathHelper getDocumentsPath] stringByAppendingPathComponent:folderName];
    [FilePathHelper createFolder:filePath];
    NSString *fileName = [NSString stringWithFormat:@"%@.bundle",name];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    return filePath;
}

@end
