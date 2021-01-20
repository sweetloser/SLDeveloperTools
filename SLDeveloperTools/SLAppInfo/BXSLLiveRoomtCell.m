#import "BXSLLiveRoomtCell.h"
#import <YYImage/YYImage.h>
#import "BXSLCircleRippleView.h"
#import <Lottie/Lottie.h>
#import "SLAppInfoConst.h"
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import "../SLCategory/SLCategory.h"
#import "../SLMacro/SLMacro.h"
#import <SDWebImage/SDWebImage.h>
#import "../SLUtilities/SLUtilities.h"
#import <YYCategories/YYCategories.h>

//#import "BXPersonHomeVC.h"

@interface BXSLLiveRoomtCell ()

@property (nonatomic, strong) UIImageView *IconBTN;//主播头像
@property (nonatomic, strong) UILabel *nameL;//主播名字
@property (nonatomic, strong) UILabel *timeL;//时间
@property (nonatomic, strong) UILabel *placeL;//主播位置
@property (nonatomic, strong) UILabel *peopleCountL;//在线人数
@property (nonatomic, strong) UIImageView *imageV;//显示大图
@property (nonatomic, strong) LOTAnimationView *statusAnimation;//直播状态
@property (nonatomic, strong) UIImageView *statusAnimationBGImgV;
@property (strong, nonatomic) UILabel *titleLb;
@property (nonatomic, strong) UIView *headView;//头部view

@end

@implementation BXSLLiveRoomtCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //头部视图
        self.headView = [[UIView alloc]initWithFrame:CGRectZero];
        self.headView.backgroundColor = [UIColor clearColor];
        
        BXSLCircleRippleView *circleRippleView = [[BXSLCircleRippleView alloc]initWithFrame:CGRectMake(__ScaleWidth(0), __ScaleWidth(0), __ScaleWidth(75), __ScaleWidth(75))];
        [self.headView addSubview:circleRippleView];
        
        //大图
        self.imageV = [[UIImageView alloc]init];
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        self.imageV.clipsToBounds = YES;
        self.imageV.layer.masksToBounds = YES;
        self.imageV.layer.cornerRadius = __ScaleWidth(12);
        [self.contentView sd_addSubviews:@[self.headView,self.imageV]];
        //直播状态
//        lc_home_hot_living_bg
        self.statusAnimationBGImgV = [UIImageView new];
        self.statusAnimationBGImgV.image = CImage(@"lc_home_hot_living_bg");
        [self.imageV addSubview:self.statusAnimationBGImgV];
        [self.statusAnimationBGImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(96);
            make.height.mas_equalTo(23);
            make.top.mas_equalTo(0);
        }];
//        self.statusAnimationBGImgV.sd_layout.leftSpaceToView(self.backImageView, 0).topSpaceToView(self.backImageView, 0).widthIs(96).heightIs(23);
        self.statusAnimation = [LOTAnimationView animationNamed:@"Live_status_new"];
        [self.statusAnimationBGImgV addSubview:self.statusAnimation];
        [self.statusAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(54);
            make.height.mas_equalTo(18);
            make.left.mas_equalTo(5);
            make.centerY.mas_equalTo(0);
        }];
//        self.statusAnimation.sd_layout.leftSpaceToView(self.imageV, 0).topSpaceToView(self.imageV, 0).widthIs(54).heightIs(18);
        self.statusAnimation.contentMode =UIViewContentModeScaleToFill;
        self.statusAnimation.loopAnimation =YES;//是否循环动画
        [self.statusAnimation play];//开始动画
        
        UIView *bottomView = [[UIView alloc]init];
        bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
        
        self.titleLb = [UILabel initWithFrame:CGRectZero size:14 color:[UIColor whiteColor] alignment:0 lines:0];
        self.titleLb.font = [UIFont boldSystemFontOfSize:14];
        
        //头像
        self.IconBTN = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.IconBTN.layer.masksToBounds = YES;
        self.IconBTN.layer.cornerRadius = __ScaleWidth(23);
        //名字
