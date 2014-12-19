//
//  FixedBackgroundLabel.h
//  CustomTableViewCellExample
//
//  Created by Ramdeen, Rashaad on 12/18/14.
//  Copyright (c) 2014 Ramdeen, Rashaad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FixedBackgroundLabel : UILabel

@property (nonatomic, strong) UIColor *fixedBackgroundColor;

- (void)setFixedBackgroundColor:(UIColor *)color;

@end
