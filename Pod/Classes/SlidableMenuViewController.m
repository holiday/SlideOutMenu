//
//  ContainerViewController.m
//  ContainerViewExample
//
//  Created by Ramdeen, Rashaad (TEKSystems) on 12/4/14.
//  Copyright (c) 2014 Ramdeen, Rashaad (TEKSystems). All rights reserved.
//
#define cellIdentifier @"MenuCell"

#import "SlidableMenuViewController.h"

@interface SlidableMenuViewController ()

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isMenuVisible;
@property (nonatomic, assign) float slideOutPercentage; //Amount to slide out VC when menu button is clicked

@end

@implementation SlidableMenuViewController

-(id)initWithViewControllers:(NSArray *)viewControllers andMenuIcon:(NSString *)imageName{
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
        self.isMenuVisible = NO;
    }
    
    //default slide out width
    self.slideOutPercentage = 0.8f;
    
    //detect swipe right
    UISwipeGestureRecognizer *swipeRightGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeRightGR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGR];
    
    //detect swipe left
    UISwipeGestureRecognizer *swipeLeftGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeLeftGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGR];
    
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
    
    view.backgroundColor = [UIColor whiteColor];
    
    //container view
    self.containerView = [[UIView alloc] initWithFrame:frame];
    
    self.containerView.backgroundColor = [UIColor grayColor];
    
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView setBackgroundColor:[UIColor grayColor]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [view addSubview:self.containerView];
    
    [view addSubview:self.tableView];
    
    self.view = view;
}

- (void)viewWillLayoutSubviews{
    [self adjustContentFrameAccordingToMenuVisibility];
}

- (void)viewDidLayoutSubviews{
    //[self adjustContentFrameAccordingToMenuVisibility];
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

- (void)viewDidLoad{
    //only gets called once when the view is loaded
    
    //register the cell identifier
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
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
    
    self.tableView.frame = self.view.frame;
    
    [self.containerView addSubview:self.tableView];
    
    [self.containerView addSubview:self.currentViewController.view];
    
    self.tableView.autoresizingMask = self.containerView.autoresizingMask;
    
    [self.currentViewController didMoveToParentViewController:self];
    
    [self adjustContentFrameAccordingToMenuVisibility];
}

- (void)adjustContentFrameAccordingToMenuVisibility{
    
    //get the frame size of the view controller's main view
    CGSize size = self.containerView.frame.size;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    if (self.isMenuVisible) {
        //animate out the main view of the current view controller
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.currentViewController.view.frame = CGRectMake(self.slideOutPercentage * frame.size.width, 0, size.width, size.height);
                         } completion:^(BOOL finished) {
                             //nothing
                         }];
    }else{
        //animate in
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.currentViewController.view.frame = CGRectMake(0, 0, size.width, size.height);
                         } completion:^(BOOL finished) {
                             //nothing
                         }];
    }
    
}

- (void)replaceVisibleViewControllerWithViewControllerAtIndex:(NSInteger)index{
    if ([self.viewControllers objectAtIndex:index] == self.currentViewController) return;
    
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
                                self.currentViewController.view.frame = [self offScreenFrame];
                                
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
                            }];
}

- (void)toggleMenuVisibility:(id)sender{
    self.isMenuVisible = !self.isMenuVisible;
    [self adjustContentFrameAccordingToMenuVisibility];
}

- (CGRect)shiftedScreenFrame{
    CGRect frame = [[UIScreen mainScreen] bounds];
    return CGRectMake(0, self.slideOutPercentage * frame.size.width, self.currentViewController.view.frame.size.width, self.currentViewController.view.frame.size.height);
}

- (CGRect)offScreenFrame{
    //view bounds will be off screen at (x,y,width,height) -> (screen width, 0, screen width, screen height)
    return CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (CGRect)onScreenFrame{
    //view bounds will be off screen at (x,y,width,height) -> (screen width, 0, screen width, screen height)
    return CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)handleSwipeGesture:(UIPanGestureRecognizer *)swipeGestureRecognizer{
    [self toggleMenuVisibility:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewControllers.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.contentView setBackgroundColor:[UIColor grayColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.textLabel.text = [(UIViewController *)[self.viewControllers objectAtIndex:indexPath.row] title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self replaceVisibleViewControllerWithViewControllerAtIndex:indexPath.row];
}

@end
