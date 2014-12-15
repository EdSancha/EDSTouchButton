//
//  EDSViewController.m
//  EDSTouchButton
//
//  Created by eduardo diaz sancha on 12/14/2014.
//  Copyright (c) 2014 eduardo diaz sancha. All rights reserved.
//

#import "EDSViewController.h"
#import "EDSTouchButton.h"

@interface EDSViewController ()

@end

@implementation EDSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    EDSTouchButton *button = [[EDSTouchButton alloc] initWithFrame:CGRectMake(20, 100, CGRectGetWidth(self.view.frame) - 40, 44) buttonType:EDSTouchButtonTypeDefault];
    button.title = @"Programatically created button";
    button.titleColor = [UIColor blueColor];
    button.touchColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    button.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
//    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    [button addTarget:self action:@selector(didSelectButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectButton {
    NSLog(@"didSelectButton");
}

@end
