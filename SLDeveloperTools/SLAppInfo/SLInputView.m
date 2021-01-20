//
//  SLInputView.m
//  BXlive
//
//  Created by sweetloser on 2020/7/27.
//  Copyright © 2020 cat. All rights reserved.
//

#import "SLInputView.h"
#import "../SLMacro/SLMacro.h"
#import "../SLCategory/SLCategory.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import "BXAppInfo.h"

#define DSInputView_ScreenW    [UIScreen mainScreen].bounds.size.width
#define SLInputView_ScreenH    [UIScreen mainScreen].bounds.size.height
#define DSInputView_StyleLarge_LRSpace 10
#define DSInputView_StyleLarge_TBSpace 8
#define DSInputView_StyleDefault_LRSpace 5
#define DSInputView_StyleDefault_TBSpace 5
#define DSInputView_CountLabHeight __ScaleWidth(16)


#define DSInputView_StyleLarge_Height 181
#define DSInputView_StyleDefault_Height 45

static CGFloat keyboardAnimationDuration = 0.5;

@interface SLInputView()<UITextViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView * textBgView;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) UILabel *placeholderLab;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, assign) InputViewStyle style;
/** 图片 */
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *superView;
@property (strong, nonatomic) UIImageView *cellimageV;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *priceL;
@property (nonatomic, assign) CGRect showFrameDefault;
@property (nonatomic, assign) CGRect sendButtonFrameDefault;
@property (nonatomic, assign) CGRect textViewFrameDefault;

/** 发送按钮点击回调 */
@property (nonatomic, copy) BOOL(^sendBlcok)(NSString *text);

@end

@implementation SLInputView


-(void)dealloc{
    //NSLog(@"SLInputView 销毁");
    if(_style == InputViewStyleDefault){
        [_textView removeObserver:self forKeyPath:@"contentSize"];
    }
}
+(void)showWithStyle:(InputViewStyle)style configurationBlock:(void(^)(SLInputView *inputView))configurationBlock sendBlock:(BOOL(^)(NSString *text))sendBlock{
    SLInputView *inputView = [[SLInputView alloc] initWithStyle:style];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:inputView];
    if(configurationBlock) configurationBlock(inputView);
    inputView.sendBlcok = [sendBlock copy];
    [inputView show];
}
#pragma mark - private
-(void)show{
    if([self.delegate respondsToSelector:@selector(SLInputViewWillShow:)]){
        [self.delegate SLInputViewWillShow:self];
    }
    _textView.text = nil;
    _placeholderLab.hidden = NO;
    
    if(_style == InputViewStyleLarge){
        if(_maxCount>0) {
            NSMutableAttributedString *sA = [self setStringColorWith:[NSString stringWithFormat:@"%ld",(long)0] rangeOfString:[NSString stringWithFormat:@"%ld",(long)0] color:sl_normalColors font:_countLab.font];
            [sA appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%ld",(long)self.maxCount] attributes:@{NSForegroundColorAttributeName: sl_textSubColors}]];
            _countLab.attributedText = sA;
        }
    }
    
    [_textView becomeFirstResponder];
}

-(void)hide{
    
    if([self.delegate respondsToSelector:@selector(SLInputViewWillHide:)]){
        [self.delegate SLInputViewWillHide:self];
    }
    [_textView resignFirstResponder];
}

- (instancetype)initWithStyle:(InputViewStyle)style
{
    self = [super init];
    if (self) {
        
        _style = style;
        /** 创建UI */
        [self  setupUI];
        /** 键盘监听 */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIScreen mainScreen].bounds;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewClick)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    _inputView = [[UIView alloc] init];
    _inputView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_inputView];
    
    switch (_style) {
        case InputViewStyleDefault:{
            
            _inputView.frame = CGRectMake(0, SLInputView_ScreenH, DSInputView_ScreenW, DSInputView_StyleDefault_Height);
            
            /** StyleDefaultUI */
            CGFloat sendButtonWidth = 45;
            CGFloat sendButtonHeight = _inputView.bounds.size.height -2*DSInputView_StyleDefault_TBSpace;
            _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _sendButton.frame = CGRectMake(DSInputView_ScreenW - DSInputView_StyleDefault_LRSpace - sendButtonWidth, DSInputView_StyleDefault_TBSpace,sendButtonWidth, sendButtonHeight);
            [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
            [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_inputView addSubview:_sendButton];
            
            _textView = [[UITextView alloc] initWithFrame:CGRectMake(DSInputView_StyleDefault_LRSpace, DSInputView_StyleDefault_TBSpace, DSInputView_ScreenW - 3*DSInputView_StyleDefault_LRSpace - sendButtonWidth, self.inputView.bounds.size.height-2*DSInputView_StyleDefault_TBSpace)];
            _textView.font = [UIFont systemFontOfSize:14];
            _textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            _textView.delegate = self;
            [_inputView addSubview:_textView];
            //KVO监听contentSize变化
            [_textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
            
            _placeholderLab = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, _textView.bounds.size.width-14, _textView.bounds.size.height)];
            _placeholderLab.font = _textView.font;
            _placeholderLab.text = @"请输入...";
            _placeholderLab.textColor = [UIColor lightGrayColor];
            [_textView addSubview:_placeholderLab];
            
            _sendButtonFrameDefault = _sendButton.frame;
            _textViewFrameDefault = _textView.frame;
            
        }
            break;
        case InputViewStyleLarge:{
            
            _inputView.frame = CGRectMake(0, SLInputView_ScreenH, DSInputView_ScreenW, DSInputView_StyleLarge_Height);
            UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:_inputView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f, 10.0f)];
            CAShapeLayer* shape = [[CAShapeLayer alloc] init];
            [shape setPath:rounded.CGPath];
            _inputView.layer.mask = shape;
            
