//
//  QuickRechargePopView.m
//  BXlive
//
//  Created by bxlive on 2018/9/14.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "QuickRechargePopView.h"
#import "QuickRechargeCell.h"
#import "QuickRechargeView.h"
#import <YYLabel.h>
#import <IAPHelper/IAPShare.h>
#import "MybgCodeModel.h"
#import "HHAppStoreReceiptSqliteTool.h"
#import "TimeHelper.h"
#import "ZZLActionSheetView.h"
#import "BXPayManager.h"
#import "QuickRechargeFootView.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "SLDeveloperTools.h"


@interface QuickRechargePopView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic ,assign) NSInteger currentIndex;
@property (nonatomic ,copy) NSString *totalBalance;
@property (nonatomic,assign)NSIndexPath *selectIndexPath;
@property (nonatomic,strong)NSString *selectPayType;

@property(nonatomic,assign)CGFloat raito;

@end

@implementation QuickRechargePopView

- (instancetype)initWithShareObject {
    self = [super initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    if (self) {
        self.raito = MIN(SCREEN_WIDTH, SCREEN_HEIGHT) / 375.f;
        
        UIView *maskView = [[UIView alloc]initWithFrame:self.bounds];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
        [self addSubview:maskView];
        _selectPayType = @"alipay_app";
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, __kHeight, __kWidth, 372 + __kBottomAddHeight)];
        if (SCREEN_WIDTH > SCREEN_HEIGHT) {
            contentView.width = self.raito * 375.f;
            contentView.height = self.raito*372;
            contentView.x = SCREEN_WIDTH - contentView.width;
            contentView.y = SCREEN_HEIGHT - contentView.height;
        }else{
            contentView.width = self.raito * 375.f;
            contentView.height = self.raito*372+__kBottomAddHeight;
            contentView.x = SCREEN_WIDTH - contentView.width;
            contentView.y = SCREEN_HEIGHT - contentView.height;
        }
        
        contentView.transform = CGAffineTransformMakeTranslation(0, contentView.height);
        
        contentView.backgroundColor = [UIColor sl_colorWithHex:0xf4f4f4];
        contentView.layer.cornerRadius = 8.0;
        contentView.layer.masksToBounds = YES;
        [self addSubview:contentView];
        _contentView = contentView;
        self.currentIndex = 0;
        self.totalBalance = @"";
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.itemSize = CGSizeMake((self.contentView.size.width-16*4)/3, 55);
        _flowLayout.minimumLineSpacing = 16;
        _flowLayout.minimumInteritemSpacing = 15;
        _collectionView = [[UICollectionView alloc] initWithFrame:contentView.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor sl_colorWithHex:0xffffff];
        _collectionView.showsVerticalScrollIndicator = NO ;
        
        [contentView addSubview:_collectionView];
        [self.collectionView registerClass:[QuickRechargeCell class] forCellWithReuseIdentifier:@"QuickRechargeCell"];
        [self.collectionView registerClass:[QuickRechargeView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QuickRechargeView"];
        [self.collectionView  registerClass:[QuickRechargeFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reusableViews"];
        _collectionView.bounces = NO;
        [self loadData];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundTap)];
        [maskView addGestureRecognizer:tap];
    }
    return self;
}


-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)loadData{
    [[NewHttpRequestHuang sharedNewHttpRequestHuang]RechargeIndexWithSuccess:^(id responseObject) {
        if ([responseObject[@"code"]intValue]==0) {
            [self.dataArray removeAllObjects];
            self.totalBalance = responseObject[@"data"][@"bean"];
            for (NSDictionary *theDic in responseObject[@"data"][@"list"]) {
                MybgCodeModel *model = [MybgCodeModel objectWithDictionary:theDic];
                [self.dataArray addObject:model];
            }
        }
        [self.collectionView reloadData];
    } Failure:^(NSError *error) {
    }];
}




