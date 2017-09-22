//
//  mDetailViewController.m
//  iAppSkeleton
//
//  Created by Jon Smith on 9/21/17.
//  Copyright (c) 2017 Jon Smith. All rights reserved.
//

#import "mDetailViewController.h"

@interface mDetailViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *lyricWebView;
@property (strong, nonatomic) IBOutlet UIImageView *albumImage;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (strong, nonatomic) NSString *imageLgURL;
@property (strong, nonatomic) UIImage *albumLgArt;

@end

@implementation mDetailViewController

- (void)viewDidLoad {
    
    // Do any additional setup after loading the view.
    _lyricWebView.delegate = self;
    
   self.navigationItem.title = @"iAppSkeleton Lyric Page";
    
    _imageLgURL = _passedImage;
    _albumLgArt = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: _imageLgURL]]];
                                          
    _albumImage.image = _albumLgArt;
    _artistLabel.text = _passedArtist;
    _songTitleLabel.text = _passedSong;
    
    [self lyricRequest];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Webview methods

-(void)lyricRequest
{
    [super viewDidLoad];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    [indicator startAnimating];
    NSString *artistString = [_passedArtist stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *songString = [_passedSong stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *urlString = [NSString stringWithFormat:@"http://lyrics.wikia.com/wiki/%@:%@", artistString, songString];
    NSURL *myURL = [NSURL URLWithString:urlString];
    [_lyricWebView loadRequest:[NSURLRequest requestWithURL:myURL]];
    
    [indicator stopAnimating];
}

@end
