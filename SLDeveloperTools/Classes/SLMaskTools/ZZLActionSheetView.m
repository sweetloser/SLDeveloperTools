//
//  ZZLActionSheetView.m
//  BXlive
//
//  Created by bxlive on 2018/4/18.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "ZZLActionSheetView.h"
#import "../SLMacro/SLMacro.h"
#define Space 10

@interface ZZLActionSheetView () <UITableViewDelegate, UITableViewDataSource>

/** 头部视图 */
@property (nonatomic, strong) UIView *headView;

/** 背景蒙层 */
@property (nonatomic, strong) UIView *maskView;

/** 数组元素 */
@property (nonatomic, strong) NSArray *dataSource;

/** 取消文字 */
@property (nonatomic, copy) NSString *cancelTitle;

@property (nonatomic, copy)sl_ActionSheetCancelBlock  cancelBlock;

@property (nonatomic, copy) sl_ActionSheetselectBlock selectBlock;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZZLActionSheetView

- (instancetype)initWithTitleView:(UIView *)titleView
                       optionsArr:(NSArray *)optionsArr
                      cancelTitle:(NSString *)cancelTitle
                      cancelBlock:(sl_ActionSheetCancelBlock)cancelBlock
                      selectBlock:(sl_ActionSheetselectBlock)selectBlock {
    
    
    if (self = [super init]) {
        
        self.dataSource = [NSArray array];
        self.headView = titleView;
        self.dataSource = optionsArr;
        self.cancelTitle = cancelTitle;
        self.cancelBlock = cancelBlock;
        self.selectBlock = selectBlock;
        
        [self createUI];
        
    }
    return self;
    
}

- (void)createUI
{
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.maskView];
    [self addSubview:self.tableView];
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor clearColor];
    }
    return _maskView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 44.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = RGB(246, 246, 246);
        _tableView.separatorInset = UIEdgeInsetsMake(0, -50, 0, 0);
        _tableView.layer.cornerRadius = 10;
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = self.dataSource[indexPath.row];
        
        if (indexPath.row == self.dataSource.count-1) {
            
            UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, __kWidth-Space*2, cell.contentView.frame.size.height) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
            CAShapeLayer *shaper = [[CAShapeLayer alloc] init];
            shaper.frame = cell.contentView.bounds;
            shaper.path = bezier.CGPath;
            cell.layer.mask = shaper;
        }
    }
    else
    {
        cell.textLabel.text = self.cancelTitle;
        cell.layer.cornerRadius = 10;
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? self.dataSource.count : 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(Space, 10, __kWidth-2*Space, Space)];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return Space;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (self.selectBlock) {
            self.selectBlock(indexPath.row);
            [self dismissView];
        }
        
    }
    else
    {
        self.cancelBlock();
        [self dismissView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self showView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissView];
}

- (void)showView
{
    self.tableView.frame = CGRectMake(Space, __kHeight, __kWidth-2*Space, self.tableView.rowHeight*(self.dataSource.count+1)+self.tableView.tableHeaderView.frame.size.height+2*Space);
    
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect rect = self.tableView.frame;
        
        rect.origin.y =__kHeight  - self.tableView.bounds.size.height-__kBottomAddHeight;
        
        self.tableView.frame = rect;
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
    }];
}

- (void)dismissView
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.tableView.frame;
        
        rect.origin.y += self.tableView.bounds.size.height;
        
        self.tableView.frame = rect;
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

@end