//            背景视图
            _bgView = [[UIView alloc] initWithFrame:CGRectMake(__ScaleWidth(15), __ScaleWidth(15), __ScaleWidth(345), __ScaleWidth(115))];
            _bgView.backgroundColor = [UIColor sl_colorWithHex:0xF5F9FC];
            _bgView.layer.masksToBounds = YES;
            _bgView.layer.cornerRadius = 12;
            _bgView.layer.borderColor = sl_divideLineColor.CGColor;
            _bgView.layer.borderWidth = 1;
            [_inputView addSubview:_bgView];
            
            _superView = [[UIView alloc]initWithFrame:CGRectMake( __ScaleWidth(8), __ScaleWidth(8), __ScaleWidth(82), __ScaleWidth(99))];
            _superView.backgroundColor = [UIColor clearColor];
            _superView.layer.masksToBounds = YES;
            _superView.layer.cornerRadius = 12;
            _superView.layer.borderColor = sl_normalColors.CGColor;
            _superView.layer.borderWidth = 1.5;
            [_bgView addSubview:_superView];
            
            
            self.cellimageV = [[UIImageView alloc]init];
            self.cellimageV.contentMode = UIViewContentModeScaleAspectFit;
            self.cellimageV.layer.masksToBounds = YES;
            self.cellimageV.layer.cornerRadius = 8;
            [_superView addSubview:self.cellimageV];
            [self.cellimageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(__ScaleWidth(3));
                make.left.mas_equalTo(__ScaleWidth(14));
                make.height.width.mas_equalTo(__ScaleWidth(55));
            }];
            
            
            
            self.nameLabel = [UILabel initWithFrame:CGRectZero size:__ScaleWidth(12) color:sl_textColors alignment:NSTextAlignmentCenter lines:1];
            [_superView addSubview:self.nameLabel];
            [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.equalTo(self.cellimageV.mas_bottom).offset(__ScaleWidth(5));
                make.height.mas_equalTo(__ScaleWidth(17));
            }];
            
            
            self.priceL = [UILabel initWithFrame:CGRectZero size:__ScaleWidth(11) color:sl_textSubColors alignment:NSTextAlignmentCenter lines:1];
            [_superView addSubview:self.priceL];
            [self.priceL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(self.nameLabel.mas_bottom);
                make.height.mas_equalTo(__ScaleWidth(16));
            }];
            
            
            
            /** StyleLargeUI */

            _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _sendButton.frame = CGRectMake(__ScaleWidth(308), __ScaleWidth(140), __ScaleWidth(52), __ScaleWidth(26));
            [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
            [_sendButton setTitleColor:sl_textSubColors forState:BtnNormal];
            _sendButton.titleLabel.font = SLPFFont(__ScaleWidth(14));
            _sendButton.layer.cornerRadius = __ScaleWidth(13);
            _sendButton.layer.masksToBounds = YES;
            _sendButton.backgroundColor = [UIColor sl_colorWithHex:0xF5F9FC];
            [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_inputView addSubview:_sendButton];
            
//            CAGradientLayer *gl = [CAGradientLayer layer];
//            gl.frame = CGRectMake(0,0,__ScaleWidth(52), __ScaleWidth(26));
//            gl.startPoint = CGPointMake(0.98, 0.5);
//            gl.endPoint = CGPointMake(0, 0.5);
//            gl.colors = @[(__bridge id)[UIColor sl_colorWithHex:0xF5F9FC].CGColor, (__bridge id)[UIColor sl_colorWithHex:0xF5F9FC].CGColor];
//            gl.locations = @[@(0), @(1.0f)];
//            [_sendButton.layer insertSublayer:gl atIndex:0];
            
            _textBgView = [[UIView alloc] initWithFrame:CGRectMake(__ScaleWidth(105), __ScaleWidth(8), __ScaleWidth(232), __ScaleWidth(75))];
            [_bgView addSubview:_textBgView];
            
            _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, _textBgView.bounds.size.width, _textBgView.bounds.size.height-DSInputView_CountLabHeight)];
            _textView.backgroundColor = [UIColor clearColor];
            _textView.font = CFont(__ScaleWidth(14));
            _textView.delegate = self;
            [_textBgView addSubview:_textView];
            
            _placeholderLab = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, _textView.bounds.size.width-14, 35)];
            _placeholderLab.font = _textView.font;
            _placeholderLab.text = @"请输入...";
            _placeholderLab.textColor = sl_textSubColors;
            [_textView addSubview:_placeholderLab];
            
            _countLab = [[UILabel alloc] initWithFrame:CGRectMake(__ScaleWidth(92),__ScaleWidth(91), __ScaleWidth(247), DSInputView_CountLabHeight)];
            _countLab.font = SLPFFont(__ScaleWidth(11));
            _countLab.textColor =  sl_normalColors;
            _countLab.textAlignment = NSTextAlignmentRight;
            _countLab.backgroundColor = _textView.backgroundColor;
            [_bgView addSubview:_countLab];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == _textView && [keyPath isEqualToString:@"contentSize"]){
        CGFloat height = _textView.contentSize.height;
        CGFloat heightDefault = DSInputView_StyleDefault_Height;
        if(height >= heightDefault){
            [UIView animateWithDuration:0.3 animations:^{
                //调整frame
                CGRect frame = self->_showFrameDefault;
                frame.size.height = height;
                frame.origin.y = self->_showFrameDefault.origin.y - (height - self->_showFrameDefault.size.height);
                self->_inputView.frame = frame;
                //调整sendButton frame
                self->_sendButton.frame = CGRectMake(DSInputView_ScreenW - DSInputView_StyleDefault_LRSpace - self->_sendButton.frame.size.width, self->_inputView.bounds.size.height - self->_sendButton.bounds.size.height - DSInputView_StyleDefault_TBSpace, self->_sendButton.bounds.size.width, self->_sendButton.bounds.size.height);
                //调整textView frame
                self->_textView.frame = CGRectMake(DSInputView_StyleDefault_LRSpace, DSInputView_StyleDefault_TBSpace, self->_textView.bounds.size.width, self->_inputView.bounds.size.height - 2*DSInputView_StyleDefault_TBSpace);
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [self resetFrameDefault];//恢复到,键盘弹出时,视图初始位置
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_inputView]) {
        return NO;
    }
    return YES;
}
-(void)resetFrameDefault{
    self.inputView.frame = _showFrameDefault;
    self.sendButton.frame = _sendButtonFrameDefault;
    self.textView.frame =_textViewFrameDefault;
}

-(void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length){
        _placeholderLab.hidden = YES;
    }else{
        _placeholderLab.hidden = NO;
    }
    if(_maxCount>0){
        if(textView.text.length>=_maxCount){
            textView.text = [textView.text substringToIndex:_maxCount];
        }
        if(_style == InputViewStyleLarge){
            
            NSMutableAttributedString *sA = [self setStringColorWith:[NSString stringWithFormat:@"%ld",(long)textView.text.length] rangeOfString:[NSString stringWithFormat:@"%ld",(long)textView.text.length] color:sl_normalColors font:_countLab.font];
            [sA appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%ld",(long)self.maxCount] attributes:@{NSForegroundColorAttributeName: sl_textSubColors}]];
            _countLab.attributedText = sA;
        }
    }
}
#pragma mark - textview代理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;{
    NSString *lastStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSLog(@"%@",lastStr);
    if (lastStr.length == 0) {
        [self.sendButton setTitleColor:sl_textSubColors forState:BtnNormal];
        [self.sendButton setBackgroundColor:sl_subBGColors];
    }else{
        [self.sendButton setTitleColor:sl_whiteTextColors forState:BtnNormal];
        [self.sendButton setBackgroundColor:sl_normalColors];
    }
    return YES;
}

