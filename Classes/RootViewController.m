// 
// RootViewController.m
// Copyright (C) 2011 by Warren Moore
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

#import "RootViewController.h"
#import "AHPurchaseButton.h"

@implementation RootViewController
@synthesize lastSelectedPurchaseButton;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	[self setTitle:@"Store"];
	
	products = [[NSArray arrayWithObjects:
				 [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  @"Hydrogen", @"Name", 
				  [NSNumber numberWithDouble:0.99], @"Price", 
				  [NSNumber numberWithBool:NO], @"Purchased",
				  nil],
				 [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  @"Helium", @"Name", 
				  [NSNumber numberWithDouble:0.99], @"Price", 
				  [NSNumber numberWithBool:NO], @"Purchased",
				  nil],
				 [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  @"Lithium", @"Name", 
				  [NSNumber numberWithDouble:1.99], @"Price", 
				  [NSNumber numberWithBool:NO], @"Purchased",
				  nil],
				 [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  @"Beryllium", @"Name", 
				  [NSNumber numberWithDouble:1.99], @"Price", 
				  [NSNumber numberWithBool:NO], @"Purchased",
				  nil],
				 [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  @"Boron", @"Name", 
				  [NSNumber numberWithDouble:1.99], @"Price", 
				  [NSNumber numberWithBool:NO], @"Purchased",
				  nil],
				 [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  @"Carbon", @"Name", 
				  [NSNumber numberWithDouble:1.99], @"Price", 
				  [NSNumber numberWithBool:NO], @"Purchased",
				  nil],
				 [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  @"Nitrogen", @"Name", 
				  [NSNumber numberWithDouble:1.99], @"Price", 
				  [NSNumber numberWithBool:NO], @"Purchased",
				  nil],
				 [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  @"Oxygen", @"Name", 
				  [NSNumber numberWithDouble:1.99], @"Price", 
				  [NSNumber numberWithBool:NO], @"Purchased",
				  nil],
				 [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  @"Fluorine", @"Name", 
				  [NSNumber numberWithDouble:1.99], @"Price", 
				  [NSNumber numberWithBool:NO], @"Purchased",
				  nil],
				 [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  @"Neon", @"Name", 
				  [NSNumber numberWithDouble:9.99], @"Price", 
				  [NSNumber numberWithBool:NO], @"Purchased",
				  nil],
				 [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  @"Sodium", @"Name", 
				  [NSNumber numberWithDouble:2.99], @"Price", 
				  [NSNumber numberWithBool:NO], @"Purchased",
				  nil],
				 [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  @"Magnesium", @"Name", 
				  [NSNumber numberWithDouble:2.99], @"Price", 
				  [NSNumber numberWithBool:NO], @"Purchased",
				  nil],
				 nil] retain];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Purchase button events

- (void)cancelCurrentPurchasePrompt {
	[self.lastSelectedPurchaseButton setState:AHPurchaseButtonStatePrice];
	self.lastSelectedPurchaseButton = nil;
}

- (void)purchaseButtonWasTapped:(AHPurchaseButton *)sender {
	
	// Ensure only one purchase button is showing the "buy now" prompt at once
	if([sender state] == AHPurchaseButtonStatePrice)
	{
		[self cancelCurrentPurchasePrompt];
		self.lastSelectedPurchaseButton = sender;
	}
	
	// If we receive a tap while on the "buy now" prompt, go ahead and simulate the purchase
	if ([sender state] == AHPurchaseButtonStatePurchasePrompt) 
	{
		self.lastSelectedPurchaseButton = sender;
		
		// This is where you'd make your calls to StoreKit to carry out the actual purchase. We fake it here.
		
		UIAlertView *purchaseConfirmAlert = [[UIAlertView alloc] initWithTitle:@"Confirm Purchase" 
																	   message:@"Do you want to purchase this item?" 
																	  delegate:self 
															 cancelButtonTitle:@"Cancel" 
															 otherButtonTitles:@"Purchase", nil];
		[purchaseConfirmAlert show];
		[purchaseConfirmAlert release];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex != [alertView cancelButtonIndex])
	{
		NSInteger purchasedItemId = [lastSelectedPurchaseButton tag];
		[lastSelectedPurchaseButton setState:AHPurchaseButtonStatePurchased];
		
		NSDictionary *productDetails = [products objectAtIndex:purchasedItemId];
		[productDetails setValue:[NSNumber numberWithBool:YES] forKey:@"Purchased"];
		
		NSLog(@"User completed purchase of %@", [productDetails objectForKey:@"Name"]);
	}
	else 
	{
		NSLog(@"User cancelled purchase.");
	}

	self.lastSelectedPurchaseButton = nil;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		[cell setBackgroundView:[[[UIView alloc] initWithFrame:[cell frame]] autorelease]];
		[[cell contentView] setBackgroundColor:[UIColor clearColor]];
		[[cell textLabel] setBackgroundColor:[UIColor clearColor]];
		
		AHPurchaseButton *purchaseButton = [[AHPurchaseButton alloc] initWithFrame:CGRectMake(0, 0, 50, 24)];
		[purchaseButton addTarget:self action:@selector(purchaseButtonWasTapped:) forControlEvents:UIControlEventTouchDown];

		// Set the purchase button as the accessory view for this row (it effectively becomes a sibling of the contentView)
		[cell setAccessoryView:purchaseButton];
		
		[purchaseButton release];
    }
	
	AHPurchaseButton *purchaseButton = (AHPurchaseButton *)[cell accessoryView];

	// This is a rather poor way of passing context, but this is just a demo.
	[purchaseButton setTag:indexPath.row];

	NSDictionary *productDetails = [products objectAtIndex:indexPath.row];

	// Set the price for the item.
	NSString *priceString = [NSString stringWithFormat:@"$%0.2f", [[productDetails objectForKey:@"Price"] doubleValue]];
	[purchaseButton setTitle:priceString forPurchaseButtonState:AHPurchaseButtonStatePrice];
	
	[[cell textLabel] setText:[productDetails objectForKey:@"Name"]];
	
	if([[productDetails objectForKey:@"Purchased"] boolValue]) {
		[purchaseButton setState:AHPurchaseButtonStatePurchased animated:NO];
	} else {
		[purchaseButton setState:AHPurchaseButtonStatePrice animated:NO];
	}

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[self cancelCurrentPurchasePrompt];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self cancelCurrentPurchasePrompt];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	[products release], products = nil;
	[lastSelectedPurchaseButton release], lastSelectedPurchaseButton = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end

