//
//  FixedBackgroundLabel.m
//  CustomTableViewCellExample
//
//  Created by Ramdeen, Rashaad on 12/18/14.
//  Copyright (c) 2014 Ramdeen, Rashaad. All rights reserved.
//

#import "FixedBackgroundLabel.h"

@implementation FixedBackgroundLabel

- (void)setFixedBackgroundColor:(UIColor *)color{
    self.fixedBackgroundColor = color;
}

-(void)setHighlighted:(BOOL)highlighted
{
    [self setBackgroundColor:[UIColor colorWithRed:(90/255.0) green:(208/255.0) blue:(145/255.0) alpha:1.0]];

}

@end
