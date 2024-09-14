//
//  CustomTextSelectionRect.h
//  test123
//
//  Created by 李磊钢 on 2024/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KWCustomTextSelectionRect : UITextSelectionRect

/// The internal `CGRect` defining the size and location of the selection
@property (nonatomic, readonly) CGRect internalRect;
/// The internal storage for the current writing direction of this text selection
@property (nonatomic, readonly) NSWritingDirection internalWritingDirection;
/// The internal storage for whether this selection rect contains the start of the selection
@property (nonatomic, readonly) BOOL internalContainsStart;
/// The internal storage for whether this selection rect contains the end of the selection
@property (nonatomic, readonly) BOOL internalContainsEnd;
/// The internal storage for whether this selection is for vertical text
@property (nonatomic, readonly) BOOL internalIsVertical;

/// An initializer to create a `CustomTextSelectionRect` with all necessary properties
/// @param rect The rect of the selection
/// @param writingDirection The writing direction of the selection
/// @param containsStart Whether this rect contains the start of the selection (only false in multi-rect selections)
/// @param containsEnd Whether this rect contains the end of the selection (only false in multi-rect selections)
/// @param isVertical Whether the text in the selection is vertical
- (instancetype)initWithRect:(CGRect)rect writingDirection:(NSWritingDirection)writingDirection containsStart:(BOOL)containsStart containsEnd:(BOOL)containsEnd isVertical:(BOOL)isVertical;


@end

NS_ASSUME_NONNULL_END
