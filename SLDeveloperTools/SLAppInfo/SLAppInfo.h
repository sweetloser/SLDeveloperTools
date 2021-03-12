//
//  SLAppInfo.h
//  
//
//  Created by sweetloser on 2021/1/5.
//

#ifndef SLAppInfo_h
#define SLAppInfo_h

#import "BuglyHelper.h"
#import "BXActivity.h"
#import "BXAppInfo.h"
#import "BXAttentFollowModel.h"
#import "BXCommentModel.h"
#import "BXDynamicModel.h"
#import "BXDynCircelOperAlert.h"
#import "BXDynCircleModel.h"
#import "BXDynMsgDetailModel.h"
#import "BXdynSystemplusModel.h"
#import "BXDynTopicModel.h"
#import "BXGradientButton.h"
#import "BXHHEmoji.h"
#import "BXHMovieModel.h"
#import "BXLiveUser.h"
#import "BXLocation.h"
#import "BXMusicModel.h"
#import "BXSavePhotoHelper.h"
#import "BXSLSearchHistoryCell.h"
#import "BXSLSearchManager.h"
#import "BXTopicModel.h"
#import "BXVideoRangeSlider.h"
#import "BXVideoRecordProcessView.h"
#import "CustShareView.h"
#import "DetailSendcomCollectionViewCell.h"
#import "BXDynTopicSearchCell.h"
#import "HHHttpAnchorRequest.h"
#import "HttpMakeFriendRequest.h"
#import "NewHttpManager.h"
#import "NewHttpRequestHuang.h"
#import "NewHttpRequestPort.h"
#import "ShareManager.h"
#import "ShareScrollView.h"
#import "SharePopView.h"
#import "SLAppInfoConst.h"
#import "SLAppInfoMacro.h"
#import "SLUpLoadAndDownloadTools.h"
#import "GHDynCommentFooterView.h"
#import "BXDynCommentModel.h"
#import "BXDynAlertRemoveSoundView.h"
#import "BXHHEmojiView.h"
#import "BXHHEmojiFlowLayout.h"
#import "BXHHEmojiCell.h"
#import "BXCommentView.h"
#import "BXCommentCell.h"
#import "TMShopHTTPRequest.h"
#import "BXDynTipOffVC.h"
#import "SLDivideLineView.h"
//定义英雄榜、魅力榜类型
typedef enum : NSUInteger {
    SLLiveRankListTypeCharmRank=0,
    SLLiveRankListTypeAllHourRank,
    SLLiveRankListTypeHostContributionRank,
} SLLiveRankListType;

//定义刷新类型
typedef enum : NSUInteger {
    SLRefreshTypeNone,
    SLRefreshTypeHeader,
    SLRefreshTypeFooter,
} SLRefrshType;

//定义添加商品类型   SLLiveAddGoodsTypeLiving 直播中添加商品
//定义添加商品类型   SLLiveAddGoodsTypeLiveBefore 开播前添加商品
typedef enum : NSUInteger {
    SLLiveAddGoodsTypeLiving,
    SLLiveAddGoodsTypeLiveBefore,
} SLLiveAddGoodsType;

typedef NS_ENUM(NSInteger,DSSpeedMode) {
    SpeedMode_VerySlow,
    SpeedMode_Slow,
    SpeedMode_Standard,
    SpeedMode_Quick,
    SpeedMode_VeryQuick,
};

#endif /* SLAppInfo_h */
