//
// UIViewController.m
//
// Copyright (c) 2015 Anton Gaenko
// Copyright (c) 2015-present Ruslan Skorb, http://ruslanskorb.com/
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ViewController.h"
#import "UIViewController+RSKKeyboardAnimationObserver.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *inputPlaceholder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBarBottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomSpace;

@end

static const CGFloat kButtonSpaceShowed = 90.0f;
static const CGFloat kButtonSpaceHided = 24.0f;

#define kBackgroundColorShowed [UIColor colorWithRed:0.27f green:0.85f blue:0.46f alpha:1.0f];
#define kBackgroundColorHided [UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f];

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView.backgroundColor = kBackgroundColorHided;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self subscribeToKeyboard];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self rsk_unsubscribeKeyboard];
}

- (void)subscribeToKeyboard
{
    __weak typeof(self) weakSelf = self;
    [self rsk_subscribeKeyboardWithWillShowOrHideAnimation:^(CGRect keyboardRectEnd, NSTimeInterval duration, BOOL isShowing) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (isShowing) {
                strongSelf.imageView.backgroundColor = kBackgroundColorShowed;
                strongSelf.tabBarBottomSpace.constant = CGRectGetHeight(keyboardRectEnd);
                strongSelf.buttonBottomSpace.constant = kButtonSpaceShowed;
            } else {
                strongSelf.imageView.backgroundColor = kBackgroundColorHided;
                strongSelf.tabBarBottomSpace.constant = 0.0f;
                strongSelf.buttonBottomSpace.constant = kButtonSpaceHided;
            }
            [strongSelf.view layoutIfNeeded];
        }
    } onComplete:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        return NO;
    }
    
    self.inputPlaceholder.hidden = text.length || range.location > 0;
    
    return YES;
}

@end
