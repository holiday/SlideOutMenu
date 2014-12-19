//
//  CustomMenuViewController.h
//  SlideOutMenu
//
//  Created by Ramdeen, Rashaad on 12/19/14.
//  Copyright (c) 2014 rashaad ramdeen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidableMenuViewController.h"

@interface CustomMenuViewController : SlidableMenuViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (UIView *)getMenuView;

@end
