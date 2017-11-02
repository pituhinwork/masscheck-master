//
//  TabbarItemController.m
//  TestProject
//
//  Created by BachUng on 5/26/17.
//  Copyright © 2017 BachUng. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingController.h"

@interface SettingController ()

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppLog(@"");
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view.frame = rect;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UITableView *tabledata = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, rect.size.width, rect.size.height-100)];
    tabledata.dataSource = self;
    tabledata.delegate = self;
    [self.view addSubview:tabledata];
    tableViewShow = tabledata;
//    [tabledata release];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

    // Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

    // Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppLog();
    static NSString *CellIdentifier = @"CellIdentifierCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    int row = (int)indexPath.row;
    cell.textLabel.text = @"";
    switch (row)
    {
        case 0:
        {
            cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
            cell.textLabel.text = @"You are using standard version!";
        } break;
        case 1:
        {
            cell.imageView.image = [UIImage imageNamed:@"shopping.png"];
            cell.textLabel.text = @"Upgrade Pro";
        } break;
        case 2:
        {
            cell.imageView.image = [UIImage imageNamed:@"retore.png"];
            cell.textLabel.text = @"Restore Purchase";
        } break;
        case 3:
        {
            cell.backgroundColor = [UIColor darkGrayColor];
            cell.textLabel.text = @" ";
        } break;
        case 4:
        {
            cell.imageView.image = [UIImage imageNamed:@"automatic.png"];
            cell.textLabel.text = @"Auto run";
        } break;
        case 5:
        {
            cell.imageView.image = [UIImage imageNamed:@"language.png"];
            cell.textLabel.text = @"Language";
        } break;
        case 6:
        {
            cell.imageView.image = [UIImage imageNamed:@"share.png"];
            cell.textLabel.text = @"Share app";
        } break;
        case 7:
        {
            cell.imageView.image = [UIImage imageNamed:@"feedback.png"];
            cell.textLabel.text = @"Freedback";
        } break;
        case 8:
        {
            cell.imageView.image = [UIImage imageNamed:@"about.png"];
            cell.textLabel.text = @"About";
        } break;
        default:
            break;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0 || indexPath.row==3)
            return (CGFloat)30.0;
    return (CGFloat)80.0;
}


@end
