//
//  MenuTableViewCell.h
//  CustomTableViewCellExample
//
//  Created by Ramdeen, Rashaad on 12/17/14.
//  Copyright (c) 2014 Ramdeen, Rashaad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FixedBackgroundLabel.h"

@interface MenuTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *cellText;
@property (strong, nonatomic) IBOutlet UILabel *cellLeft;
@property (strong, nonatomic) IBOutlet FixedBackgroundLabel *notificationBadge;

@end