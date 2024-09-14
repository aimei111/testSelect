//
//  CustomTextPosition.m
//  test123
//
//  Created by 李磊钢 on 2024/5/9.
//

#import "KWCustomTextPosition.h"

@implementation KWCustomTextPosition
- (instancetype)initWithOffset:(NSInteger)offset {
    self = [super init];
    if (self) {
        _offset = offset;
    }
    return self;
}

@end
