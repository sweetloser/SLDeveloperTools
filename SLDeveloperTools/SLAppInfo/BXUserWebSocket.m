//
//  BXUserWebSocket.m
//  BXlive
//
//  Created by bxlive on 2017/10/12.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "BXUserWebSocket.h"
#import "JsonHelper.h"
#import "BXLiveUser.h"
#import "BXAppInfo.h"
#import "SLThreadMacro.h"

@interface BXUserWebSocket()<SRWebSocketDelegate>

@property (strong, nonatomic) BXLiveUser *liveUser;

@property (nonatomic,strong)SRWebSocket *webSocket;
@property (nonatomic,weak)NSTimer *timer;
@property (nonatomic,assign)NSTimeInterval overtime;
@property (nonatomic, assign)NSUInteger reconnectCount;
@property (nonatomic, assign)NSUInteger connectNum;
@property (nonatomic,copy)NSString *urlString;

@property (strong, nonatomic) NSTimer *pongTimer;
@property (nonatomic, assign) NSInteger time;

@end

@implementation BXUserWebSocket

- (instancetype)init{
    if (self = [super init]) {
        self.connectNum = 0;
        self.overtime = 1;
        self.reconnectCount = 0;
        _liveUser = [BXLiveUser currentBXLiveUser];
    }
    return self;
}

- (void)addSocketListen:(NSDictionary *)dic{
    [self open:dic[@"chatSever"]];
    self.urlString = dic[@"chatSever"];
}

- (void)startPongTimer {
    sl_dispatch_main_async_safe(^{
        [self stopPongTimer];
        
        self.time = 30;
        self.pongTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(pongTimerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.pongTimer forMode:NSRunLoopCommonModes];
    });
}

- (void)pongTimerAction {
    _time -= 5;
    if (_time <= 0) {
        NSDictionary *params = @{@"act":@"heart"};
        [self executionWithParams:params close:NO mod:nil];
    }
}

- (void)stopPongTimer {
    sl_dispatch_main_async_safe(^{
        if (self.pongTimer) {
            [self.pongTimer invalidate];
            self.pongTimer = nil;
        }
    });
}

#pragma mark -- private method
- (void)open:(id)params{
    NSLog(@"params = %@",params);
    NSString *urlStr = nil;
    if ([params isKindOfClass:[NSString class]]) {
        urlStr = (NSString *)params;
    }else if([params isKindOfClass:[NSTimer class]]){
        NSTimer *timer = (NSTimer *)params;
        urlStr = [timer userInfo];
    }
    self.urlString = urlStr;
    if (self.webSocket) {
        [self.webSocket close];
        self.webSocket.delegate = nil;
    }
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    self.webSocket.delegate = self;
    [self.webSocket open];
}
- (void)reconnect{
    // 计数+1
    if (self.reconnectCount < 10) {
        self.reconnectCount ++;
        self.connectNum = 1;
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.overtime target:self selector:@selector(open:) userInfo:self.urlString repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    
    } else {
        NSLog(@"Websocket Reconnected Outnumber ReconnectCount");
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        return;
    }
}

