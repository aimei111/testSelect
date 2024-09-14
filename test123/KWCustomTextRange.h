//
//  CustomTextRange.h
//  test123
//
//  Created by 李磊钢 on 2024/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KWCustomTextRange : UITextRange
/// The start offset of this range
@property (nonatomic, readonly) NSInteger startOffset;
/// The end offset of this range
@property (nonatomic, readonly) NSInteger endOffset;

/// Create a `CustomTextRange` with the given offsets
/// @param startOffset The start offset of this range
/// @param endOffset The end offset of this range
- (instancetype)initWithStartOffset:(NSInteger)startOffset endOffset:(NSInteger)endOffset;

@end

NS_ASSUME_NONNULL_END
