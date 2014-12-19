//
//  SlidableMenuViewController.h
//  Pods
//
//  Created by Ramdeen, Rashaad on 12/19/14.
//
//

#import <UIKit/UIKit.h>
#import "SlidableViewController.h"

@interface SlidableMenuViewController : UIViewController

@property (nonatomic, weak) id <SlidableMenuViewControllerDelegate> delegate;

- (UIView *)getMenuView; //returns the View that will be used as the slide out navigation

@end