#pragma mark -- SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"Websocket Connected");
    [self.delegate successConnect:self.connectNum];
    // 开启成功后重置重连计数器
    self.reconnectCount = 0;
    self.connectNum = 0;
    [self startPongTimer];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@":( Websocket Failed With Error %@", error);
    // 重连
    [self reconnect];
    [self stopPongTimer];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    message = [self stringFromHexString:message];
    NSDictionary *dict = [JsonHelper jsonObjectFromJsonString:message];
    if (!dict) {
        return;
    }
    NSLog(@"message%@====sokcet信息%@",message,dict);
    NSString *emit = dict[@"emit"];
    if ([emit isEqualToString:@"tipMsg"]) {
        //1、消息提示事件
        if (self.delegate && [self.delegate respondsToSelector:@selector(tipMsg:)]) {
            [self.delegate tipMsg:dict];
        }
    } else if([emit isEqualToString:@"systemMsg"]) {
        //2、系统消息2
        if (self.delegate && [self.delegate respondsToSelector:@selector(systemMsg:)]) {
            [self.delegate systemMsg:dict];
        }
    } else if([emit isEqualToString:@"chatMsg"]) {
        //3、发送消3
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatMsg:)]) {
            [self.delegate chatMsg:dict];
        }
    } else if([emit isEqualToString:@"enterMsg"]) {
        //4、用户进来4
        if (self.delegate && [self.delegate respondsToSelector:@selector(enterMsg:)]) {
            [self.delegate enterMsg:dict];
        }
    } else if([emit isEqualToString:@"giftMsg"]) {
        //5、礼物消息事件5
        if (self.delegate && [self.delegate respondsToSelector:@selector(giftMsg:)]) {
            [self.delegate giftMsg:dict];
        }
    } else if([emit isEqualToString:@"lightMsg"]) {
        //6、用户点亮6
        if (self.delegate && [self.delegate respondsToSelector:@selector(lightMsg:)]) {
            [self.delegate lightMsg:dict];
        }
    } else if([emit isEqualToString:@"shutupMsg"]) {
        //7、禁言消息事件7
        if (self.delegate && [self.delegate respondsToSelector:@selector(shutupMsg:)]) {
            [self.delegate shutupMsg:dict];
        }
    } else if([emit isEqualToString:@"kickingMsg"]) {
         //8、踢人消息事件
        if (self.delegate && [self.delegate respondsToSelector:@selector(kickingMsg:)]) {
            [self.delegate kickingMsg:dict];
        }
    } else if([emit isEqualToString:@"kicking"]) {
        //8.1、踢人事件
        if (self.delegate && [self.delegate respondsToSelector:@selector(kicking:)]) {
            [self.delegate kicking:dict];
        }
    } else if([emit isEqualToString:@"cuckooInfo"]) {
        //9、用户账户余额消息事件
        if (self.delegate && [self.delegate respondsToSelector:@selector(cuckooInfo:)]) {
            [self.delegate cuckooInfo:dict];
        }
    } else if([emit isEqualToString:@"onlineTotal"]) {
        //10、实时在线观众数据消息事件
        if (self.delegate && [self.delegate respondsToSelector:@selector(onlineTotal:)]) {
            [self.delegate onlineTotal:dict];
        }
    } else if([emit isEqualToString:@"showGift"]) {
        //11、用户赠送礼物数据事件
        if (self.delegate && [self.delegate respondsToSelector:@selector(showGift:)]) {
            [self.delegate showGift:dict];
        }
    } else if ([emit isEqualToString:@"showLighting"]){
        //12、用户点亮消息事件
        if (self.delegate && [self.delegate respondsToSelector:@selector(showLighting:)]) {
            [self.delegate showLighting:dict];
        }
    } else if ([emit isEqualToString:@"close"]){
        //13、关闭直播间通知事件
        if (self.delegate && [self.delegate respondsToSelector:@selector(close:)]) {
            [self.delegate close:dict];
        }
    } else if ([emit isEqualToString:@"superClose"]){
        //14、强制关播
        if (self.delegate && [self.delegate respondsToSelector:@selector(superClose:)]) {
            [self.delegate superClose:dict];
        }
    } else if ([emit isEqualToString:@"exit"]){
        //15、用户退出直播间事件
        if (self.delegate && [self.delegate respondsToSelector:@selector(exit:)]) {
            [self.delegate exit:dict];
        }
    } else if ([emit isEqualToString:@"broadCast"]){
        //16、公屏广播事件
        if (self.delegate && [self.delegate respondsToSelector:@selector(broadCast:)]) {
            [self.delegate broadCast:dict];
        }
    } else if ([emit isEqualToString:@"followMsg"]){
        //关注
        if (self.delegate && [self.delegate respondsToSelector:@selector(followMsg:)]) {
            [self.delegate followMsg:dict];
        }
    } else if ([emit isEqualToString:@"controlMsg"]){
        //场控
        if (self.delegate && [self.delegate respondsToSelector:@selector(setAdminControll:)]) {
            [self.delegate setAdminControll:dict];
        }
    } else if ([emit isEqualToString:@"kickRoom"]){
        //多端登录
        if (self.delegate && [self.delegate respondsToSelector:@selector(kickRoom:)]) {
            [self.delegate kickRoom:dict];
        }
    } else if ([emit isEqualToString:@"switchMode"]){
        //主播更改直播间设置成功
        if (self.delegate && [self.delegate respondsToSelector:@selector(switchMode:)]) {
            [self.delegate switchMode:dict];
        }
    } else if ([emit isEqualToString:@"livePay"]){
        //计费收费
        if (self.delegate && [self.delegate respondsToSelector:@selector(livePay:)]) {
            [self.delegate livePay:dict];
        }
    } else if ([emit isEqualToString:@"askPk"]){
        //询问是否接受pk请求
        if (self.delegate && [self.delegate respondsToSelector:@selector(askPk:)]) {
            [self.delegate askPk:dict];
        }
    } else if ([emit isEqualToString:@"beginPk"]){
        //开启pk
        if (self.delegate && [self.delegate respondsToSelector:@selector(beginPk:)]) {
            [self.delegate beginPk:dict];
        }
    } else if ([emit isEqualToString:@"pking"]){
        //pk进行中状态
        if (self.delegate && [self.delegate respondsToSelector:@selector(pking:)]) {
            [self.delegate pking:dict];
        }
    } else if ([emit isEqualToString:@"pkResult"]){
        //pk结果
        if (self.delegate && [self.delegate respondsToSelector:@selector(pkResult:)]) {
            [self.delegate pkResult:dict];
        }
    } else if ([emit isEqualToString:@"acing"]){
        //pk结束交流或惩罚中状态
        if (self.delegate && [self.delegate respondsToSelector:@selector(acing:)]) {
            [self.delegate acing:dict];
        }
    } else if ([emit isEqualToString:@"endPk"]){
        //pk结束
        if (self.delegate && [self.delegate respondsToSelector:@selector(endPk:)]) {
            [self.delegate endPk:dict];
        }
    } else if ([emit isEqualToString:@"updatePkEnergy"]){
        //送礼物时pk能量值事件
        if (self.delegate && [self.delegate respondsToSelector:@selector(updatePkEnergy:)]) {
            [self.delegate updatePkEnergy:dict];
        }
    } else if ([emit isEqualToString:@"pkMsg"]) {
        //pk信息 拒绝、超时、占线或系统错误
        if (self.delegate && [self.delegate respondsToSelector:@selector(pkMsg:)]) {
            [self.delegate pkMsg:dict];
        }
    } else if ([emit isEqualToString:@"h5Msg"]) {
        //pk信息 拒绝、超时、占线或系统错误
        if (self.delegate && [self.delegate respondsToSelector:@selector(h5Msg:)]) {
            [self.delegate h5Msg:dict];
        }
    } else if ([emit isEqualToString:@"refresh_reply_linkmic"]) {
        //刷新连麦
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshReplyLinkMic:)]) {
            [self.delegate refreshReplyLinkMic:dict];
        }
    } else if ([emit isEqualToString:@"invite_link_mic"]) {
        //邀请加入连麦
        if (self.delegate && [self.delegate respondsToSelector:@selector(inviteLinkMic:)]) {
            [self.delegate inviteLinkMic:dict];
        }
    } else if ([emit isEqualToString:@"build_link_mic"]) {
        //建立连麦
        if (self.delegate && [self.delegate respondsToSelector:@selector(buildLinkMic:)]) {
            [self.delegate buildLinkMic:dict];
        }
    } else if ([emit isEqualToString:@"deny_link_mic"]) {
        //拒绝连麦
        if (self.delegate && [self.delegate respondsToSelector:@selector(denyLinkMic:)]) {
            [self.delegate denyLinkMic:dict];
        }
    } else if ([emit isEqualToString:@"finish_link_mic"]) {
        //完成连麦
        if (self.delegate && [self.delegate respondsToSelector:@selector(finishLinkMic:)]) {
            [self.delegate finishLinkMic:dict];
        }
    }else if([emit isEqualToString:@"switchAddGoods"]) {
//        增加
        if (self.delegate && [self.delegate respondsToSelector:@selector(liveGoodsOperationComplete:)]){
            [self.delegate liveGoodsOperationComplete:dict];
        }
    }else if([emit isEqualToString:@"switchDelGoods"]) {
//        删除
        if (self.delegate && [self.delegate respondsToSelector:@selector(liveGoodsOperationComplete:)]){
            [self.delegate liveGoodsOperationComplete:dict];
        }
    }else if ([emit isEqualToString:@"switchTopGoods"]) {
//        置顶
        if (self.delegate && [self.delegate respondsToSelector:@selector(liveGoodsOperationComplete:)]){
            [self.delegate liveGoodsOperationComplete:dict];
        }
    }else if([emit isEqualToString:@"switchSayGoods"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(liveGoodsOperationComplete:)]){
            [self.delegate liveGoodsOperationComplete:dict];
        }
    }else if ([emit isEqualToString:@"switchCancelSayGoods"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(liveGoodsOperationComplete:)]){
            [self.delegate liveGoodsOperationComplete:dict];
        }
    }else if([emit isEqualToString:@"switchListGoods"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(PlayGoodsOperationComplete:)]) {
            [self.delegate PlayGoodsOperationComplete:dict];
        }
    }else if([emit isEqualToString:@"switchSellGoods"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(liveGoodsOperationComplete:)]){
            [self.delegate liveGoodsOperationComplete:dict];
        }
    }else if([emit isEqualToString:@"lotteryMsg"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(getrewardwithroomid:)]){
            [self.delegate getrewardwithroomid:dict];
        }
    }else if([emit isEqualToString:@"adminSystemMsg"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(adminSystemMsg:)]) {
            [self.delegate adminSystemMsg:dict];
        }
    }
