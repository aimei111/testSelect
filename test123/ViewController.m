//
//  ViewController.m
//  test123
//
//  Created by 李磊钢 on 2024/4/7.
//

#import "ViewController.h"
#import "KWCustomTextPosition.h"
#import "CustomTextLabel.h"
#import <AVFoundation/AVFAudio.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ViewController ()
@property (nonatomic, strong) NSString *labelText;
@property (nonatomic, strong) CustomTextLabel *customTextLabel;
@property (nonatomic, strong) UITextInteraction *interaction;
@end

@implementation ViewController
/// Toggle whether we should be using a
- (void)updateInteractionMode {
    if (self.interaction) {
        [self.customTextLabel removeInteraction:self.interaction];
    }
    
    // Add UITextInteraction based on the customTextLabel
    UITextInteraction *newInteraction = [UITextInteraction textInteractionForMode:UITextInteractionModeNonEditable];
    newInteraction.textInput = self.customTextLabel;
    [self.customTextLabel addInteraction:newInteraction];
    self.interaction = newInteraction;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.labelText = @"this is text label for testing";
        self.customTextLabel = [[CustomTextLabel alloc] initWithLabelText:self.labelText];
    CGFloat width = 342;
    self.customTextLabel.frame = CGRectMake((self.view.frame.size.width - width)/2, 300, width, 400);
    [self.view addSubview:self.customTextLabel];
    
    [self updateInteractionMode];

    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setTitle:@"start select" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [selectBtn setFrame:CGRectMake(20, 100, 100, 100)];
    [selectBtn setBackgroundColor:[UIColor blueColor]];
    [selectBtn addTarget:self action:@selector(startSelectNow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
    
}

- (void)startSelectNow {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"Tap selectBtn";
    [hud hideAnimated:YES afterDelay:2.0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"=========================");
        [self.customTextLabel becomeFirstResponder];
        [self.customTextLabel.m_inputDelegate selectionWillChange:self.customTextLabel];
        UITextPosition *start = [self.customTextLabel beginningOfDocument];
        UITextPosition *end = [self.customTextLabel endOfDocument];
        UITextRange *range = [self.customTextLabel textRangeFromPosition:start toPosition:end];
        self.customTextLabel.selectedTextRange = range;
        [self.customTextLabel.m_inputDelegate selectionDidChange:self.customTextLabel];
    });
}

@end
