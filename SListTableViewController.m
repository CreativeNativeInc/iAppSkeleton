//
//  SListTableViewController.m
//  iAppSkeleton
//
//  Created by Jon Smith on 9/21/17.
//  Copyright (c) 2017 Jon Smith. All rights reserved.
//

#import "ListTableViewController.h"
#import "MDetailviewController.h"

@interface SListTableViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) NSMutableArray *songArray;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) UIImage *albumLgArt;

@end

@implementation SListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _songArray = [NSMutableArray array];
    
    self.navigationItem.title = @"iAppSkeleton Song List";
    [self mRequest];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

        return [_songArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mCell" forIndexPath:indexPath];
    
    NSDictionary *listingDict = _songArray[indexPath.row];
    
    NSString *artist = listingDict[@"artistName"];
    NSString *album = listingDict[@"collectionName"];
    NSString *song = listingDict[@"trackName"];
    NSString *albumURL = listingDict[@"artworkUrl30"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", artist, album];
    cell.detailTextLabel.text = song;
    UIImage *albumArt = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: albumURL]]];
    cell.imageView.image = albumArt;
    
    return cell;
}

#pragma mark - Parse Json Methods

-(void)mRequest
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config
                                             delegate:nil
                                        delegateQueue:nil];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    [indicator startAnimating];
    
    NSString *queryString = [_passedTitleString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@", queryString];
    NSURL *myURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    NSURLSessionTask *task = [_session dataTaskWithRequest:request completionHandler:
                              ^(NSData *data, NSURLResponse *response, NSError *error)
                              {
                                  NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:0
                                                                                                 error:nil];
                                  
                                  if (responseData) {
                                      NSArray *immutablem = responseData[@"results"];
                                      for (NSDictionary *listingDictionary in immutablem) {
                                        
                                          [_songArray addObject:listingDictionary];
                                          
                                          self.navigationItem.title = _passedTypeString;
                                          
                                      }
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self.tableView reloadData];
                                          [indicator stopAnimating];
                                      });
                                  };
                              }];
    [task resume];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.destinationViewController isKindOfClass:[mDetailViewController class]])
    {
        mDetailViewController *mdvc = (mDetailViewController *)segue.destinationViewController;
        
        NSIndexPath *mPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *mDict = _songArray[mPath.row];
        
        mdvc.passedArtist = mDict[@"artistName"];
        mdvc.passedSong = mDict[@"trackName"];
        mdvc.passedImage = mDict[@"artworkUrl60"];
        
    }
    
}

@end
