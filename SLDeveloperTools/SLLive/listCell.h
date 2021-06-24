
#import <UIKit/UIKit.h>

@class listModel;

@interface listCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *imageV;//头像

@property(nonatomic,strong)UIImageView *imageVip;//头像挂件

@property(nonatomic,strong)UIImageView *imageBg;

@property(nonatomic,strong)listModel *model;

- (void)loadCellData:(listModel *)model indexPath:(NSIndexPath *)indexPath;

- (void)loadData:(listModel *)model index:(NSInteger )index;




@end
