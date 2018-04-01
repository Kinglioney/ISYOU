//
//  HealthModel.m
//  ISYOU
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HealthModel.h"

@implementation HealthModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.thumbnailImagrUrl forKey:@"thumbnailImagrUrl"];
    [aCoder encodeObject:self.orignalImagrUrls forKey:@"orignalImagrUrls"];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.thumbnailImagrUrl = [aDecoder decodeObjectForKey:@"thumbnailImagrUrl"];
        self.orignalImagrUrls = [aDecoder decodeObjectForKey:@"orignalImagrUrls"];
        
    }
    return self;
}
@end
