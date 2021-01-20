//
//  DetailSoundView.h
//  BXlive
//
//  Created by mac on 2020/7/30.
//  Copyright © 2020 cat. All rights reserved.
//

#import "DetailBaseheaderView.h"
#import "DynPlayMp3Voice.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailSoundView : DetailBaseheaderView<playDelegate>
@property (copy, nonatomic) void (^DidSoundIndex)();
@property(nonatomic, strong)DynPlayMp3Voice *playSound;
@end

NS_ASSUME_NONNULL_END
