//
//  BXHHEmojiView.m
//  BXlive
//
//  Created by bxlive on 2018/9/21.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "BXHHEmojiView.h"
#import "BXHHEmojiCell.h"
#import "BXHHEmojiFlowLayout.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import <Masonry/Masonry.h>

@interface BXHHEmojiView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) BXHHEmojiFlowLayout *flowLayout;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *allEmoji;
@property (strong, nonatomic) NSArray *emojis;
@property (strong, nonatomic) UIButton *delBtn;
@end

@implementation BXHHEmojiView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _allEmoji = [NSMutableArray array];
        
        UIView *lastView = nil;
        for (NSInteger i = 0; i < 2; i++) {
            NSString *imageName = [NSString stringWithFormat:@"emoji_%d",i + 1];
            
            UIButton *typeBtn = [[UIButton alloc]init];
            [typeBtn setImage:CImage(imageName) forState:BtnNormal];
            [typeBtn addTarget:self action:@selector(typeAction:) forControlEvents:BtnTouchUpInside];
            typeBtn.tag = 200 + i;
            [self addSubview:typeBtn];
            [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(25);
                make.bottom.mas_equalTo(-12 - __kBottomAddHeight);
                if (lastView) {
                    make.left.mas_equalTo(lastView.mas_right).offset(35);
                } else {
                    make.left.mas_equalTo(15);
                }
            }];
            if (!i) {
                typeBtn.enabled = NO;
            }
            lastView = typeBtn;
        }
        self.exclusiveTouch = YES;
        self.delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.delBtn.exclusiveTouch = YES;
        [self.delBtn setImage:CImage(@"emoji_del") forState:BtnNormal];
        [self.delBtn setBackgroundImage:[UIImage imageWithColor:[UIColor sl_colorWithHex:0xf0f0f0]] forState:UIControlStateHighlighted];
//        [delBtn setImage:CImage(@"emoji_del_1") forState:UIControlStateHighlighted | BtnSelected];
//        delBtn.backgroundColor = [UIColor redColor];
        [self.delBtn addTarget:self action:@selector(delAction) forControlEvents:BtnTouchUpInside];
        [self addSubview:self.delBtn];
        [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(lastView);
            make.width.mas_equalTo(33 * 20.0 / 24);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(-15);
        }];
        
        CGFloat height = self.height - 49 - __kBottomAddHeight;
        NSInteger count = floorf(height / 52);
        CGFloat itemWidth = self.width / 7;
        CGFloat itemHeight = height / count;

        BXHHEmojiFlowLayout *flowLayout = [[BXHHEmojiFlowLayout alloc]init];
        flowLayout.rowNum = 7;
        flowLayout.colNum = count;
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _flowLayout = flowLayout;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[BXHHEmojiCell class] forCellWithReuseIdentifier:@"Cell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(lastView.mas_top).offset(-12);
        }];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"InnerStickersInfo" ofType:@"plist"];
            NSArray *array = [NSArray arrayWithContentsOfFile:path];
            for (NSDictionary *dic in array) {
                NSMutableArray *tempArray = [NSMutableArray array];
                NSArray *emoticons = dic[@"emoticons"];
                for (NSDictionary *theDic in emoticons) {
                    BXHHEmoji *emoji = [[BXHHEmoji alloc]init];
                    [emoji updateWithJsonDic:theDic];
                    [tempArray addObject:emoji];
                }
                [self.allEmoji addObject:tempArray];
            }
            if (self.allEmoji.count >= 2) {
                self.emojis = self.allEmoji[0];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        });
        
        self.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadView];
}

- (void)reloadView {
    CGFloat height = self.height - 49 - __kBottomAddHeight;
    NSInteger count = floorf(height / 52);
    if (count > 0) {
        if (_flowLayout.itemSize.height != height) {
            _flowLayout.colNum = count;
            _flowLayout.itemSize = CGSizeMake(self.width / 7, height / count);
            [_collectionView reloadData];
        }
    }
}

- (void)typeAction:(UIButton *)sender {
    if (_allEmoji.count >= 2) {
        _emojis = _allEmoji[sender.tag - 200];
        for (NSInteger i = 0; i < 2; i++) {
            UIButton *typeBtn = [self viewWithTag:200 +i];
            typeBtn.enabled = YES;
        }
        sender.enabled = NO;
        [_collectionView reloadData];
    }
}

- (void)delAction {
    if (_delEmoji) {
        _delEmoji();
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _emojis.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BXHHEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.emoji = _emojis[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_didGetEmoji) {
        _didGetEmoji(_emojis[indexPath.row]);
    }
}

@end
