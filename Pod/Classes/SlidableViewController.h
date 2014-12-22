//
//  SlideMenuViewController.h
//  SlideOutMenu
//
//  Created by Ramdeen, Rashaad on 12/2/14.
//  Copyright (c) 2014 Ramdeen, Rashaad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlidableMenuViewController;

/*
 *  This delegate is responsible for handling Navigation events i.e. menu item clicked, etc
 */
@protocol SlidableMenuViewControllerDelegate <NSObject>

- (void)didSelectMenuItem:(NSIndexPath *)indexPath; //Delegate method that gets called whenever a menu link is selected

@end

@interface SlidableViewController : UIViewController <SlidableMenuViewControllerDelegate>

- (id)initWithViewControllers:(NSArray *)viewControllers;
- (id)initWithViewControllers:(NSArray *)viewControllers andMenuViewController:(SlidableMenuViewController *)menuViewController;
- (id)initWithViewControllers:(NSArray *)viewControllers andMenuViewController:(SlidableMenuViewController *)menuViewController andMenuWidth:(NSInteger)menuWidth;
- (id)initWithViewControllers:(NSArray *)viewControllers andMenuViewController:(SlidableMenuViewController *)menuViewController andSlideOutPercentage:(NSInteger)slideOutPercentage;
- (void)initNavigationBar:(UIViewController *)viewController;

@end
