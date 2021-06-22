#import "ListCollection.h"
#import "listCell.h"
#import "listModel.h"
#import "SLOnLineUserReusableView.h"
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <SLDeveloperTools/SLDeveloperTools.h>

@interface ListCollection ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(strong, nonatomic)UICollectionView *listCollectionview;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property(nonatomic,strong)NSMutableArray *listArray;

@property(nonatomic,strong)NSArray *guardData;

@property(strong, nonatomic)SLOnLineUserReusableView *hV;

@end
@implementation ListCollection

-(void)updateListData{
    [self loadData:self.room_id];
}

//懒加载
-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

-(instancetype)initWithID:(NSString *)roomId{
    self = [super init];
    if (self) {
        [self listCollectionview];
        self.room_id = roomId;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOnLineNum) name:@"updateOnLineNum" object:nil];
    }
    return self;
}
-(void)loadData:(NSString *)room_id{
    
    NSDictionary *params = @{@"room_id":room_id};
    [[NewHttpManager sharedNetManager] POST:@"s=Room.onlineAudience" parameters:params success:^(id  _Nonnull responseObject) {
        NSString *code = responseObject[@"code"];
        if (![code integerValue]) {
            [self.listArray removeAllObjects];
            NSArray *data = responseObject[@"data"];
            if ([data isArray]) {
                if (data && data.count) {
                    for (NSDictionary *dic in data) {
                        listModel *model = [listModel modelWithDic:dic];
                        [self.listArray addObject:model];
                    }
                }
            }
        }
        [self.listCollectionview reloadData];
    } failure:^(NSError * _Nonnull error) {
    }];
}
-(void)updateOnLineNum{
    [self loadData:self.room_id];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(UICollectionView *)listCollectionview{
    if (!_listCollectionview) {
        UICollectionViewFlowLayout *flowlayoutt = [[UICollectionViewFlowLayout alloc]init];
        flowlayoutt.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _listCollectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowlayoutt];
        _listCollectionview.showsHorizontalScrollIndicator = NO;
        _listCollectionview.delegate = self;
        _listCollectionview.dataSource = self;
        [_listCollectionview registerClass:[listCell class] forCellWithReuseIdentifier:@"listCell"];
        [_listCollectionview registerClass:[SLOnLineUserReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SLOnLineUserReusableView"];
        _listCollectionview.backgroundColor = [UIColor clearColor];
        _listCollectionview.layer.masksToBounds = YES;
        [self addSubview:_listCollectionview];
        [_listCollectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _gradientLayer = [[CAGradientLayer alloc] init];
        _gradientLayer.colors = @[
                                  (__bridge id)[UIColor colorWithWhite:0 alpha:0.05f].CGColor,
                                  (__bridge id)[UIColor colorWithWhite:0 alpha:1.0f].CGColor
                                  ];
        _gradientLayer.locations = @[@0, @0.4];
        _gradientLayer.startPoint = CGPointMake(1, 0.5);
        _gradientLayer.endPoint = CGPointMake(0, 0.5);
        _gradientLayer.frame = _listCollectionview.frame;
//        self.layer.mask = _gradientLayer;
    }
    return _listCollectionview;

}

-(void)guardAction{
    if (self.headerGuardClick) {
        self.headerGuardClick();
    }
}

-(void)updateGuardData:(NSArray *)guardData;{
    
//    更新守护
    self.guardData = [NSArray arrayWithArray:guardData];
    
    [self.hV updateGuardData:self.guardData];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _gradientLayer.frame = _listCollectionview.frame;
}
//用户列表
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listArray.count;
}
//定义section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    if (self.listArray.count == 0) {
    return CGSizeMake(40*3,40);
//    }
//    return CGSizeZero;
}

//返回一个头部视图（当当前没有人再直播间的时候，显示头部视图，
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        _hV = (SLOnLineUserReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SLOnLineUserReusableView" forIndexPath:indexPath];
//        3个守护
        WS(weakSelf);
        _hV.guardActionBlock = ^{
            [weakSelf guardAction];
        };
        if (self.guardData) {
            [_hV updateGuardData:self.guardData];
        }
        return _hV;
    }
    return nil;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    listCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"listCell" forIndexPath:indexPath];
    listModel *model = self.listArray[indexPath.row];
    cell.model = model;
    [cell loadCellData:model indexPath:indexPath];
    return cell;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    listModel *model = [self.listArray objectAtIndex:indexPath.row];
    NSDictionary *subdic  = [NSDictionary dictionaryWithObjects:@[model.user_id,model.nickname] forKeys:@[@"id",@"name"]];
    [self.delegate GetInformessage:subdic];
}
//每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(35,40);
}

@end
