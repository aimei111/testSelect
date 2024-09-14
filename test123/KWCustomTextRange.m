//
//  CustomTextRange.m
//  test123
//
//  Created by 李磊钢 on 2024/5/9.
//

#import "KWCustomTextRange.h"
#import "KWCustomTextPosition.h"

@implementation KWCustomTextRange
- (instancetype)initWithStartOffset:(NSInteger)startOffset endOffset:(NSInteger)endOffset {
    self = [super init];
    if (self) {
        _startOffset = startOffset;
        _endOffset = endOffset;
    }
    return self;
}

- (BOOL)isEmpty {
    return _startOffset == _endOffset;
}

- (UITextPosition *)start {
    return [[KWCustomTextPosition alloc] initWithOffset:_startOffset];
}

- (UITextPosition *)end {
    return [[KWCustomTextPosition alloc] initWithOffset:_endOffset];
}
@end
