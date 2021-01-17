//
//  BXLocationTitleView.m
//  BXlive
//
//  Created by bxlive on 2019/4/15.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXLocationTitleView.h"
#import <Masonry/Masonry.h>
#import "../SLMacro/SLMacro.h"
#import "../SLAppInfo/SLAppInfo.h"
#import "../SLMaskTools/SLMaskTools.h"

@interface BXLocationTitleView ()

@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *countLb;
@property (nonatomic, strong) UIButton *collectionBtn;

@property (nonatomic, strong) UILabel *locationLb;
@property (nonatomic, strong) UILabel *distanceLb;

@end

@implementation BXLocationTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithType:(NSInteger)type {
    if ([super init]) {
        UIView *topView = [[UIView alloc]init];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            if (type) {
                make.height.mas_equalTo(self.mas_height).multipliedBy(.5);
            } else {
                make.height.mas_equalTo(self.mas_height);
            }
        }];
        
        _collectionBtn = [[UIButton alloc]init];
        [_collectionBtn setImage:CImage(@"icon_shouchang_default") forState:BtnNormal];
        [_collectionBtn setImage:CImage(@"icon_shouchang_selected") forState:BtnSelected];
        [_collectionBtn addTarget:self action:@selector(collectionAction) forControlEvents:BtnTouchUpInside];
        [topView addSubview:_collectionBtn];
        [_collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(108);
            make.height.mas_equalTo(32);
            make.right.mas_equalTo(-16);
            make.top.mas_equalTo(20);
        }];
        
        _nameLb = [[UILabel alloc]init];
        _nameLb.textColor = [UIColor whiteColor];
        _nameLb.font = CBFont(20);
        [topView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(self.collectionBtn.mas_left).offset(-10);
            make.top.mas_equalTo(self.collectionBtn);
            make.height.mas_equalTo(24);
        }];
        
        _countLb = [[UILabel alloc]init];
        _countLb.textColor = [UIColor whiteColor];
        _countLb.font = CFont(12);
        [topView addSubview:_countLb];
        [_countLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLb);
            make.top.mas_equalTo(self.nameLb.mas_bottom).offset(12);
            make.height.mas_equalTo(18);
        }];
        
        UIView *topLineView = [[UIView alloc]init];
        topLineView.backgroundColor = [CHHCOLOR_D(0x41474B) colorWithAlphaComponent:.8];
        [topView addSubview:topLineView];
        [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(.5);
        }];
        
        if (type == 1) {
            UIView *bottomView = [[UIView alloc]init];
            [self addSubview:bottomView];
            [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(topView.mas_bottom);
            }];
            
            UIImageView *locationIv = [[UIImageView alloc]init];
            locationIv.image = CImage(@"location-weizhi");
            locationIv.contentMode = UIViewContentModeScaleAspectFit;
            [bottomView addSubview:locationIv];
            [locationIv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(16);
                make.top.mas_equalTo(26);
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(10);
            }];
            
            _locationLb = [[UILabel alloc]init];
            _locationLb.textColor = [UIColor whiteColor];
            _locationLb.font = CFont(14);
            [bottomView addSubview:_locationLb];
            [_locationLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(locationIv.mas_right).offset(10);
                make.right.mas_equalTo(-16);
                make.top.height.mas_equalTo(locationIv);
            }];
            
            _distanceLb = [[UILabel alloc]init];
            _distanceLb.textColor = [UIColor whiteColor];
            _distanceLb.font = CFont(12);
            [bottomView addSubview:_distanceLb];
            [_distanceLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.locationLb.mas_bottom).offset(12);
                make.height.mas_equalTo(16);
                make.left.right.mas_equalTo(self.locationLb);
            }];
            
            
            UIView *bottomLineView = [[UIView alloc]init];
            bottomLineView.backgroundColor = [CHHCOLOR_D(0x41474B) colorWithAlphaComponent:.8];
            [bottomView addSubview:bottomLineView];
            [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(16);
                make.right.mas_equalTo(-16);
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(.5);
            }];
        }
    }
    return self;
}

- (void)setLocation:(BXLocation *)location {
    _location = location;
    _nameLb.text = location.name;
    _countLb.text = location.goto_num;
    _locationLb.text = location.address;
    _distanceLb.text = location.distance_str;
    _collectionBtn.selected = [location.is_collect boolValue];
}

- (void)collectionAction {
    [NewHttpManager collectionAddWithTargetId:_location.location_id type:@"location" success:^(NSDictionary *jsonDic, BOOL flag, NSMutableArray *models) {
        if (flag) {
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
            
            NSDictionary *dataDic = jsonDic[@"data"];
            self.location.is_collect = dataDic[@"status"];
            self.collectionBtn.selected = [self.location.is_collect boolValue];
        } else {
            [BGProgressHUD showInfoWithMessage:jsonDic[@"msg"]];
        }
    } failure:^(NSError *error) {
        [BGProgressHUD showInfoWithMessage:@"操作失败"];
    }];
}

@end
