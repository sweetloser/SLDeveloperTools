//
//  BXliveSelectSpeedView.m
//  BXlive
//
//  Created by bxlive on 2019/4/17.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXVideoSelectSpeedView.h"
#import "HMSegmentedControl.h"

@interface BXVideoSelectSpeedView ()

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@end

@implementation BXVideoSelectSpeedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
        self.layer.cornerRadius = frame.size.height / 2;
        self.layer.masksToBounds = YES;
        
        _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:self.bounds];
        _segmentedControl.backgroundColor = [UIColor clearColor];
        _segmentedControl.sectionTitles = @[@"极慢", @"慢速", @"标准", @"快速", @"极快"];;
        _segmentedControl.selectedSegmentIndex = 0;
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = (frame.size.height - __ScaleWidth(14));
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor sl_colorWithHex:0xF8F8F8],NSFontAttributeName:SLPFFont(__ScaleWidth(14)),NSParagraphStyleAttributeName:paragraphStyle};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName :sl_textColors,NSFontAttributeName:SLPFFont(__ScaleWidth(14)),NSParagraphStyleAttributeName:paragraphStyle};
        _segmentedControl.selectionIndicatorColor = [UIColor sl_colorWithHex:0xFFFFFF];
        _segmentedControl.selectionIndicatorBoxColor = [UIColor sl_colorWithHex:0xFFFFFF];
        _segmentedControl.selectionIndicatorBoxOpacity = 1;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        [self addSubview:_segmentedControl];
        
        CALayer *selectionIndicatorBoxLayer = [_segmentedControl valueForKey:@"_selectionIndicatorBoxLayer"];
        selectionIndicatorBoxLayer.cornerRadius = frame.size.height/2.0;
        selectionIndicatorBoxLayer.masksToBounds = YES;
        
        WS(ws);
        [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
            if (ws.didSelectedSpeed) {
                ws.didSelectedSpeed(index);
            }
        }];
    }
    return self;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    _segmentedControl.selectedSegmentIndex = index;
}

@end