/*
 {
     code : 0,
     data : {
     live_status : 4,
     room_id : 11344,
     goods : [
     {
     goods_id : 27
 }
 ]
 },
     msg : 置顶成功,
     emit : switchTopGoods
 }*/
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"Closed Reason:%@  code = %zd",reason,code);
    [self close];
    
    self.reconnectCount = 0;
    self.connectNum = 0;
    [self reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSString *str =  [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSString *str1 = [[NSString alloc] initWithBytes:pongPayload.bytes length:pongPayload.length encoding:NSUTF8StringEncoding];
    NSLog(@"收到pong:%@--%@--%@",pongPayload,str,str1);
}
- (void)close{
    [self.webSocket close];
    self.webSocket = nil;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self stopPongTimer];
}

- (void)executionWithParams:(NSDictionary *)params close:(BOOL)close mod:(NSString *)mod{
    _time = 30;
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:params];
    tempDic[@"mod"] = mod ? mod : @"Live";
    tempDic[@"api_v"] = @"v2";
    NSDictionary *signDic = @{@"token":[BXAppInfo appInfo].access_token, @"user_id":[self getUserId]};
    tempDic[@"sign"] = signDic;
    NSLog(@"==============:%@",tempDic);
    NSString *jsonStr = [JsonHelper jsonStringWithObject:tempDic];
    jsonStr = [self hexStringFromString:jsonStr];
    if (self.webSocket) {
        // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
        if (self.webSocket.readyState == SR_OPEN) {
            [self.webSocket send:jsonStr];
            if (close) {
                [self close];
            }
        }
    }
}

