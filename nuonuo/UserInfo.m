//
//  UserInfo.m
//  nuonuo
//
//  Created by LXX on 2019/11/9.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "UserInfo.h"
#import "objc/runtime.h"

@implementation UserInfo

-(instancetype)initWithNSDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self)
    {
        [self prepareModel:dict];
    }
    return self;
}
-(void)prepareModel:(NSDictionary *)dict
{
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    u_int count = 0 ;
    objc_property_t *properties = class_copyPropertyList(self.class, &count);
    for(int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        const char *propertyCString = property_getName(property);
        NSString *propertyName = [NSString stringWithCString:propertyCString encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(properties);
    for (NSString *key in keys)
    {
        if([dict valueForKey:key])
        {
            [self setValue:[dict valueForKey:key] forKey:key];
        }
    }
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.sexual forKey:@"sexual"];
    [aCoder encodeObject:self.qq forKey:@"qq"];
    [aCoder encodeObject:self.weixin forKey:@"weixin"];
    [aCoder encodeObject:self.headPicId forKey:@"headPicId"];
    [aCoder encodeObject:self.headPicUrl forKey:@"headPicUrl"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if(self = [super init])
    {
        if(aDecoder == nil)
        {
            return self;
        }
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.sexual = [aDecoder decodeObjectForKey:@"sexual"];
        self.qq = [aDecoder decodeObjectForKey:@"qq"];
        self.weixin = [aDecoder decodeObjectForKey:@"weixin"];
        self.headPicId = [aDecoder decodeObjectForKey:@"headPicId"];
        self.headPicUrl = [aDecoder decodeObjectForKey:@"headPicUrl"];
    }
    return self;
}


@end
