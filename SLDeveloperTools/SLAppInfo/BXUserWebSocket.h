//
//  BXUserWebSocket.h
//  BXlive
//
//  Created by bxlive on 2017/10/12.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket.h>

@protocol UserSocketDelegate <NSObject>

@optional
//连接成功
- (void)successConnect:(NSUInteger)connectNum;
//1、消息提示事件
- (void)tipMsg:(NSDictionary *)dict;
//2、系统消息2
- (void)systemMsg:(NSDictionary *)dict;
//3、发送消3
- (void)chatMsg:(NSDictionary *)dict;
//4、用户进来4
- (void)enterMsg:(NSDictionary *)dict;
//5、礼物消息事件5
- (void)giftMsg:(NSDictionary *)dict;
//6、用户点亮6
- (void)lightMsg:(NSDictionary *)dict;
//7、禁言消息事件7
- (void)shutupMsg:(NSDictionary *)dict;
//8、踢人消息事件
- (void)kickingMsg:(NSDictionary *)dict;
//8.1、踢人消息事件 客户端响应
- (void)kicking:(NSDictionary *)dict;
//9、用户账户余额消息事件
- (void)cuckooInfo:(NSDictionary *)dict;
//10、实时在线观众数据消息事件
- (void)onlineTotal:(NSDictionary *)dict;
//11、用户赠送礼物数据事件
- (void)showGift:(NSDictionary *)dict;
//12、用户点亮消息事件
- (void)showLighting:(NSDictionary *)dict;
//13、关闭直播间通知事件
- (void)close:(NSDictionary *)dict;
//14、强制关播
- (void)superClose:(NSDictionary *)dict;
//15、用户退出直播间事件
- (void)exit:(NSDictionary *)dict;
//公屏广播事件
- (void)broadCast:(NSDictionary *)dict;
//关注
- (void)followMsg:(NSDictionary *)dict;
//场控
- (void)setAdminControll:(NSDictionary *)dict;
//多端登录
- (void)kickRoom:(NSDictionary *)dict;
//主播更改直播间设置成功
- (void)switchMode:(NSDictionary *)dict;
//执行扣费回调
- (void)livePay:(NSDictionary *)dict;
//HTML显示
- (void)h5Msg:(NSDictionary *)dict;

//询问是否接受pk请求
- (void)askPk:(NSDictionary *)dict;
//pk信息 拒绝、超时、占线或系统错误
- (void)pkMsg:(NSDictionary *)dict;
//开启pk
- (void)beginPk:(NSDictionary *)dict;
//pk进行中状态
- (void)pking:(NSDictionary *)dict;
//pk结果
- (void)pkResult:(NSDictionary *)dict;
//pk结束交流或惩罚中状态
- (void)acing:(NSDictionary *)dict;
//pk结束
- (void)endPk:(NSDictionary *)dict;
//送礼物时pk能量值事件
- (void)updatePkEnergy:(NSDictionary *)dict;

//刷新请求连麦 主播
- (void)refreshReplyLinkMic:(NSDictionary *)dict;
//邀请加入连麦 看播
- (void)inviteLinkMic:(NSDictionary *)dict;
//建立连麦
- (void)buildLinkMic:(NSDictionary *)dict;
//拒绝连麦
- (void)denyLinkMic:(NSDictionary *)dict;
//完成连麦
- (void)finishLinkMic:(NSDictionary *)dict;

-(void)getrewardwithroomid:(NSDictionary *)dict;

//添加 + 删除 + 置顶
- (void)liveGoodsOperationComplete:(NSDictionary *)dict;

#pragma mark - 观众端
-(void)PlayGoodsOperationComplete:(NSDictionary *)dict;


#pragma mark - 公告
-(void)adminSystemMsg:(NSDictionary *)dict;
@end


@interface BXUserWebSocket : NSObject

@property(nonatomic, weak) id<UserSocketDelegate> delegate;
//添加cosket监听
- (void)addSocketListen:(NSDictionary *)dic;
//进入房间
- (void)enterRoom:(NSDictionary *)dict;
//切换直播
- (void)switchRoom:(NSDictionary *)dict;
//主播房间
- (void)createRoom:(NSDictionary *)dict;
//重连
- (void)joinagainRoom:(NSDictionary *)dict;
//用户发送聊天消息
- (void)sendMsgs:(NSDictionary *)dict;
//用户执行赠送礼物操作
- (void)sendGifts:(NSDictionary *)dict;
//用户点击直播间屏幕执行点亮操作
- (void)sendLighting:(NSDictionary *)dict;
//用户在直播间内关注主播且关注成功后
- (void)sendFollow:(NSDictionary *)dict;
//主播/场控/超管/守护在直播间内禁言其它普通用户成功后
- (void)sendShutups:(NSDictionary *)dict;
//主播/场控/超管/守护在直播间内踢出其它普通用户成功后
- (void)sendKicking:(NSDictionary *)dict;
//主播关闭成功后
- (void)close:(NSDictionary *)dict;
//用户关闭/退出直播间
- (void)quit:(NSDictionary *)dict;
//主播切换后台或由后台切换前台时
- (void)enterBack:(NSDictionary *)dict;
//场控
- (void)controlMsg:(NSDictionary *)dict;
//主播更改直播间设置
- (void)switchRoomMode:(NSDictionary *)dict;
//客户端主动发送计费收费
- (void)payByLive:(NSDictionary *)dict;
//系统匹配PK
- (void)systemMatch:(NSDictionary *)dict;
//主动方发起Pk请求
- (void)requestPk:(NSDictionary *)dict;
//接收方开启Pk
- (void)startPk:(NSDictionary *)dict;
//拒绝Pk请求
- (void)refusePk:(NSDictionary *)dict;
//主动结束pk
- (void)endPk:(NSDictionary *)dict;
//验证pk
- (void)verifyPk:(NSDictionary *)dict;
#pragma - mark LinkMic
//请求连麦
- (void)replyLinkMic:(NSDictionary *)dict;
//允许连麦
- (void)allowLinkMic:(NSDictionary *)dict;
//拒绝连麦
- (void)denyLinkMic:(NSDictionary *)dict;
//完成连麦
- (void)finishLinkMic:(NSDictionary *)dict;
//邀请连麦
- (void)inviteLinkMic:(NSDictionary *)dict;
//验证连麦
- (void)verifyLinkMic:(NSDictionary *)dict;

#pragma mark - 直播带货
//添加商品
- (void)liveGoodsOperation:(NSDictionary *)dict;

-(void)gerLotteryMsg:(NSDictionary *)dict;

@end