- (void)backgroundTap  {
    if (self.closeView) {
        self.closeView(self.totalBalance);
    }
    [self removeFromSuperview];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QuickRechargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QuickRechargeCell" forIndexPath:indexPath];
    if (self.currentIndex == indexPath.item) {
        [cell setSelect:YES];
    }else{
        [cell setSelect:NO];
    }
    cell.model = self.dataArray[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.item;
    [collectionView reloadData];
}
-(void)order_type:(NSString *)order_type order_no:(NSString *)order_no pay_method:(NSString *)pay_method{
    [[NewHttpRequestPort sharedNewHttpRequestPort] ThirdOrderUnifiedorder:@{@"order_no":order_no,@"order_type":order_type,@"pay_method":pay_method} Success:^(id responseObject) {
        if ([responseObject[@"code"]intValue]==0) {
            if (IsEquallString(pay_method, @"alipay_app")) {
                [self third_data:responseObject[@"data"][@"third_data"]];
            }else{
                
                [self appid:responseObject[@"data"][@"third_data"][@"appid"] partnerid:responseObject[@"data"][@"third_data"][@"partnerid"] package:responseObject[@"data"][@"third_data"][@"package"] noncestr:responseObject[@"data"][@"third_data"][@"noncestr"] timestamp:responseObject[@"data"][@"third_data"][@"timestamp"] prepayid:responseObject[@"data"][@"third_data"][@"prepayid"] sign:responseObject[@"data"][@"third_data"][@"sign"]];
            }
        }
    } Failure:^(NSError *error) {
        
    }];
}

-(void)third_data:(NSString *)third_data{
    
    BXPayManager *manager = [BXPayManager getInstance];
    [manager aliPayOrder:third_data scheme:Scheme_URL respBlock:^(NSInteger respCode, NSString *respMsg) {
        NSLog(@"%ld--%@",respCode,respMsg);
        //处理支付结果
        [self loadData];
    }];
    
}
-(void)appid:(NSString *)appid partnerid:(NSString *)partnerid
     package:(NSString *)package noncestr:(NSString *)noncestr
   timestamp:(NSString *)timestamp prepayid:(NSString *)prepayid sign:(NSString *)sign{
    BXPayManager *manager = [BXPayManager getInstance];
    [manager wechatPayWithAppId:appid partnerId:partnerid prepayId:prepayid  package:package nonceStr:noncestr timeStamp:timestamp sign:sign respBlock:^(NSInteger respCode, NSString *respMsg) {
        NSLog(@"%ld--%@",respCode,respMsg);
        
        [self loadData];
    }];
}


- (void)buyTestWithProduct
{
    NSMutableSet *dataSet = [NSMutableSet set];
    for (MybgCodeModel *model in self.dataArray) {
        [dataSet addObject:model.apple_id];
    }
    if([IAPShare sharedHelper].iap) {
        [dataSet unionSet:[IAPShare sharedHelper].iap.productIdentifiers];
    }
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    //测试环境 打包上线时改为YES
    BOOL mode = YES;//正式版本
#ifdef DEBUG
    mode = NO;//测试版本
#endif
    [IAPShare sharedHelper].iap.production = mode;
    // 请求商品信息
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if(response.products.count > 0 ) {
             MybgCodeModel *model = self.dataArray[self.currentIndex];
             SKProduct *product = nil;
             for (SKProduct *t in response.products) {
                 if ([model.apple_id isEqualToString:t.productIdentifier]) {
                     product = t;
                     break;
                 }
             }
             if (!product) {
                 return;
             }
             //发起购买请求
             [BGProgressHUD showLoadingWithMessage:nil];
             [[IAPShare sharedHelper].iap buyProduct:product
                                        onCompletion:^(SKPaymentTransaction* trans){
                                            [BGProgressHUD hidden];
                                            if(trans.error)
                                            {
                                                [BGProgressHUD showInfoWithMessage:@"交易失败"];
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                                NSData *transactionReceiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                                                NSString *receipt = [transactionReceiptData base64EncodedStringWithOptions:0];
                                                
                                                if ([receipt length] > 0) {
                                                    HHAppStoreReceipt *appStoreReceipt = [[HHAppStoreReceipt alloc]init];
                                                    appStoreReceipt.receiptId = [NSString stringWithFormat:@"%ld%u",(long)[TimeHelper getTimeSp],arc4random_uniform(1000)];
                                                    appStoreReceipt.receipt = receipt;
                                                    [HHAppStoreReceiptSqliteTool insertAppStoreReceipt:appStoreReceipt];
                                                    
                                                    [[NewHttpRequestPort sharedNewHttpRequestPort] RechargeappleCreate:@{@"receipt":receipt} Success:^(id responseObject) {
                                                        if ([responseObject[@"code"] integerValue]==0) {
                                                            [HHAppStoreReceiptSqliteTool deleteAppStoreReceipt:appStoreReceipt];
                                                            
                                                            [self backgroundTap];
                                                            [BGProgressHUD showInfoWithMessage:responseObject[@"msg"]];
                                                            
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMooneyCuckoo" object:nil userInfo:@{@"bean":[NSString stringWithFormat:@"%@",responseObject[@"data"][@"bean"]]}];
                                                            BXLiveUser *liveUser = [[BXLiveUser alloc]init];
                                                            liveUser.bean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"bean"]];
                                                            [BXLiveUser setCurrentBXLiveUser:liveUser];
                                                            
                                                            [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                                                        }
                                                    } Failure:^(NSError *error) {
                                                        
                                                    }];
                                                }
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                if (trans.error.code == SKErrorPaymentCancelled) {
                                                }else if (trans.error.code == SKErrorClientInvalid) {
                                                }else if (trans.error.code == SKErrorPaymentInvalid) {
                                                }else if (trans.error.code == SKErrorPaymentNotAllowed) {
                                                }else if (trans.error.code == SKErrorStoreProductNotAvailable) {
                                                }else{
                                                }
                                            }
                                        }];
         }else{
             [BGProgressHUD showInfoWithMessage:@"获取商品信息失败"];
         }
     }];
    
}