#pragma mark - 获取页面轮播公告
-(void)gerLotteryMsg:(NSDictionary *)dict{
    
    NSDictionary *pagrams = @{@"act" : @"getReward" , @"args" :dict};
    [self executionWithParams:pagrams close:NO mod:nil];
}

//用户进入直播间
- (void)enterRoom:(NSDictionary *)dict {
    NSString *pkid = dict[@"pk_id"];
    if (!pkid) {
        pkid = @"";
    }
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"from":dict[@"from"], @"user_id":[self getUserId],@"pk_id":pkid};
    NSDictionary *params = @{@"act":@"enter", @"args":args};
    [self executionWithParams:params close:NO mod:nil];
}

//用户上下滑动切换直播间
- (void)switchRoom:(NSDictionary *)dict {
    NSString *pkid = dict[@"pk_id"];
    if (!pkid) {
        pkid = @"";
    }
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"from":dict[@"from"], @"user_id":[self getUserId],@"pk_id":pkid};
    NSDictionary *params = @{@"act":@"switchRoom", @"args":args};
    [self executionWithParams:params close:NO mod:nil];
}

//重连
- (void)joinagainRoom:(NSDictionary *)dict {
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"user_id":[self getUserId]};
    NSDictionary *params = @{@"act":@"joinAgain", @"args":args};
    [self executionWithParams:params close:NO mod:nil];
}

//主播创建直播间
- (void)createRoom:(NSDictionary *)dict{
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"user_id":[self getUserId]};
    NSDictionary *params = @{@"act":@"create", @"args":args};
    [self executionWithParams:params close:NO mod:nil];
}

//用户发送聊天消息
- (void)sendMsgs:(NSDictionary *)dict {
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"user_id":[self getUserId], @"type":dict[@"type"], @"content":dict[@"content"]};
    NSDictionary *params = @{@"act":@"sendMsg", @"args":args};
    [self executionWithParams:params close:NO mod:nil];
}

//用户执行赠送礼物操作
- (void)sendGifts:(NSDictionary *)dict {
    NSString *pkid = dict[@"pk_id"];
    if (!pkid) {
        pkid = @"";
    }
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"user_id":[self getUserId], @"gift_id":dict[@"gift_id"], @"gift_amount":dict[@"gift_amount"],@"pk_id":pkid,@"type":dict[@"type"]};
    NSDictionary *params = @{@"act":@"sendGift", @"args":args};
    [self executionWithParams:params close:NO mod:nil];
}

