//
//  BXTreasureChestDetailView.m
//  BXlive
//
//  Created by bxlive on 2019/4/25.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXTreasureChestDetailView.h"
#import "BXTreasureChestCell.h"
#import "BXTreasureChestGift.h"
#import <Lottie/Lottie.h>
#import "NewHttpManager.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import "../SLMaskTools/SLMaskTools.h"
#import <Masonry/Masonry.h>

@interface BXTreasureChestDetailView () <UITableViewDataSource>

@property (nonatomic, strong) LOTAnimationView *animationView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *gifts;

@property (nonatomic, assign) BOOL isAddTap;
@property (nonatomic, assign) NSInteger tapCount;

@property (nonatomic, copy) NSString *videoId;

@end


@implementation BXTreasureChestDetailView

- (void)getOpenRewardDetail {
    [NewHttpManager openRewardWithVideoId:_videoId diggNum:[NSString stringWithFormat:@"%ld",_tapCount] success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        if (flag) {
            NSArray *dataArr = jsonDic[@"data"];
            if (dataArr && [dataArr isArray]) {
                for (NSDictionary *dic in dataArr) {
                    BXTreasureChestGift *gift = [[BXTreasureChestGift alloc]init];
                    [gift updateWithJsonDic:dic];
                    [self.gifts addObject:gift];
                    [self.tableView reloadData];
                }
            }
        } else {
            [self closeAction];
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self closeAction];
        [BGProgressHUD showInfoWithMessage:@"开启宝箱失败"];
    }];
    
}

- (instancetype)initWithVideoId:(NSString *)videoId {
    if ([super init]) {
        self.frame = CGRectMake(0, 0, __kWidth, __kHeight);
        _videoId = videoId;
        _gifts = [NSMutableArray array];
        
        UIView *maskView = [[UIView alloc]init];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
        [self addSubview:maskView];
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [maskView addGestureRecognizer:tap];
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake((__kWidth - 317) / 2, (__kHeight - 428) / 2 + __kTopAddHeight - 15, 317, 428)];
        _contentView.hidden = YES;
        [self addSubview:_contentView];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = CImage(@"treasureChest_bg");
        [_contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _contentView.width, 32)];
        _tableView = [[UITableView alloc]init];
        _tableView.tableHeaderView = headerView;
        _tableView.rowHeight = 34;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        [_contentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-30);
            make.left.mas_equalTo(39);
            make.right.mas_equalTo(-41);
            make.height.mas_equalTo(237 + 7 - 30);
        }];
        
        UIView *footerView = [[UIView alloc]init];
        [_contentView addSubview:footerView];
        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.tableView);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        
        UILabel *declarationLb = [[UILabel alloc]init];
        declarationLb.text = @"申明：本活动与苹果公司无关";
        declarationLb.font = CFont(10);
        declarationLb.textAlignment = NSTextAlignmentCenter;
        declarationLb.textColor = CHHCOLOR_D(0x906632);
        [footerView addSubview:declarationLb];
        [declarationLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
        }];
        
        UIView *topMaskView = [[UIView alloc]init];
        topMaskView.backgroundColor = CHHCOLOR_D(0xDAC5C5);
        [_contentView addSubview:topMaskView];
        [topMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.tableView);
            make.height.mas_equalTo(7);
        }];
        
        UIButton *closeBtn = [[UIButton alloc]init];
        [closeBtn setImage:CImage(@"treasureChest_close") forState:BtnNormal];
        [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:BtnTouchUpInside];
        [_contentView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(24);
            make.top.mas_equalTo(28);
            make.right.mas_equalTo(-43);
        }];
    }
    return self;
}

- (void)closeAction {
    [self removeFromSuperview];
}

- (void)tapAction {
    if (_isAddTap) {
        _tapCount++;
        
        UILabel *textLb = [[UILabel alloc]initWithFrame:CGRectMake(self.width / 2 - 40 , self.height / 2 - 10 - 40, 80, 20)];
        textLb.font = CBFont(25);
        textLb.textAlignment = NSTextAlignmentCenter;
        textLb.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_1"]];
        textLb.text = [NSString stringWithFormat:@"+%ld",_tapCount];
        [self addSubview:textLb];
        
        CGFloat ty = textLb.y;
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -ty);
        transform = CGAffineTransformScale(transform, 3, 3);
        [UIView animateWithDuration:1.0 animations:^{
            textLb.alpha = 0;
            textLb.transform = transform;
        } completion:^(BOOL finished) {
            [textLb removeFromSuperview];
        }];
    }
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    if (_animationView) {
        [_animationView removeFromSuperview];
        [_animationView stop];
    }
    WS(ws);
    _animationView = [LOTAnimationView animationNamed:@"openTreasureChest"];
    _animationView.frame = CGRectMake(0, 0, 800.0 / 3, 300);
    _animationView.center = self.center;
    _animationView.contentMode = UIViewContentModeScaleAspectFit;
    _animationView.userInteractionEnabled = NO;
    _animationView.completionBlock = ^(BOOL animationFinished) {
        [ws animationEnd];
    };
    [self addSubview:_animationView];
    [_animationView play];
    
    _isAddTap = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isAddTap = NO;
        [self getOpenRewardDetail];
    });
}

- (void)animationEnd {
    self.contentView.hidden = NO;
    if (_animationView) {
        [_animationView stop];
        [_animationView removeFromSuperview];
        _animationView = nil;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _gifts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BXTreasureChestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[BXTreasureChestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.gift = _gifts[indexPath.row];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
