//
//  addEmergencyContactViewController.m
//  gno
//
//  Created by Calvin on 28/09/12.
//
//

#import "addEmergencyContactViewController.h"
#import "MyDetailsCell.h"

@interface addEmergencyContactViewController ()

@end

@implementation addEmergencyContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self._tableView setBackgroundColor:[UIColor clearColor]];

	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)addAction:(id)sender {
    NSIndexPath *indexTableViewName=[NSIndexPath indexPathForRow:0 inSection:0];
    MyDetailsCell *addCellName=(MyDetailsCell*)[self._tableView cellForRowAtIndexPath:indexTableViewName];
    
    NSIndexPath *indexTableViewRelationship=[NSIndexPath indexPathForRow:1 inSection:0];
    MyDetailsCell *addCellRelationship=(MyDetailsCell*)[self._tableView cellForRowAtIndexPath:indexTableViewRelationship];
    
    NSIndexPath *indexTableViewPhoneNumber=[NSIndexPath indexPathForRow:2 inSection:0];
    MyDetailsCell *addCellPhoneNumber=(MyDetailsCell*)[self._tableView cellForRowAtIndexPath:indexTableViewPhoneNumber];
    
    [appDelegate.emergencyManager addEmergencyContactWithName:addCellName.tfInput.text Relationship:addCellRelationship.tfInput.text PhoneNumber:addCellPhoneNumber.tfInput.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ([indexPath row]==0) {
        cell.lbTitle.text=[NSString stringWithFormat:@"Name:"];
        cell.tfInput.placeholder=[NSString stringWithFormat:@"Please enter contact name"];
    }
    else if ([indexPath row]==1)
    {
        cell.lbTitle.text=[NSString stringWithFormat:@"Relationship:"];
        cell.tfInput.placeholder=[NSString stringWithFormat:@"Please enter relationship"];

    }
    else if ([indexPath row]==2)
    {
        cell.lbTitle.text=[NSString stringWithFormat:@"Phone No.:"];
        cell.tfInput.placeholder=[NSString stringWithFormat:@"Please enter phone number"];

    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