//用户点击直播间屏幕执行点亮操作
- (void)sendLighting:(NSDictionary *)dict {
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"user_id":[self getUserId]};
    NSDictionary *params = @{@"act":@"sendLighting", @"args":args};
    [self executionWithParams:params close:NO mod:nil];
}

//用户在直播间内关注主播且关注成功后
- (void)sendFollow:(NSDictionary *)dict{
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"user_id":[self getUserId]};
    NSDictionary *params = @{@"act":@"sendFollow", @"args":args};
    [self executionWithParams:params close:NO mod:nil];
}

//主播/场控/超管/守护在直播间内禁言其它普通用户成功后
- (void)sendShutups:(NSDictionary *)dict {
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"user_id":[self getUserId], @"target_id":dict[@"user_id"]};
    NSDictionary *params = @{@"act":@"sendShutup", @"args":args};
    [self executionWithParams:params close:NO mod:nil];
}

//主播/场控/超管/守护在直播间内踢出其它普通用户成功后
- (void)sendKicking:(NSDictionary *)dict {
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"user_id":[self getUserId], @"target_id":dict[@"user_id"]};
    NSDictionary *params = @{@"act":@"sendKicking", @"args":args};
    [self executionWithParams:params close:NO mod:nil];
}

//主播关闭成功后
- (void)close:(NSDictionary *)dict {
    NSString *pkid = dict[@"pk_id"];
    if (!pkid) {
        pkid = @"";
    }
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"user_id":[self getUserId], @"type":dict[@"type"],@"pk_id":pkid};
    NSDictionary *params = @{@"act":@"close", @"args":args};
    [self executionWithParams:params close:YES mod:nil];
}

//用户关闭/退出直播间
- (void)quit:(NSDictionary *)dict{
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"user_id":[self getUserId]};
    NSDictionary *params = @{@"act":@"exitRoom", @"args":args};
    [self executionWithParams:params close:YES mod:nil];
}

//主播切换后台或由后台切换前台时
- (void)enterBack:(NSDictionary *)dict {
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"user_id":[self getUserId], @"status":dict[@"status"]};
    NSDictionary *params = @{@"act":@"change", @"args":args};
    [self executionWithParams:params close:NO mod:nil];
}

//场控
- (void)controlMsg:(NSDictionary *)dict {
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"user_id":[self getUserId], @"target_id":dict[@"user_id"]};
    NSDictionary *params = @{@"act":@"sendControl", @"args":args};
    [self executionWithParams:params close:NO mod:nil];
}

//主播更改直播间设置
- (void)switchRoomMode:(NSDictionary *)dict{
//    事件说明：type为直播间类型(0普通、1密码、2收费、3计费、4VIP、5等级)，type_val为类型所对应的值收费类型时
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"type":dict[@"type"], @"type_val":dict[@"type_val"]};
    NSDictionary *params = @{@"act":@"switchRoomMode", @"args":args};
    [self executionWithParams:params close:NO mod:nil];
}

//客户端主动发送计费收费
- (void)payByLive:(NSDictionary *)dict {
//    返回：{"emit": "livePay", "code": "0" ,"data": {"type":"1","type_val":"所扣费用"}, "msg":"支付成功或失败信息"}
//code:0表操作成功、1代表操作失败、1005代表余额不足
//    事件说明：type为直播间类型(2收费、3计费)
    
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"type":dict[@"type"]};
    NSDictionary *params = @{@"act":@"payByLive", @"args":args};
    [self executionWithParams:params close:NO mod:nil];
}
//系统匹配PK
- (void)systemMatch:(NSDictionary *)dict{
    NSDictionary *args = @{@"pk_type":dict[@"pk_type"]};
    NSDictionary *params = @{@"act":@"systemMatch", @"args":args};
    [self executionWithParams:params close:NO mod:@"Pk"];
}

