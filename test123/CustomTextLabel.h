//
//  CustomTextLabel.h
//  test123
//
//  Created by 李磊钢 on 2024/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTextLabel : UIView <UITextInput>
/// Primary initializer that takes in the labelText to display for this label
/// @param labelText the string to display
- (instancetype)initWithLabelText:(NSString *)labelText;

@property (nonatomic, weak)   id <UITextInputDelegate> m_inputDelegate;
@end

NS_ASSUME_NONNULL_END
