//
//  SlideMenuViewController.h
//  SlideOutMenu
//
//  Created by Ramdeen, Rashaad (TEKSystems) on 12/2/14.
//  Copyright (c) 2014 Ramdeen, Rashaad (TEKSystems). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidableMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithViewControllers:(NSArray *)viewControllers andMenuIcon:(NSString *)imageName;
- (void)initNavigationBar:(UIViewController *)viewController;

@end