//主动方发起Pk请求
- (void)requestPk:(NSDictionary *)dict{
    NSDictionary *args = @{@"target_id":dict[@"target_id"],@"pk_duration":dict[@"pk_duration"],@"pk_topic":dict[@"pk_topic"],@"ac_topic":dict[@"ac_topic"],@"pk_type":dict[@"pk_type"]};
    NSDictionary *params = @{@"act":@"requestPk", @"args":args};
    [self executionWithParams:params close:NO mod:@"Pk"];
}
//接收方开启Pk
- (void)startPk:(NSDictionary *)dict{
    NSDictionary *args = @{@"active_id":dict[@"active_id"], @"target_id":dict[@"target_id"],@"pk_type":dict[@"pk_type"]};
    NSDictionary *params = @{@"act":@"startPk", @"args":args};
    [self executionWithParams:params close:NO mod:@"Pk"];
}
//拒绝Pk请求
- (void)refusePk:(NSDictionary *)dict{
    NSDictionary *args = @{@"active_id":dict[@"active_id"]};
    NSDictionary *params = @{@"act":@"refusePk", @"args":args};
    [self executionWithParams:params close:NO mod:@"Pk"];
}
//主动结束pk
- (void)endPk:(NSDictionary *)dict{
    NSDictionary *args = @{@"pk_id":dict[@"pk_id"]};
    NSDictionary *params = @{@"act":@"endPk", @"args":args};
    [self executionWithParams:params close:NO mod:@"Pk"];
}
//验证pk
- (void)verifyPk:(NSDictionary *)dict {
    NSDictionary *args = @{@"pk_id":dict[@"pk_id"]};
    NSDictionary *params = @{@"act":@"verifyPk", @"args":args};
    [self executionWithParams:params close:NO mod:@"Pk"];
}

#pragma - mark LinkMic
//请求连麦
- (void)replyLinkMic:(NSDictionary *)dict {
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"type":dict[@"type"]};
    NSDictionary *params = @{@"act":@"reply", @"args":args};
    [self executionWithParams:params close:NO mod:@"LinkMic"];
}
//允许连麦
- (void)allowLinkMic:(NSDictionary *)dict {
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"link_mic_id":dict[@"link_mic_id"]};
    NSDictionary *params = @{@"act":@"allow", @"args":args};
    [self executionWithParams:params close:NO mod:@"LinkMic"];
}
//拒绝连麦
- (void)denyLinkMic:(NSDictionary *)dict {
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"link_mic_id":dict[@"link_mic_id"]};
    NSDictionary *params = @{@"act":@"deny", @"args":args};
    [self executionWithParams:params close:NO mod:@"LinkMic"];
}
//完成连麦
- (void)finishLinkMic:(NSDictionary *)dict {
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"link_mic_id":dict[@"link_mic_id"]};
    NSDictionary *params = @{@"act":@"finish", @"args":args};
    [self executionWithParams:params close:NO mod:@"LinkMic"];
}
//邀请连麦
- (void)inviteLinkMic:(NSDictionary *)dict {
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"invite_uid":dict[@"invite_uid"], @"type":dict[@"type"]};
    NSDictionary *params = @{@"act":@"invite", @"args":args};
    [self executionWithParams:params close:NO mod:@"LinkMic"];
}

//验证连麦
- (void)verifyLinkMic:(NSDictionary *)dict {
    NSDictionary *args = @{@"room_id":dict[@"room_id"], @"link_mic_id":dict[@"link_mic_id"]};
    NSDictionary *params = @{@"act":@"verifyLinkMic", @"args":args};
    [self executionWithParams:params close:NO mod:@"LinkMic"];
}

#pragma mark - 直播带货
//添加商品 + 删除商品 + 讲解商品
- (void)liveGoodsOperation:(NSDictionary *)dict {
    NSDictionary *args;
    if (dict[@"content"]) {
        args = @{@"room_id":dict[@"room_id"], @"user_id":[self getUserId], @"goods_type":dict[@"goods_type"], @"goods_id":dict[@"goods_id"],@"live_status":dict[@"live_status"],@"content":dict[@"content"]};
    }else{
        args = @{@"room_id":dict[@"room_id"], @"user_id":[self getUserId], @"goods_type":dict[@"goods_type"], @"goods_id":dict[@"goods_id"],@"live_status":dict[@"live_status"]};
    }
    NSDictionary *params = @{@"act":@"switchLiveGoods", @"args":args};
    [self executionWithParams:params close:NO mod:nil];
}

- (NSString *)getUserId {
    return _liveUser.user_id;
}

- (void)dealloc{
    // Close WebSocket
    [self close];
}


#pragma - mark tool
//字符串转换成16进制的字符
- (NSString *)hexStringFromString:(NSString *)string {
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];//16进制数
        if([newHexStr length]==1) {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        } else {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    return hexStr;
}

//16进制转换成字符串
- (NSString *)stringFromHexString:(NSString *)hexString {
    if (!hexString.length) {
        return hexString;
    }
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for(int i = 0; i < [hexString length] - 1; i += 2){
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    free(myBuffer);
    return unicodeString;
}

@end
