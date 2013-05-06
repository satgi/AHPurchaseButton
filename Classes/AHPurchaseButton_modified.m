//
// AHPurchaseButton.m
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

#import "AHPurchaseButton.h"

static CGFloat kMaximumTextWidth = 300; // Arbitrary. Selected for iPhone displays
static CGPoint kLabelInsets = {9, 5}; // Selected based on the appearance of Purchase buttons in iTunes app

@interface AHPurchaseButton (Internal)
- (void)initializeView;
- (void)resizeToFitLabelText;
@end

@implementation AHPurchaseButton
@synthesize currentBackgroundImage;
@synthesize currentTitle;

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		[self initializeView];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if((self = [super initWithCoder:aDecoder])) {
		[self initializeView];
	}
	
	return self;
}

- (void)dealloc {
	[font release], font = nil;
	[currentTitle release], currentTitle = nil;
	[currentBackgroundImage release], currentBackgroundImage = nil;
	[titlesForStates release], titlesForStates = nil;
	[imagesForStates release], imagesForStates = nil;
	
	[super dealloc];
}

- (void)initializeView {
	// Cache upper-right corner so we can expand left as necessary
	upperRightOrigin = CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y);
	
	[self setOpaque:NO];
	[self setBackgroundColor:[UIColor clearColor]];
	[self setContentMode:UIViewContentModeRedraw];
	font = [[UIFont boldSystemFontOfSize:14.0f] retain];
    
	// Cache default titles for various states
	titlesForStates = [[NSMutableArray alloc] initWithCapacity:4];
	[titlesForStates insertObject:@""
						  atIndex:AHPurchaseButtonStateUninitialized];
	[titlesForStates insertObject:NSLocalizedString(@"免费", @"Purchase price for free In-App Purchase items")
						  atIndex:AHPurchaseButtonStatePrice];
	[titlesForStates insertObject:NSLocalizedString(@"现在购买", @"Purchase prompt for In-App Purchase Button")
						  atIndex:AHPurchaseButtonStatePurchasePrompt];
	[titlesForStates insertObject:NSLocalizedString(@"正在购买", @"Purchasing title for In-App Purchase Button")
						  atIndex:AHPurchaseButtonStatePurchasing];
	
	// Cache stretchable image instances for various states
	// TODO: these should be shared among all instances
	imagesForStates = [[NSMutableArray alloc] initWithCapacity:4];
	UIImage *priceImage = [[UIImage imageNamed:@"purchase-button-price"]
						   stretchableImageWithLeftCapWidth:10 topCapHeight:0];
	UIImage *promptImage = [[UIImage imageNamed:@"purchase-button-prompt"]
							stretchableImageWithLeftCapWidth:10 topCapHeight:0];
	UIImage *purchImage = [[UIImage imageNamed:@"purchase-button-purchased"]
						   stretchableImageWithLeftCapWidth:10 topCapHeight:0];
	
	[imagesForStates insertObject:priceImage atIndex:AHPurchaseButtonStateUninitialized];
	[imagesForStates insertObject:priceImage atIndex:AHPurchaseButtonStatePrice];
	[imagesForStates insertObject:promptImage atIndex:AHPurchaseButtonStatePurchasePrompt];
	[imagesForStates insertObject:purchImage atIndex:AHPurchaseButtonStatePurchasing];
    
	// Configure button for initially displaying price.
	[self setState:AHPurchaseButtonStatePrice animated:NO];
}

- (void)setTitle:(NSString *)title forPurchaseButtonState:(AHPurchaseButtonState)titleState {
	NSAssert(titleState < AHPurchaseButtonState_Count, @"Tried to set title for invalid state");
	
	[titlesForStates replaceObjectAtIndex:titleState withObject:title];
	
	// If we're currently in the specified state, we should update our display now
	if(titleState == state) {
		self.currentTitle = [titlesForStates objectAtIndex:state];
		[self setNeedsLayout];
	}
    
    [self resizeToFitLabelText];
}

- (void)setState:(AHPurchaseButtonState)newState animated:(BOOL)animated {
	if(state == newState) return;
	
	state = newState;
	
	self.currentTitle = [titlesForStates objectAtIndex:state];
	
	self.currentBackgroundImage = [imagesForStates objectAtIndex:state];
    
	if(animated)
	{
		self.currentTitle = nil; // Hide text during animation to avoid unsightly stretching
		needsRedrawForText = YES;
		
		[UIView beginAnimations:@"ReshapeForStateChange" context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	}
	
	[self resizeToFitLabelText];
	
	if(animated)
	{
		[UIView commitAnimations];
	}
    
}

- (void)setState:(AHPurchaseButtonState)newState {
	[self setState:newState animated:YES];
}

- (AHPurchaseButtonState)state {
	return state;
}

- (void)animationDidStop:(NSString *)animationName finished:(NSNumber *)finished context:(void *)context {
	if(needsRedrawForText)
	{
		self.currentTitle = [titlesForStates objectAtIndex:state];
		[self setNeedsDisplay];
		needsRedrawForText = NO;
	}
}

- (void)resizeToFitLabelText {
	NSString *text = [titlesForStates objectAtIndex:state];
	
	CGSize labelTextSize = [text sizeWithFont:font];
	
	labelTextSize.width = MIN(labelTextSize.width, kMaximumTextWidth); // Maintain sanity
	
	CGSize newSize = CGSizeMake(labelTextSize.width + (kLabelInsets.x * 2), //+ rand() / 10000000000.0,
								labelTextSize.height + (kLabelInsets.y * 2));
	
	CGRect newFrame = CGRectMake(upperRightOrigin.x - newSize.width, upperRightOrigin.y,
								 newSize.width, newSize.height);
    
//    self.frame = newFrame;
	// Use the animatable properties in case we're being drawn with a transform
	[self setBounds:CGRectMake(0, 0, newFrame.size.width, newFrame.size.height)];
//	[self setCenter:CGPointMake(CGRectGetMidX(newFrame), CGRectGetMidY(newFrame))];
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
    
    [self.currentBackgroundImage drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	if(state == AHPurchaseButtonStatePurchased || state == AHPurchaseButtonStatePurchasing)
	{
		CGFloat grayColor[] = { 0.6, 0.6, 0.6, 1.0 };
		CGContextSetFillColor(context, grayColor);
	}
	else
	{
		CGFloat whiteColor[] = { 1.0, 1.0, 1.0, 1.0 };
		CGContextSetFillColor(context, whiteColor);
        
		UIColor *translucentBlackColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
		CGContextSetShadowWithColor(context, CGSizeMake(0, -1), 0, [translucentBlackColor CGColor]);
	}
	
	[self.currentTitle drawAtPoint:kLabelInsets withFont:font];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
    
	if(state == AHPurchaseButtonStatePrice)
	{
		[self setState:AHPurchaseButtonStatePurchasePrompt animated:YES];
	}
	else if(state == AHPurchaseButtonStatePurchasePrompt)
	{
		// Reverts button to showing price while user is prompted to complete purchase.
		// To change this behavior, remove the line below and manage the state manually in your view controller.
		[self setState:AHPurchaseButtonStatePurchasing animated:YES];
	}
}

@end