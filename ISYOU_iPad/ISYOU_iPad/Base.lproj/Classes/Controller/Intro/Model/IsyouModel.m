//
//  IsyouModel.m
//  ISYOU
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "IsyouModel.h"

@implementation IsyouModel

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.orignalImagrUrls forKey:@"orignalImagrUrls"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {

        self.orignalImagrUrls = [aDecoder decodeObjectForKey:@"orignalImagrUrls"];
    }
    return self;
}
@end
