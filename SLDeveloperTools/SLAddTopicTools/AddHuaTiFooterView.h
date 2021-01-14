//
//  AddHuaTiFooterView.h
//  BXlive
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddHuaTiFooterView : UICollectionReusableView<UISearchBarDelegate>
@property (copy, nonatomic) void (^DidItemIndex)(NSString *topic_name, NSString *topic_id);
@property (nonatomic,strong)NSMutableArray *AddDataArray;
@property(nonatomic, assign)NSInteger itemNum;
@property(nonatomic, assign)NSInteger MAXNum;
@property(nonatomic, strong)UISearchBar *searchBar;

@end

NS_ASSUME_NONNULL_END
