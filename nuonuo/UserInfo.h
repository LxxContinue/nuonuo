//
//  UserInfo.h
//  nuonuo
//
//  Created by LXX on 2019/11/9.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo : NSObject<NSCoding>

@property (nonatomic) NSString *uid;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *sexual;
@property (nonatomic) NSString *qq;
@property (nonatomic) NSString *weixin;
@property (nonatomic) NSString *headPicId;
@property (nonatomic) NSString *headPicUrl;

-(instancetype) initWithNSDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
