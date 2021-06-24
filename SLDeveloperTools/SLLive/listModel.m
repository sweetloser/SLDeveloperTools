

#import "listModel.h"

@interface listModel ()


@end

@implementation listModel


-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.avatar= [NSString stringWithFormat:@"%@",[dic valueForKey:@"avatar"]];
        self.user_id = [NSString stringWithFormat:@"%@",[dic valueForKey:@"user_id"]];
        self.nickname = [NSString stringWithFormat:@"%@",[dic valueForKey:@"nickname"]];
        self.level = [NSString stringWithFormat:@"%@",[dic valueForKey:@"level"]];
    }
    return self;
    
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    
    return   [[self alloc]initWithDic:dic];
}

@end
