//
//  ContainerViewController.m
//  ContainerViewExample
//
//  Created by Ramdeen, Rashaad on 12/4/14.
//  Copyright (c) 2014 Ramdeen, Rashaad. All rights reserved.
//
#define cellIdentifier @"MenuCell"

#import "SlidableViewController.h"
#import "SlidableMenuViewController.h"

@interface SlidableViewController ()

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UINavigationController *currentViewController;
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) SlidableMenuViewController *slidableMenuViewController;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, assign) BOOL isMenuVisible;
@property (nonatomic, assign) float slideOutPercentage; //Amount to slide out VC when menu button is clicked
@property (nonatomic, assign) CGFloat slideOutAmount;

@end

@implementation SlidableViewController

-(id)initWithViewControllers:(NSArray *)viewControllers{
    self = [super init];
    
    if(self){
        //temporary array for view controllers
        NSMutableArray *tempVCs = [NSMutableArray arrayWithCapacity:viewControllers.count];
        
        //loop over each view controller
        for (UIViewController *vc in viewControllers) {
            if (![vc isMemberOfClass:[UINavigationController class]]) {
                //embed each ViewController in a navigation controller so that we get a free nav bar
                [tempVCs addObject:[[UINavigationController alloc] initWithRootViewController:vc]];
            }else{
                //add the already embedded view controller
                [tempVCs addObject:vc];
            }
            
            //get the ViewController that was last added
            UINavigationController *lastVC = ((UINavigationController *)tempVCs.lastObject);
            
            //initialize the UIBarButtonItem i.e. the button that will toggle the menu
            [self initNavigationBar:lastVC];
        }
        
        //make a copy of the view controllers
        self.viewControllers = [tempVCs copy];
        self.currentViewController = [self.viewControllers objectAtIndex:0];
        self.currentView = self.currentViewController.visibleViewController.view;
        self.isMenuVisible = NO;
    }
    
    return self;
}

- (id)initWithViewControllers:(NSArray *)viewControllers andMenuViewController:(SlidableMenuViewController *)menuViewController{
    self = [self initWithViewControllers:viewControllers];
    
    if (self) {
        self.slidableMenuViewController = menuViewController;
        self.slidableMenuViewController.delegate = self;
        self.menuView = [self.slidableMenuViewController getMenuView];
    }
    
    return self;
}

- (id)initWithViewControllers:(NSArray *)viewControllers andMenuViewController:(SlidableMenuViewController *)menuViewController andMenuWidth:(NSInteger)menuWidth{
    self = [self initWithViewControllers:viewControllers andMenuViewController:menuViewController];
    if (self) {
        self.slideOutAmount = menuWidth;
    }
    
    return self;
}

- (id)initWithViewControllers:(NSArray *)viewControllers andMenuViewController:(SlidableMenuViewController *)menuViewController andSlideOutPercentage:(NSInteger)slideOutPercentage{
    self = [self initWithViewControllers:viewControllers andMenuViewController:menuViewController];
    if (self) {
        self.slideOutPercentage = slideOutPercentage;
    }
    
    return self;
}

/*
 *  This gets called when the view is requested of this ViewController so
 *  we need to build the view here
 */
- (void)loadView{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    //make it so that we can rotate into landscape and have the view autoresize
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //container view
    self.containerView = [[UIView alloc] initWithFrame:frame];
    
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.containerView addSubview: self.menuView];
    
    [view addSubview:self.containerView];
    
    self.view = view;
    
    //detect swipe right
    UISwipeGestureRecognizer *swipeRightGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureRight:)];
    swipeRightGR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGR];
    
    //detect swipe left
    UISwipeGestureRecognizer *swipeLeftGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureLeft:)];
    swipeLeftGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGR];
}

- (void)viewWillLayoutSubviews{
    [self adjustContentFrameAccordingToMenuVisibility];
}

/*
 *  This method handles the setting up of the NavigationBar for a specific view controller. 
 *  Override this to provide your own customization of the NavigationBar.
 */
