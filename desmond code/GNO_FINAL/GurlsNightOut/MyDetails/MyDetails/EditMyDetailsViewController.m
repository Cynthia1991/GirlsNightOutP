//
//  EditMyDetailsViewController.m
//  gno
//
//  Created by Calvin on 20/08/12.
//
//

#import "EditMyDetailsViewController.h"
#import "MyDetailsCell.h"

@interface EditMyDetailsViewController ()

@end

@implementation EditMyDetailsViewController
@synthesize _tableView,function,friendInfoDic;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self._tableView setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidUnload
{
    [self set_tableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (function==0) {
        if (section==0) {
            if ([[appDelegate.myDetailsManager.userInfoDic objectForKey:@"loginType"] intValue]==0) {
                return 1;
            }
            else{
                return 2;
            }
        }
        else if (section==1)
        {
            return 2;
        }
    }
    else
    {
        if (section==0) {
            return 1;
        }
        else if (section==1)
        {
            return 2;
        }
    }
    // Return the number of rows in the section.

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (function==0) {//edit my details
        if ([indexPath section]==0) {
            if ([indexPath row]==0) {
                cell.lbTitle.text=[NSString stringWithFormat:@"Name:"];
                cell.tfInput.text=[NSString stringWithFormat:@"%@",[[[appDelegate myDetailsManager] userInfoDic] objectForKey:@"userName"]];
            }
            else if ([indexPath row]==1)
            {
                if ([[appDelegate.myDetailsManager.userInfoDic objectForKey:@"loginType"] intValue]!=0) {
                    cell.lbTitle.text=[NSString stringWithFormat:@"Password:"];
                    cell.tfInput.text=[NSString stringWithFormat:@"%@",[[[appDelegate myDetailsManager] userInfoDic] objectForKey:@"userPassword"]];
                }
            }
        }
        else if ([indexPath section]==1)
        {
            if ([indexPath row]==0) {
                cell.lbTitle.text=[NSString stringWithFormat:@"Phone:"];
                [cell.tfInput setKeyboardType:UIKeyboardTypePhonePad];
                if ([[[[appDelegate myDetailsManager] userPersonalInfoDic] objectForKey:@"mobilePhone"] length]!=0) {
                    cell.tfInput.text=[NSString stringWithFormat:@"%@",[[[appDelegate myDetailsManager] userPersonalInfoDic] objectForKey:@"mobilePhone"]];
                }
                else
                {
                    cell.tfInput.text=[NSString stringWithFormat:@""];
                    cell.tfInput.placeholder=[NSString stringWithFormat:@"Phone number for sharing"];

                }
            }
            else if ([indexPath row]==1)
            {
                cell.lbTitle.text=[NSString stringWithFormat:@"Facebook:"];
                [cell.tfInput setKeyboardType:UIKeyboardTypeEmailAddress];

                if ([[[[appDelegate myDetailsManager] userPersonalInfoDic] objectForKey:@"facebook"] length]!=0) {
                    cell.tfInput.text=[NSString stringWithFormat:@"%@",[[[appDelegate myDetailsManager] userPersonalInfoDic] objectForKey:@"facebook"]];
                }
                else
                {
                    cell.tfInput.text=[NSString stringWithFormat:@""];
                    cell.tfInput.placeholder=[NSString stringWithFormat:@"Facebook for sharing"];

                }
            }
        }
    }
    else if(function==1)
    {
        if ([indexPath section]==0) {
            if ([indexPath row]==0) {
                cell.lbTitle.text=[NSString stringWithFormat:@"Name:"];
                cell.tfInput.text=[NSString stringWithFormat:@"%@",[friendInfoDic objectForKey:@"userName"]];
            }
        }
        else if ([indexPath section]==1)
        {
            if ([indexPath row]==0) {
                cell.lbTitle.text=[NSString stringWithFormat:@"Phone:"];
                [cell.tfInput setKeyboardType:UIKeyboardTypePhonePad];

                if ([[friendInfoDic objectForKey:@"mobilePhone"] length]!=0) {
                    cell.tfInput.text=[NSString stringWithFormat:@"%@",[friendInfoDic objectForKey:@"mobilePhone"]];
                }
                else
                {
                    cell.tfInput.text=[NSString stringWithFormat:@""];
                    cell.tfInput.placeholder=[NSString stringWithFormat:@"Phone number for sharing"];
                }
            }
            else if ([indexPath row]==1)
            {
                cell.lbTitle.text=[NSString stringWithFormat:@"Facebook:"];
                [cell.tfInput setKeyboardType:UIKeyboardTypeEmailAddress];

                if ([[friendInfoDic objectForKey:@"facebook"] length]!=0) {
                    cell.tfInput.text=[NSString stringWithFormat:@"%@",[friendInfoDic objectForKey:@"facebook"]];
                }
                else
                {
                    cell.tfInput.text=[NSString stringWithFormat:@""];
                    cell.tfInput.placeholder=[NSString stringWithFormat:@"Facebook email for sharing"];

                }
            }
        }
    }

    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)btDoneAction:(id)sender {
    if (function==0) {//my detail
        NSString *userName=[NSString stringWithFormat:@""];
        NSIndexPath *indexTableViewDetails=[NSIndexPath indexPathForRow:0 inSection:0];
        MyDetailsCell *userNameCell=(MyDetailsCell*)[self._tableView cellForRowAtIndexPath:indexTableViewDetails];
        userName=[NSString stringWithFormat:@"%@",userNameCell.tfInput.text];
        
        NSString *userPassword=[NSString stringWithFormat:@""];
        if ([[appDelegate.myDetailsManager.userInfoDic objectForKey:@"loginType"] intValue]!=0) {
            NSIndexPath *indexTableViewDetails=[NSIndexPath indexPathForRow:1 inSection:0];
            MyDetailsCell *userNameCell=(MyDetailsCell*)[self._tableView cellForRowAtIndexPath:indexTableViewDetails];
            userPassword=[NSString stringWithFormat:@"%@",userNameCell.tfInput.text];
        }
        
        [appDelegate.myDetailsManager.userInfoDic setObject:userName forKey:@"userName"];
        
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        //    [k editMyDetailsWithUserDBID:[[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"] intValue] andUserName:userName andUserPassword:userPassword andLoginType:[[appDelegate.myDetailsManager.userInfoDic objectForKey:@"loginType"] intValue]];
//        [k updateMyDetailsWithUserName:userName andUserDBID:[[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"] intValue]];
        [k updateMyDetailsWithUserDBID:[[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"] intValue] andUserName:userName andUserPassword:userPassword];
        
        NSIndexPath *indexTableViewPhone=[NSIndexPath indexPathForRow:0 inSection:1];
        MyDetailsCell *phoneCell=(MyDetailsCell*)[self._tableView cellForRowAtIndexPath:indexTableViewPhone];
        [appDelegate.myDetailsManager.userPersonalInfoDic setObject:[NSString stringWithFormat:@"%@",phoneCell.tfInput.text] forKey:@"mobilePhone"];
        
        NSIndexPath *indexTableViewFacebook=[NSIndexPath indexPathForRow:1 inSection:1];
        MyDetailsCell *facebookCell=(MyDetailsCell*)[self._tableView cellForRowAtIndexPath:indexTableViewFacebook];
        [appDelegate.myDetailsManager.userPersonalInfoDic setObject:[NSString stringWithFormat:@"%@",facebookCell.tfInput.text] forKey:@"facebook"];
        
        [appDelegate.myDetailsManager rewriteUserInfoDic];
        [appDelegate.myDetailsManager rewriteUserPersonalInfoDic];
        [appDelegate.myDetailsManager initShareDic];
    }
    else if (function==1)//friend detail
    {
        NSString *userName=[NSString stringWithFormat:@""];
        NSIndexPath *indexTableViewDetails=[NSIndexPath indexPathForRow:0 inSection:0];
        MyDetailsCell *userNameCell=(MyDetailsCell*)[self._tableView cellForRowAtIndexPath:indexTableViewDetails];
        userName=[NSString stringWithFormat:@"%@",userNameCell.tfInput.text];
        
        NSIndexPath *indexTableViewPhone=[NSIndexPath indexPathForRow:0 inSection:1];
        MyDetailsCell *phoneCell=(MyDetailsCell*)[self._tableView cellForRowAtIndexPath:indexTableViewPhone];
        
        NSIndexPath *indexTableViewFacebook=[NSIndexPath indexPathForRow:1 inSection:1];
        MyDetailsCell *facebookCell=(MyDetailsCell*)[self._tableView cellForRowAtIndexPath:indexTableViewFacebook];
        
        
        for (int i=0; i<[appDelegate.friendsManager.friendsList count]; i++) {
            if ([[[appDelegate.friendsManager.friendsList objectAtIndex:i] objectForKey:@"userDBID"] intValue]==[[friendInfoDic objectForKey:@"userDBID"] intValue]) {
                [[appDelegate.friendsManager.friendsList objectAtIndex:i] setObject:userName forKey:@"userName"];
                [[appDelegate.friendsManager.friendsList objectAtIndex:i] setObject:[NSString stringWithFormat:@"%@",phoneCell.tfInput.text] forKey:@"mobilePhone"];
                [[appDelegate.friendsManager.friendsList objectAtIndex:i] setObject:[NSString stringWithFormat:@"%@",facebookCell.tfInput.text] forKey:@"facebook"];
                
                [friendInfoDic setObject:userName forKey:@"userName"];
                [friendInfoDic setObject:[NSString stringWithFormat:@"%@",phoneCell.tfInput.text] forKey:@"mobilePhone"];
                [friendInfoDic setObject:[NSString stringWithFormat:@"%@",facebookCell.tfInput.text] forKey:@"facebook"];
                break;
            }
        }
        [appDelegate.friendsManager writeToFile];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (IBAction)btBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation updateMyDetailsDidCompleteWithResult:(NSNumber *)affectedRows
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
