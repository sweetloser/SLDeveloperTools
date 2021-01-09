//
//  BXHMovieModel.h
//  BXlive
//
//  Created by huang on 2017/12/21.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "BaseObject.h"
#import "BXLocation.h"
#import "BXActivity.h"
#import "BXMusicModel.h"
#import "BXCommentModel.h"

@interface BXHMovieModel : BaseObject

@property (copy, nonatomic) NSString *movieID;            //电影 ID
@property (copy, nonatomic) NSString *describe;           //内容
@property (copy, nonatomic) NSString *video_url;          //电影 URL
@property (copy, nonatomic) NSString *cover_url;          //封面 URL
@property (copy, nonatomic) NSString *animate_url;        //封面动图 URL
@property (copy, nonatomic) NSString *duration;           //时长
@property (copy, nonatomic) NSString *play_sum;           //电影播放次数
@property (copy, nonatomic) NSString *is_collect;         //是否收藏过  1是 0否
@property (copy, nonatomic) NSString *is_zan;             //是否赞过 1是 0否
@property (copy, nonatomic) NSString *is_self;            //是否是自己发布的
@property (copy, nonatomic) NSString *width;              //封面宽度
@property (copy, nonatomic) NSString *height;             //封面高度
@property (copy, nonatomic) NSString *file_size;          //影片大小
@property (nonatomic, copy) NSString *zan_sum;            //电影赞数
@property (nonatomic, copy) NSString *publish_time;       //发布时间
@property (nonatomic, copy) NSString *share_sum;          //电影分享数
@property (nonatomic, copy) NSString *comment_sum;        //评论个数
@property (copy, nonatomic) NSString *status;             //审核状态 1是已通过
@property (copy, nonatomic) NSString *status_desc;        //审核状态描述
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *jump;
@property (copy, nonatomic) NSString *is_ad;         //0不是广告 1app下载广告 2网页广告
@property (copy, nonatomic) NSString *ad_url;        //广告链接
@property (copy, nonatomic) NSString *goods_id;        //是否展示商品 0表示不展示
@property (copy, nonatomic) NSString *goods_type;        //是否展示商品 0表示不展示
@property (copy, nonatomic) NSString *shop_type;        //购买商铺类型
@property (copy, nonatomic) NSString *short_title;  //商品标题

@property (nonatomic, copy) NSString *treasure_chest;       //是否有宝箱
@property (nonatomic, strong) NSMutableArray *rewardUsers;  //打赏者

@property (strong, nonatomic) BXLocation *location;       //发布视频所在位置信息
@property (nonatomic, copy) NSString *is_synchro;   //是否保存到动态
@property (strong, nonatomic) NSMutableArray *friends;    //@friends
@property (strong, nonatomic) NSMutableArray *topics;     //@topics
@property (strong, nonatomic) NSMutableArray *commentlist;
@property (copy, nonatomic) NSString *user_id;            //该电影发布人的ID
@property (copy, nonatomic) NSString *nickname;           //昵称
@property (nonatomic, copy) NSString *avatar;             //头像
@property (nonatomic, copy) NSString *is_follow;          //是否关注
@property (nonatomic, copy) NSString *room_id;            //直播间id
@property (nonatomic, copy) NSString *is_live;            //是否在直播
@property (nonatomic, assign) CGFloat textHeight;            //文字高度
@property (nonatomic, strong) BXActivity *activity;
@property (nonatomic, strong) BXMusicModel *bgMusic;

@property (nonatomic, copy) NSString *film_size;          //影片大小
@property (copy, nonatomic) NSString *channel;           //分类
@property (copy, nonatomic) NSString *videoPath;         //本地路径
@property (strong, nonatomic) UIImage *coverImage;         //封面图片
@property (strong, nonatomic)NSString *lng;//经纬度
@property (strong, nonatomic)NSString *lat;//经纬度
@property (strong, nonatomic)NSString *location_name;
@property (strong, nonatomic)NSString *visible;//可见
@property (strong, nonatomic)NSString *music_id;
@property (nonatomic, copy) NSString * region_level;
@property (strong, nonatomic)NSString *topic;//话题
@property (strong, nonatomic)NSString *friendes;//好友
@property (copy, nonatomic) NSString *sign;              //上传签名
@property (assign, nonatomic) CGFloat progress;          //上传进度
@property (copy, nonatomic) NSString *uploadType;        //上传状态  0：等待上传， 1：正在上传 2：上传到腾讯云失败 3：通知服务器失败 4：上传成功

@property (nonatomic, assign) CGFloat replayTimeSp;

@property (nonatomic, copy) void (^didFinishedLayout)();
@property (nonatomic, assign) CGFloat bottomSpace;

@property (nonatomic, assign) BOOL isPlay;
- (NSInteger)getScalingModeWithScreenHeight:(CGFloat)screenHeight;
- (CGFloat)getRate;

@end
