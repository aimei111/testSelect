//
//  CustomTextSelectionRect.m
//  test123
//
//  Created by 李磊钢 on 2024/5/9.
//

#import "KWCustomTextSelectionRect.h"

@implementation KWCustomTextSelectionRect
- (instancetype)initWithRect:(CGRect)rect writingDirection:(NSWritingDirection)writingDirection containsStart:(BOOL)containsStart containsEnd:(BOOL)containsEnd isVertical:(BOOL)isVertical {
    self = [super init];
    if (self) {
        _internalRect = rect;
        _internalWritingDirection = writingDirection;
        _internalContainsStart = containsStart;
        _internalContainsEnd = containsEnd;
        _internalIsVertical = isVertical;
    }
    return self;
}

- (CGRect)rect {
    return _internalRect;
}

- (NSWritingDirection)writingDirection {
    return _internalWritingDirection;
}

- (BOOL)containsStart {
    return _internalContainsStart;
}

- (BOOL)containsEnd {
    return _internalContainsEnd;
}

- (BOOL)isVertical {
    return _internalIsVertical;
}
@end
