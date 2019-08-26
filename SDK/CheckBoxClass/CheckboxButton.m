//
//  CheckboxButton.m
//  Alarm
//
//  Created by Megane.computer on 2016/12/26.
//  Copyright (c) 2014年 Meganecomputer. All rights reserved.
//
//

#import "CheckboxButton.h"

@implementation CheckboxButton


- (void)awakeFromNib
{
    [super awakeFromNib];
    UIImage* nocheck = [UIImage imageNamed:@"checkbox01.png"];
    UIImage* checked = [UIImage imageNamed:@"checkbox03.png"];
    UIImage* disable = [UIImage imageNamed:@"checkbox02.png"];
    UIImage* highlight = [UIImage imageNamed:@"checkbox04.png"];
    [self setBackgroundImage:nocheck forState:UIControlStateNormal];
    [self setBackgroundImage:checked forState:UIControlStateSelected];
    [self setBackgroundImage:highlight forState:UIControlStateHighlighted];
    [self setBackgroundImage:disable forState:UIControlStateDisabled];
//    [self addTarget:self action:@selector(checkboxPush:) forControlEvents:UIControlEventTouchUpInside];
//    [self setState:self];
}


- (id)initWithFrame:(CGRect)frame
{
    DLog();
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        UIImage* nocheck = [UIImage imageNamed:@"checkbox01.png"];
        UIImage* checked = [UIImage imageNamed:@"checkbox03.png"];
        UIImage* disable = [UIImage imageNamed:@"checkbox02.png"];
        UIImage* highlight = [UIImage imageNamed:@"checkbox04.png"];
        [self setBackgroundImage:nocheck forState:UIControlStateNormal];
        [self setBackgroundImage:checked forState:UIControlStateSelected];
        [self setBackgroundImage:highlight forState:UIControlStateHighlighted];
        [self setBackgroundImage:disable forState:UIControlStateDisabled];
//        [self addTarget:self action:@selector(checkboxPush:) forControlEvents:UIControlEventTouchUpInside];
//        [self setState:self];
    }
    return self;
}

- (void)checkboxPush:(CheckboxButton*) button
{
    button.checkBoxSelected = !button.checkBoxSelected;
    [button setState:button];
}

- (void)setState:(CheckboxButton*) button
{
    if (button.checkBoxSelected) {
        [button setSelected:YES];
    } else {
        [button setSelected:NO];
    }
}
@end
