//
//  BXTopicModel.m
//  BXlive
//
//  Created by bxlive on 2019/2/22.
//  Copyright © 2019 cat. All rights reserved.
//

#import "BXTopicModel.h"
#import <YYText/YYText.h>
#import "../SLMacro/SLMacro.h"

@implementation BXTopicModel

+(NSDictionary *)replacedKeyFromPropertyName{
   return @{@"tid":@"id"};
}

- (NSMutableAttributedString *)descrAttri {
    if (!_descrAttri) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:_descr];
        attri.yy_font = CFont(13);
        attri.yy_color = CHHCOLOR_D(0x99A1A1);
        attri.yy_lineSpacing = 5;
        _descrAttri = attri;
    }
    return _descrAttri;
}

- (CGFloat)descrAttriHeight {
    if (_isOpen) {
        _descrAttriHeight = self.descrAttriOriginalHeight;
    } else {
        _descrAttriHeight = self.descrAttriLimitHeight;
    }
    return _descrAttriHeight;
}

- (CGFloat)descrAttriLimitHeight {
    if (self.descrAttri.length) {
        if (!_descrAttriLimitHeight) {
            _descrAttriLimitHeight = [self getAttributedTextHeightWithAttributedText:self.descrAttri width:__kWidth - 32 maximumNumberOfRows:4];
        }
    } else {
        _descrAttriLimitHeight = 0;
    }
    
    return _descrAttriLimitHeight;
}

- (CGFloat)descrAttriOriginalHeight {
    if (self.descrAttri.length) {
        if (!_descrAttriOriginalHeight) {
            _descrAttriOriginalHeight = [self getAttributedTextHeightWithAttributedText:self.descrAttri width:__kWidth - 32 maximumNumberOfRows:0];
        }
    } else {
        _descrAttriOriginalHeight = 0;
    }
    return _descrAttriOriginalHeight;
}

- (CGFloat)getAttributedTextHeightWithAttributedText:(NSAttributedString *)attributedText width:(CGFloat)width maximumNumberOfRows:(NSInteger)maximumNumberOfRows {
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    container.maximumNumberOfRows = maximumNumberOfRows;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedText];
    return layout.textBoundingSize.height;
}

@end
