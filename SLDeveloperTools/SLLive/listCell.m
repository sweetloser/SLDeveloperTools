
#import "listCell.h"
#import "listModel.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import <Masonry/Masonry.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <SLDeveloperTools/SLDeveloperTools.h>
@implementation listCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
       self.backgroundColor = [UIColor clearColor];
        
        _imageV = [UIImageView new];
        [self.contentView addSubview:_imageV];
        _imageV.sd_layout.leftSpaceToView(self.contentView,3).rightSpaceToView(self.contentView, 1).bottomSpaceToView(self.contentView, 1).topSpaceToView(self.contentView, 8);
        _imageV.sd_cornerRadius = @(15);
//        _imageV.layer.borderWidth = 1;
//        _imageV.layer.borderColor = normalColors.CGColor;
        
        _imageBg = [UIImageView new];
        [self.contentView addSubview:_imageBg];
        _imageBg.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0);

        _imageVip = [UIImageView new];
        [self.contentView addSubview:_imageVip];
        _imageVip.sd_layout.rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(15).heightEqualToWidth();
        _imageVip.sd_cornerRadius = @(_imageVip.width/2.f);
        
    }
    return self;
}

-(void)setModel:(listModel *)model{
    _model = model;
    [_imageV zzl_setImageWithURLString:[NSURL URLWithString:_model.avatar] placeholder:[UIImage imageNamed:@"placeplaceholder"]];
    if ([model.level intValue] <= 6){
        _imageVip.image = [UIImage imageNamed:@"headImage1"];
    } else if ([model.level intValue] <=10){
        _imageVip.image = [UIImage imageNamed:@"headImage2"];
    } else if ([model.level intValue] <= 15){
        _imageVip.image = [UIImage imageNamed:@"headImage3"];
    } else if ([model.level intValue] <= 20){
        _imageVip.image = [UIImage imageNamed:@"headImage4"];
    } else if ([model.level intValue] <= 26){
        _imageVip.image = [UIImage imageNamed:@"headImage5"];
    } else if ([model.level intValue] <= 33){
        _imageVip.image = [UIImage imageNamed:@"headImage6"];
    } else if ([model.level intValue] <= 40){
        _imageVip.image = [UIImage imageNamed:@"headImage7"];
    } else if ([model.level intValue] <= 50){
        _imageVip.image = [UIImage imageNamed:@"headImage8"];
    } else {
        _imageVip.image = [UIImage imageNamed:@"headImage9"];
    }
}

- (void)loadCellData:(listModel *)model indexPath:(NSIndexPath *)indexPath{
    if ([model.level integerValue] > 30) {
        self.imageBg.hidden = NO;
        self.imageBg.image = [UIImage imageNamed:[NSString stringWithFormat:@"headTop%ld",(long)(indexPath.row+1)]];
        _imageV.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        self.imageBg.hidden = YES;
    }
}

- (void)loadData:(listModel *)model index:(NSInteger)index{
   
    self.imageBg.image = [UIImage imageNamed:[NSString stringWithFormat:@"headTop%ld",(long)(index+1)]];
    _imageV.layer.borderColor = [UIColor clearColor].CGColor;
    
}


@end