-(void)payclicked{
    
    if ([[BXAppInfo appInfo].ios_app_hidden integerValue] == 1) {
        [self buyTestWithProduct];
        return;
    }
    
    MybgCodeModel *model  = self.dataArray[self.currentIndex];
    NSString *pay_method = self.selectPayType;
    
    [[NewHttpRequestPort sharedNewHttpRequestPort] RechargeCreate:@{@"id":model.moneyId} Success:^(id responseObject) {
        if ([responseObject[@"code"]intValue]==0) {
            [self order_type:responseObject[@"data"][@"order_type"] order_no:responseObject[@"data"][@"order_no"]  pay_method:pay_method];
        }
    } Failure:^(NSError *error) {

    }];
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind==UICollectionElementKindSectionHeader) {
        QuickRechargeView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"QuickRechargeView" forIndexPath:indexPath];
        headView.chargeLabel.text = [NSString stringWithFormat:@"%@余额：%@",[BXAppInfo appInfo].app_recharge_unit,self.totalBalance];
        ZZL(weakSelf);
        [headView setCloseView:^{
            [weakSelf backgroundTap];
        }];
        return headView;
        
    }
    if (kind == UICollectionElementKindSectionFooter) {
        QuickRechargeFootView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"reusableViews" forIndexPath:indexPath];
        footerview.chargeLabel.text = [NSString stringWithFormat:@"%@余额：%@",[BXAppInfo appInfo].app_recharge_unit,self.totalBalance];
        MJWeakSelf;
        footerview.typeblocl = ^(NSInteger type) {
            if (type == 0) {
                weakSelf.selectPayType = @"alipay_app";
            }else{
                weakSelf.selectPayType = @"wxpay_app";
            }
        };
        footerview.payblock = ^{
            [weakSelf payclicked];
        };
        return footerview;
    }
    return nil;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(collectionView.bounds.size.width, 175);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 85);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 16, 0, 16);
}

- (void)show:(UIView *)view{
    [view addSubview:self];
    [view bringSubviewToFront:self];
    [UIView animateWithDuration:.5 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}


@end
