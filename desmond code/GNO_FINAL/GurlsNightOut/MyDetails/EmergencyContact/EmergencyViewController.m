//
//  EmergencyViewController.m
//  gno
//
//  Created by Calvin on 28/09/12.
//
//

#import "EmergencyViewController.h"
#import "EventListCell.h"

@interface EmergencyViewController ()

@end

@implementation EmergencyViewController
@synthesize _tableView;
@synthesize btAdd,function;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self._tableView reloadData];
    if (function==0) {
        btAdd.hidden=NO;
    }
    else
    {
        btAdd.hidden=YES;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self._tableView setBackgroundColor:[UIColor clearColor]];
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self set_tableView:nil];
    [self setBtAdd:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)addAction:(id)sender {
    
}

- (IBAction)backAction:(id)sender {
    if (function==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (function==1)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([appDelegate.emergencyManager.emergencyInfoArray count]!=0) {
        return [appDelegate.emergencyManager.emergencyInfoArray count];
    }
    else{
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifierNothing = @"CellNothing";
    
    if ([appDelegate.emergencyManager.emergencyInfoArray count]!=0) {
        EventListCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        cell.title.text=[[appDelegate.emergencyManager.emergencyInfoArray objectAtIndex:[indexPath row]] objectForKey:@"contactName"];
        cell.time.text=[[appDelegate.emergencyManager.emergencyInfoArray objectAtIndex:[indexPath row]] objectForKey:@"relationship"];
        return cell;
    }
    else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifierNothing];

        return cell;
    }
    
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (function==0) {
        
    }
    else if (function==1)
    {
        UIDevice *device = [UIDevice currentDevice];
        
        if ([[device model] isEqualToString:@"iPhone"])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", [[appDelegate.emergencyManager.emergencyInfoArray objectAtIndex:[indexPath row]] objectForKey:@"phoneNumber"]]]];
            
        } else
        {
            UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [Notpermitted show];
        }
    }
}
@end
