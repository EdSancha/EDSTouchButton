# EDSTouchButton

[![CI Status](http://img.shields.io/travis/eduardo diaz sancha/EDSTouchButton.svg?style=flat)](https://travis-ci.org/eduardo diaz sancha/EDSTouchButton)
[![Version](https://img.shields.io/cocoapods/v/EDSTouchButton.svg?style=flat)](http://cocoadocs.org/docsets/EDSTouchButton)
[![License](https://img.shields.io/cocoapods/l/EDSTouchButton.svg?style=flat)](http://cocoadocs.org/docsets/EDSTouchButton)
[![Platform](https://img.shields.io/cocoapods/p/EDSTouchButton.svg?style=flat)](http://cocoadocs.org/docsets/EDSTouchButton)

Animated button based on [Rippler](http://git.blivesta.com/rippler/) using [Pop](https://github.com/facebook/pop).

## Demo

![Demo](https://raw.githubusercontent.com/edsancha/EDSTouchButton/master/EDSTouchButton-Demo.gif)

## Installation

To run the example project, clone the repo, and run `pod install` from the Example directory first.
Another way to run the example project is running `pod try EDSTouchButton` in terminal.


EDSTouchButton is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "EDSTouchButton"


## Usage

To use the button in your project:

    EDSTouchButton *button = [[EDSTouchButton alloc] initWithFrame:CGRectMake(20, 100, CGRectGetWidth(self.view.frame) - 40, 44)
                                                        buttonType:EDSTouchButtonTypeDefault];
    button.touchDiameter = 20;
    button.title = @"Programatically created button";
    button.titleColor = [UIColor blueColor];
    button.touchColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    button.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    [button addTarget:self
               action:@selector(didSelectButton)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

You can also add it on your storyboard and edit its properties directly in the Attributes Inspector.

## To do

- Add simple tests.
- Add UIImageView to button.

## Author

Eduardo Diaz Sancha, edsancha@gmail.com

## License

EDSTouchButton is available under the MIT license. See the LICENSE file for more info.
