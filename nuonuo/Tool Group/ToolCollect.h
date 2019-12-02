//
//  ToolCollect.h
//  nuonuo
//
//  Created by LXX on 2019/12/2.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface  UIViewController(netDateDeal)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define kAdapter(w) SCREEN_WIDTH / 750.0f * w

#define lxxColor [UIColor colorWithRed:25.0/255 green:0 blue:131.0/255 alpha:1.0]

#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX SCREEN_WIDTH >=375.0f && SCREEN_HEIGHT >=812.0f&& kIs_iphone
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))

-(NSString *)processTime:(NSString *)publishTimeStr;


@end

NS_ASSUME_NONNULL_END