#pragma mark - Action
-(void)bgViewClick{
    [self hide];
}
-(void)sendButtonClick:(UIButton *)button{
    if(self.sendBlcok){
        BOOL hideKeyBoard = self.sendBlcok(self.textView.text);
        if(hideKeyBoard){
            [self hide];
        }
    }
}
#pragma mark - 监听键盘
- (void)keyboardWillAppear:(NSNotification *)noti{
    if(_textView.isFirstResponder){
        NSDictionary *info = [noti userInfo];
        NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        keyboardAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGSize keyboardSize = [value CGRectValue].size;
        //NSLog(@"keyboardSize.height = %f",keyboardSize.height);
        [UIView animateWithDuration:keyboardAnimationDuration animations:^{
            CGRect frame = self.inputView.frame;
            frame.origin.y = SLInputView_ScreenH - keyboardSize.height - frame.size.height;
            self.inputView.frame = frame;
            self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
            self.showFrameDefault = self.inputView.frame;
        }];
    }
}
- (void)keyboardWillDisappear:(NSNotification *)noti{
    
    if(_textView.isFirstResponder){
        [UIView animateWithDuration:keyboardAnimationDuration animations:^{
            CGRect frame = self.inputView.frame;
            frame.origin.y = SLInputView_ScreenH;
            self.inputView.frame = frame;
            self.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - set
-(void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
    if(_style == InputViewStyleLarge){
//         _countLab.attributedText = [self setStringColorWith:[NSString stringWithFormat:@"0/%ld",(long)maxCount] rangeOfString:@"0" color:normalColors font:_countLab.font];
        
        NSMutableAttributedString *sA = [self setStringColorWith:[NSString stringWithFormat:@"%ld",(long)0] rangeOfString:[NSString stringWithFormat:@"%ld",(long)0] color:sl_normalColors font:_countLab.font];
        [sA appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%ld",(long)self.maxCount] attributes:@{NSForegroundColorAttributeName: sl_textSubColors}]];
        _countLab.attributedText = sA;
    }
}
-(void)setTextViewBackgroundColor:(UIColor *)textViewBackgroundColor{
    _textViewBackgroundColor = textViewBackgroundColor;
    _textBgView.backgroundColor = textViewBackgroundColor;
}
-(void)setFont:(UIFont *)font{
    _font = font;
    _textView.font = font;
    _placeholderLab.font = _textView.font;
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    _placeholderLab.text = placeholder;
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    _placeholderLab.textColor = placeholderColor;
    _countLab.textColor = placeholderColor;
}
-(void)setSendButtonBackgroundColor:(UIColor *)sendButtonBackgroundColor{
    _sendButtonBackgroundColor = sendButtonBackgroundColor;
    _sendButton.backgroundColor = sendButtonBackgroundColor;
}
-(void)setSendButtonTitle:(NSString *)sendButtonTitle{
    _sendButtonTitle = sendButtonTitle;
    [_sendButton setTitle:sendButtonTitle forState:UIControlStateNormal];
}
-(void)setSendButtonCornerRadius:(CGFloat)sendButtonCornerRadius{
    _sendButtonCornerRadius = sendButtonCornerRadius;
    _sendButton.layer.cornerRadius = sendButtonCornerRadius;
}
-(void)setSendButtonFont:(UIFont *)sendButtonFont{
    _sendButtonFont = sendButtonFont;
    _sendButton.titleLabel.font = sendButtonFont;
}
-(void)setPlaceImage:(NSString *)placeImage{
    _placeImage = placeImage;
    [_cellimageV sd_setImageWithURL:[NSURL URLWithString:placeImage] placeholderImage:[UIImage imageNamed:@"mr.png"]];
}
-(void)setNameString:(NSString *)nameString{
    _nameString = nameString;
   _nameLabel.text = nameString;
}
-(void)setPriceString:(NSString *)priceString{
    _priceString = priceString;
    _priceL.text = [NSString stringWithFormat:@"%@%@",priceString,[BXAppInfo appInfo].app_recharge_unit];
}

- (NSMutableAttributedString *)setStringColorWith:(NSString *)str rangeOfString:(NSString *)rangeStr color:(UIColor *)color font:(UIFont *)font
{
    NSMutableAttributedString *strA = [[NSMutableAttributedString alloc] initWithString:str];
    [strA addAttribute:NSFontAttributeName value:font range:[str rangeOfString:rangeStr]];
    [strA addAttribute:NSForegroundColorAttributeName value:color range:[str rangeOfString:rangeStr]];
    return strA;
}

@end

