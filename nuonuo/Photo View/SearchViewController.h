//
//  SearchViewController.h
//  nuonuo
//
//  Created by LXX on 2019/11/21.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : UIViewController

@property (nonatomic, strong) NSString *carID;                           /**< 车车ID */
@property (nonatomic,strong) NSMutableArray *infoArr;

@end

NS_ASSUME_NONNULL_END
