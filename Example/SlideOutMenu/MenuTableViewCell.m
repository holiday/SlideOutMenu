//
//  MenuTableViewCell.m
//  CustomTableViewCellExample
//
//  Created by Ramdeen, Rashaad on 12/17/14.
//  Copyright (c) 2014 Ramdeen, Rashaad. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "FixedBackgroundLabel.h"

@implementation MenuTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
    }
    
    return self;
}

@end
