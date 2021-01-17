//
//  BXMediaModel.h
//  BXlive
//
//  Created by bxlive on 2019/8/2.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BaseObject.h"
#import "BXHMovieModel.h"
#import "BXSLLiveRoom.h"

@interface BXMediaModel : BaseObject

@property (nonatomic, copy) NSString *type; 

@property (nonatomic, strong) BXHMovieModel *video;
@property (nonatomic, strong) BXSLLiveRoom *liveRoom;

@end


