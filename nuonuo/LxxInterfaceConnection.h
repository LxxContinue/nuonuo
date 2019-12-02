//
//  LxxInterfaceConnection.h
//  CardGame
//
//  Created by LXX on 2019/9/28.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NetURL @"http://xyt.fzu.edu.cn:54321/v1/%@"

NS_ASSUME_NONNULL_BEGIN

@interface LxxInterfaceConnection : NSObject

-(void)connetNetWithPostMethod:(NSString *)handle parms:(NSDictionary *)params needToken:(BOOL)needToken block:(void(^)(int fail,NSString *dataMessage,NSDictionary *dictionary))block;

-(void)connetNetWithGetMethod:(NSString *)handle parms:(NSDictionary *)params block:(void (^)(int, NSString *, NSDictionary *))block;

-(void)connetNetWithPutMethod:(NSString *)handle parms:(NSDictionary *)params block:(void (^)(int, NSString *, NSDictionary *))block ;

-(void)sendImageWithImage:(UIImage *)img block:(void(^)(NSString * imageId, BOOL isFailed))block;

@end

NS_ASSUME_NONNULL_END
