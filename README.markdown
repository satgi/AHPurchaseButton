# AHPurchaseButton

## Purpose

The intent of this class is to duplicate the behavior of the purchasing button in the iTunes app on iPhone.
The button begins in an enabled state, displaying the price of its corresponding item.
When tapped, it animates, changing color and presenting a "Buy Now" prompt.
When tapped again, it initiates the purchasing process.

## Usage

This repository contains a sample project demonstrating the use of AHPurchaseButton in practice.
The project is a simple navigation-based iPhone project that presents a list of elements of the
periodic table, each with a corresponding purchase button. The user can carry out the purchasing
workflow. Several types of user interaction cause the state of the button to be reset, such as
scrolling the table view or selecting a different item to purchase. The purchase workflow uses a
UIAlertView to simulate the feedback the user receives when making an actual In-App Purchase.

## Dependencies

The only dependencies for using this class in your own project are the source files for the button itself (**AHPurchaseButton.h** and **AHPurchaseButton.m**),
as well as three images corresponding to the visual states of the button:

 - **purchase-button-price.png** is the default background and corresponds to the display of the item price.
 - **purchase-button-prompt.png** is the background used when the "Buy Now" prompt (or equivalent) is showing.
 - **purchase-button-purchased.png** is the background for the inactive state of the button when the item has already been purchased.

Standard and Retina versions (@2x) of these images are included. Feel free to substitute your own.

## Q&A

Please e-mail wm@warrenmoore.net if you have any questions, concerns, or suggestions.
