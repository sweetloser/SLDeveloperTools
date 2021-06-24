
#import <Foundation/Foundation.h>

@interface listModel : NSObject

@property(copy, nonatomic) NSString *user_id;
@property(copy, nonatomic) NSString *avatar;
@property(copy, nonatomic) NSString *nickname;
@property(copy, nonatomic) NSString *level;

-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;

@end
