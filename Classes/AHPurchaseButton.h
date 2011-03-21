// 
// AHPurchaseButton.h
// Copyright (C) 2011 by Auerhaus Development, LLC
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

#import <Foundation/Foundation.h>

typedef enum {
	AHPurchaseButtonStateUninitialized,
	AHPurchaseButtonStatePrice,
	AHPurchaseButtonStatePurchasePrompt,
	AHPurchaseButtonStatePurchased,
	
	AHPurchaseButtonState_Count // Must be last
} AHPurchaseButtonState;

@interface AHPurchaseButton : UIButton {
	AHPurchaseButtonState state;
	
	BOOL needsRedrawForText;
	CGPoint upperRightOrigin;
	NSMutableArray *titlesForStates;
	NSMutableArray *imagesForStates;
	UIFont *font;
}

@property(nonatomic, assign) AHPurchaseButtonState state;
@property(nonatomic, retain) UIImage *currentBackgroundImage;
@property(nonatomic, retain) NSString *currentTitle;

// Wants to be about 50x24. Will ensure it can display all text by expanding to the left.
- (id)initWithFrame:(CGRect)frame;
- (id)initWithCoder:(NSCoder *)aDecoder;

// Customize the text to appear in the button during each state.
// Most often, you'll want to set the title for AHPurchaseButtonStatePrice, 
// which should be the localized price of the item.
- (void)setTitle:(NSString *)title forPurchaseButtonState:(AHPurchaseButtonState)titleState;

// Overload to allow setting state without animation. setState: will animate by default.
- (void)setState:(AHPurchaseButtonState)newState animated:(BOOL)animated;

@end
