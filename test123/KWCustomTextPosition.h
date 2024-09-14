//
//  CustomTextPosition.h
//  test123
//
//  Created by 李磊钢 on 2024/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KWCustomTextPosition : UITextPosition

/// The offset from the start index of the text position
@property (nonatomic, readonly) NSInteger offset;

/// An initializer for a CustomTextPosition that takes in an offset
/// @param offset the offset from the start index of this text position
- (instancetype)initWithOffset:(NSInteger)offset;

@end

NS_ASSUME_NONNULL_END
