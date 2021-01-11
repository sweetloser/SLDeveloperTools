//
//  SLSelectFilterHeader.h
//  Pods
//
//  Created by sweetloser on 2021/1/11.
//

#ifndef SLSelectFilterHeader_h
#define SLSelectFilterHeader_h

typedef struct BeautyStatus {
    NSInteger code ;
    NSString *key;
    NSString *msg;
} BeautyStatus;

extern BeautyStatus bs;

#import "BXVideoSelectFilterView.h"
#import "SLSelectFilterConst.h"
#import "authpack.h"
#import "FUManager.h"
#import "FUMusicPlayer.h"
#import "HMBeautifySlideView.h"
#import "HMBeautifyView.h"
#import "HMFilterView.h"
#import "HMItem.h"
#import "HMSegmentedControl.h"
#import "HMSlideView.h"

#endif /* SLSelectFilterHeader_h */
