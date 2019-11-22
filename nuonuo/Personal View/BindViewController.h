//
//  BindViewController.h
//  nuonuo
//
//  Created by LXX on 2019/11/22.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BindViewController : UIViewController

@property (nonatomic) NSString *token;

@property (nonatomic, assign) BOOL Binding;                       /**< 是否已绑定 */
@property (nonatomic) NSString *carPicStr;                        /**< 已绑定的车车url */

@end

NS_ASSUME_NONNULL_END
