//
//  CustomMenuViewController.m
//  SlideOutMenu
//
//  Created by Ramdeen, Rashaad on 12/19/14.
//  Copyright (c) 2014 rashaad ramdeen. All rights reserved.
//

#import "CustomMenuViewController.h"
#import "MenuTableViewCell.h"

@interface CustomMenuViewController ()

@property (nonatomic, strong) NSArray *tableViewData;
@property (nonatomic, strong) NSArray *tableViewIconsData;

@end

@implementation CustomMenuViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableViewData = @[@"Cat", @"Dog", @"Pigeon", @"Alligator", @"Tiger", @"Peacock", @"Elephant"];
    self.tableViewIconsData = @[@"\uf1fe", @"\uf1b3", @"\uf126", @"\uf0ed", @"\uf06c", @"\uf1b0", @"\uf17c"];
    
    [self.tableView registerClass:[MenuTableViewCell class] forCellReuseIdentifier:@"MenuCell"];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0]];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tableViewData count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MenuCell";
    
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.cellText.text = [self.tableViewData objectAtIndex:indexPath.row];
    cell.cellLeft.text = [self.tableViewIconsData objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectMenuItem:indexPath];
}

- (UIView *)getMenuView{
    return self.view;
}
- (IBAction)openSettings:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.delegate didSelectMenuItem:indexPath];
}

@end
