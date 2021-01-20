#import <UIKit/UIKit.h>
#import "BXSLLiveRoom.h"

@interface BXSLLiveRoomtCell : UITableViewCell

@property (strong, nonatomic) BXSLLiveRoom *liveRoom;

+(BXSLLiveRoomtCell *)cellWithTableView:(UITableView *)tableView;

@end
