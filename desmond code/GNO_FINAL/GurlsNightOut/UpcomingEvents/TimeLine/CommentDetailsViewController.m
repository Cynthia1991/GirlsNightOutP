//
//  CommentDetailsViewController.m
//  gno
//
//  Created by Calvin on 16/08/12.
//
//

#import "CommentDetailsViewController.h"
#import "EventMainPageTableCell.h"

@interface CommentDetailsViewController ()

@end

@implementation CommentDetailsViewController
@synthesize commentsArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    iconDic=[[NSMutableDictionary alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [commentsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
   
    EventMainPageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    cell.lbName.text=[NSString stringWithFormat:@"%@",[[[commentsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"] objectForKey:@"userName"]];
    
    
    
    if ([[[[commentsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"] objectForKey:@"photosDBID"] intValue]!=0) {
        if ([[[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@",[[[commentsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"] objectForKey:@"photosDBID"]]] objectForKey:@"path"]!=0) {
            if ([iconDic objectForKey:[NSString stringWithFormat:@"id%@",[[[commentsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"] objectForKey:@"photosDBID"]]]!=nil) {
                UIImage *img=[iconDic objectForKey:[NSString stringWithFormat:@"id%@",[[[commentsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"] objectForKey:@"photosDBID"]]];
                cell.ivIcon.image=img;
            }
            else {
                UIImage *img=[[appDelegate photoManager] getPhotoByPhotoDBID:[[[commentsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"] objectForKey:@"photosDBID"]];
                [iconDic setObject:img forKey:[NSString stringWithFormat:@"id%@",[[[commentsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"] objectForKey:@"photosDBID"]]];
                cell.ivIcon.image=img;
            }
            
        }
        else {

        }
    }
    else {
        UIImage *img=[UIImage imageNamed:@"Persondot.png"];
        cell.ivIcon.image=img;
    }
    
    NSDate *date = [[commentsArray objectAtIndex:[indexPath row]] objectForKey:@"timeCreated"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE, dd MMM HH:mm"];
    NSString *theDate = [dateFormat stringFromDate:date];
    NSString *timeStr=[NSString stringWithFormat:@"%@",theDate];
    cell.lbPostTime.text = timeStr;
    
    cell.lbPostContent.text=[[commentsArray objectAtIndex:[indexPath row]] objectForKey:@"comment"];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
