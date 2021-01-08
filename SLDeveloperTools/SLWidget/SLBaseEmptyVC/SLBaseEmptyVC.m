//
//  SLBaseEmptyVC.m
//  BXlive
//
//  Created by sweetloser on 2020/5/9.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLBaseEmptyVC.h"
#import "../../SLNetTools/SLNetTools.h"
#import "../../SLMacro/SLMacro.h"
#import "BXNoNetworkView.h"

@interface SLBaseEmptyVC ()
@end

@implementation SLBaseEmptyVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma - mark DZNEmptyDataSetSource
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    if ([SLHttpManager sl_sharedNetManager].netStatus > 0) {
        return nil;
    } else {
        WS(ws);
        BXNoNetworkView *noNetworkView = [[BXNoNetworkView alloc]initWithHeight:290];
        noNetworkView.needRefresh = ^{
            if (ws.refreshBlock) {
                ws.refreshBlock();
            }
        };
        return noNetworkView;
    }                                                                                
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"空页面状态"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"";
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    [attributes setObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    [attributes setObject:MinorColor forKey:NSForegroundColorAttributeName];
    [attributes setValue:paragraph forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributeString;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}


@end
