//
//  PrefetchViewController.m
//  Prefetch
//
//  Created by Taomin Chang on 7/13/15.
//  Copyright (c) 2015 Taomin Chang. All rights reserved.
//

#import "PrefetchViewController.h"
#import "YNFetchWebUrls.h"
@import WebKit;

@interface PrefetchViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSDictionary *urlMap;
@property (nonatomic, strong) NSDate *loadStartTime;
@end

@implementation PrefetchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWebView];
    self.urlMap = @{
        @"link 1": @"https://github.com/yahoo/validatar",
        @"link 2": @"https://medium.com/@bchesky/7-rejections-7d894cbaa084",
        @"link 3": @"http://www.newyorker.com/magazine/2015/07/20/the-really-big-one",
        @"link 4": @"https://github.com/FormidableLabs/radium/blob/master/docs/comparison/README.md",
        @"link 5": @"http://yhoo.it/1HInMCZ"
               
               
    };
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)purgeCache:(id)sender {
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
}

- (IBAction)onLinkClick:(UIButton *)sender {
    NSString *url = self.urlMap[sender.titleLabel.text];
    
    NSLog(@"clicking link: %@", url);
    
    NSDate *startTime = [NSDate date];
    
    [YNFetchWebUrls fetchDataForURL:url completion:^(NSCachedURLResponse *cachedResp) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Request load time: %1.1f",[[NSDate date] timeIntervalSinceDate:startTime]);
                NSString *htmlString = [[NSString alloc] initWithData:cachedResp.data encoding:CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)cachedResp.response.textEncodingName))];
                [self.webView loadHTMLString:htmlString baseURL:[cachedResp.response URL]];
            
        });
    }];

}


- (void)createWebView
{
    CGRect frame = self.view.bounds;
    frame.origin.y += 100;
    frame.size.height -= 100;
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.loadStartTime = [NSDate date];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Page load time: %1.1f",[[NSDate date] timeIntervalSinceDate:self.loadStartTime]);
}


@end