- (void)initNavigationBar:(UINavigationController *)viewController{
    UIViewController *topVC = viewController.topViewController;
    
    if (topVC.navigationItem.leftBarButtonItem == nil) {
        //create a UIBarButtonItem for our menu button
        UIBarButtonItem *menuRevealButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list23_24px"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenuVisibility:)];
        
        topVC.navigationItem.leftBarButtonItem = menuRevealButton;
        
    }else{
        [topVC.navigationItem.leftBarButtonItem setTarget:self];
        [topVC.navigationItem.leftBarButtonItem setAction:@selector(toggleMenuVisibility:)];
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    
    //called each time the view is about to be rendered
    [super viewWillAppear:animated];
    
    self.currentViewController.view.frame = self.containerView.bounds;
    
    self.currentViewController.view.autoresizingMask = self.containerView.autoresizingMask;
    
    [self addChildViewController:self.currentViewController];
    
    self.menuView.frame = self.view.frame;
    
    [self.containerView addSubview:self.menuView];
    
    [self.containerView addSubview:self.currentViewController.view];
    
    self.menuView.autoresizingMask = self.containerView.autoresizingMask;
    
    [self.currentViewController didMoveToParentViewController:self];
    
    [self adjustContentFrameAccordingToMenuVisibility];
}

- (void)adjustContentFrameAccordingToMenuVisibility{
    
    //get the frame size of the view controller's main view
    CGSize size = self.containerView.frame.size;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    __weak typeof(self) weakSelf = self;
    
    if (self.isMenuVisible) {
        //deactivate interactions on the currentView since it is in a slide out state
        self.currentView.userInteractionEnabled = NO;
        
        //slide out
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             weakSelf.currentViewController.view.frame = CGRectMake([self slideOutAmount:frame], 0, size.width, size.height);
                         } completion:^(BOOL finished) {
                             //nothing
                         }];
    }else{
        //re-activate interactions on the currentView
        self.currentView.userInteractionEnabled = YES;
        
        //slide in
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             weakSelf.currentViewController.view.frame = CGRectMake(0, 0, size.width, size.height);
                         } completion:^(BOOL finished) {
                             //nothing
                         }];
    }
}

- (void)replaceVisibleViewControllerWithViewControllerAtIndex:(NSInteger)index{
    if ([self.viewControllers objectAtIndex:index] == self.currentViewController){
        [self toggleMenuVisibility:self];
        return;
    }
    
    //get the replacement view controller
    UIViewController *newViewController = self.viewControllers[index];
    
    //position the new view controller off screen
    newViewController.view.frame = [self offScreenFrame];
    
    //get the current root visible frame
    CGRect visibleFrame = self.view.frame;
    
    //signal that we are going to orphan this view controller
    [self.currentViewController willMoveToParentViewController:nil];
    
    //add the new view controller to root
    [self addChildViewController:newViewController];
    
    //we will ignore all user interactions so that the transition can complete smoothly
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    //begin the transition from old to new view controller
    [self transitionFromViewController:self.currentViewController
                      toViewController:newViewController
                              duration:0.2
                               options:0
                            animations:^{
                                //move the old view controller off screen
                                //self.currentViewController.view.frame = [self offScreenFrame];
                                
                            } completion:^(BOOL finished){
                                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                    //remove the view completely from the root view
                                    [self.currentViewController.view removeFromSuperview];
                                    
                                    //add the new view controller to root view
                                    [self.view addSubview:newViewController.view];
                                    
                                    //animate in the new view controller into our root view
                                    newViewController.view.frame = visibleFrame;
                                    
                                } completion:^(BOOL finished) {
                                    //allow user interaction to continue
                                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                }];
                                
                                //send signal indicating the new view controller has been moved to the root
                                [newViewController didMoveToParentViewController:self];
                                
                                //remove the old view controller from the root view
                                [self.currentViewController removeFromParentViewController];
                                
                                //set menu invisible
                                self.isMenuVisible = NO;
                                self.currentViewController = [self.viewControllers objectAtIndex:index];
                                self.currentView = self.currentViewController.visibleViewController.view;
                            }];
}

- (void)toggleMenuVisibility:(id)sender{
    self.isMenuVisible = !self.isMenuVisible;
    [self adjustContentFrameAccordingToMenuVisibility];
}

- (CGRect)shiftedScreenFrame{
    CGRect frame = [[UIScreen mainScreen] bounds];
    return CGRectMake(0, [self slideOutAmount:frame], self.currentViewController.view.frame.size.width, self.currentViewController.view.frame.size.height);
}

- (CGRect)offScreenFrame{
    //view bounds will be off screen at (x,y,width,height) -> (screen width, 0, screen width, screen height)
    return CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (CGRect)onScreenFrame{
    //view bounds will be off screen at (x,y,width,height) -> (screen width, 0, screen width, screen height)
    return CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (CGFloat)slideOutAmount:(CGRect)frame {
    if (self.slideOutAmount > 0) {
        return self.slideOutAmount;
    }
    
    return frame.size.width * self.slideOutPercentage;
}

- (void)handleSwipeGestureLeft:(UIPanGestureRecognizer *)swipeGestureRecognizer{
    if (self.isMenuVisible) {
        [self toggleMenuVisibility:self];
    }
}

- (void)handleSwipeGestureRight:(UIPanGestureRecognizer *)swipeGestureRecognizer{
    if (!self.isMenuVisible) {
        [self toggleMenuVisibility:self];
    }
}

- (void)didSelectMenuItem:(NSIndexPath *)indexPath{
    //Only allow replacement if a valid index is provided
    if (indexPath.row >= 0 && indexPath.row < [self.viewControllers count] && [self.viewControllers count] > 0) {
        [self replaceVisibleViewControllerWithViewControllerAtIndex:indexPath.row];
    }
}

@end