//        self.nameL = [UILabel initWithFrame:CGRectZero size:14 color:MainTitleColor alignment:NSTextAlignmentLeft lines:1];
        self.nameL = [UILabel createLabelWithFrame:CGRectZero BackgroundColor:SLClearColor Text:@"" Font:SLBFont(16) TextColor:sl_textColors];
        //时间
        self.timeL = [UILabel initWithFrame:CGRectZero size:11 color:MinorColor alignment:NSTextAlignmentLeft lines:1];
        //位置
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imageView.image = [UIImage imageNamed:@"home_location"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.placeL = [UILabel initWithFrame:CGRectZero size:12 color:MinorColor alignment:NSTextAlignmentRight lines:1];//自适应宽度
        
        //在线人数
        self.peopleCountL = [UILabel initWithFrame:CGRectZero size:12 color:sl_textSubColors alignment:NSTextAlignmentRight lines:1];
        self.peopleCountL.font = SLPFFont(14);
        
//        UILabel *label = [UILabel initWithFrame:CGRectZero text:@"围观" size:14 color:sl_textSubColors alignment:NSTextAlignmentRight lines:1 shadowColor:[UIColor clearColor]];
//        [label setFont:SLPFFont(14)];
        UIButton *toBtn = [[UIButton alloc]init];
        [toBtn addTarget:self action:@selector(toPersonalHome) forControlEvents:BtnTouchUpInside];
        
        [self.headView sd_addSubviews:@[self.IconBTN,self.nameL,self.timeL,imageView,self.placeL,self.peopleCountL,toBtn]];
        
        self.headView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(__ScaleWidth(75));
        
        self.IconBTN.sd_layout.leftSpaceToView(self.headView, __ScaleWidth(14.5)).topSpaceToView(self.headView, __ScaleWidth(14.5)).widthIs(__ScaleWidth(46)).heightIs(__ScaleWidth(46));
        
        self.nameL.sd_layout.leftSpaceToView(self.IconBTN, __ScaleWidth(14.5)).topSpaceToView(self.headView, __ScaleWidth(14.5)).rightSpaceToView(imageView, __ScaleWidth(10)).heightIs(__ScaleWidth(22));
        
        self.timeL.sd_layout.leftSpaceToView(self.IconBTN, __ScaleWidth(14.5)).topSpaceToView(self.nameL, __ScaleWidth(5)).widthIs(__ScaleWidth(150)).heightIs(__ScaleWidth(17));
        
        self.placeL.sd_layout.rightSpaceToView(self.headView, __ScaleWidth(12)).widthIs(75).heightIs(__ScaleWidth(20)).centerYEqualToView(self.nameL);
        
        imageView.sd_layout.rightSpaceToView(self.placeL, __ScaleWidth(5)).widthIs(__ScaleWidth(11)).heightIs(__ScaleWidth(13)).centerYEqualToView(self.placeL);
        
//        label.sd_layout.rightSpaceToView(self.headView, 10).widthIs(30).heightIs(13).centerYEqualToView(self.timeL);
        
        self.peopleCountL.sd_layout.rightSpaceToView(self.headView, __ScaleWidth(12)).leftSpaceToView(self.timeL, __ScaleWidth(10)).heightIs(__ScaleWidth(20)).centerYEqualToView(self.timeL);
                
        self.imageV.sd_layout.leftSpaceToView(self.contentView, __ScaleWidth(12)).topSpaceToView(self.headView, 0).rightSpaceToView(self.contentView, __ScaleWidth(12)).heightIs(__ScaleWidth(359));
        [self.imageV addSubview:bottomView];

        [bottomView addSubview:self.titleLb];
        bottomView.sd_layout.leftSpaceToView(self.imageV, 0).rightSpaceToView(self.imageV, 0).bottomSpaceToView(self.imageV, 0).heightIs(45);
        self.titleLb.sd_layout.leftSpaceToView(bottomView, 10).topSpaceToView(bottomView, 0).bottomSpaceToView(bottomView, 0).rightSpaceToView(bottomView, 10);
        toBtn.sd_layout.topEqualToView(self.IconBTN).leftEqualToView(self.IconBTN).bottomEqualToView(self.IconBTN).rightEqualToView(self.timeL);
        
        [circleRippleView startAnimation];
    }
    return self;
}

- (void)setLiveRoom:(BXSLLiveRoom *)liveRoom {
    _liveRoom = liveRoom;
    
    _nameL.text = liveRoom.nickname;
    _timeL.text = liveRoom.create_time;
    _peopleCountL.text = [NSString stringWithFormat:@"%@  围观",[liveRoom.audience stringValue]];
    [_IconBTN sd_setImageWithURL:[NSURL URLWithString:liveRoom.avatar] placeholderImage:[UIImage imageNamed:@"placeplaceholder"]];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:liveRoom.cover_url] placeholderImage:CImage(@"movie-bitmap")];
    
    _placeL.text = [NSString stringWithFormat:@"%@",liveRoom.city];
    CGFloat width = [BXCalculate calculateRowWidth:_placeL.text Font:SLPFFont(14)];
    _placeL.sd_layout.widthIs(width);
    
    self.titleLb.superview.hidden = IsNilString(liveRoom.title);
    self.titleLb.text = liveRoom.title;
}

- (void)toPersonalHome {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BXDynMsgDetailModel2PersonHome object:nil userInfo:@{@"user_id":_liveRoom.user_id,@"isShow":@"",@"nav":self.viewController.navigationController}];
    
//    [BXPersonHomeVC toPersonHomeWithUserId:_liveRoom.user_id isShow:nil nav:self.viewController.navigationController handle:nil];
}

+(BXSLLiveRoomtCell *)cellWithTableView:(UITableView *)tableView{
    BXSLLiveRoomtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
    if (!cell) {
        cell = [[BXSLLiveRoomtCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCell"];
    }
    return cell;
}

@end
