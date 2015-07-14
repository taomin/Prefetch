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
        @"link 1": @"http://finance.yahoo.com/news/mike-kail-joins-yahoo-chief-153500804.html?soc_src=mediacontentstory",
        @"link 2": @"http://caniuse.com/#feat=dom-range,mp3,css-zoom",
        @"link 3": @"https://medium.com/@zengabor/three-takeaways-for-web-developers-after-two-weeks-of-painfully-slow-internet-9e7f6d47726e",
        @"link 4": @"http://www.bbc.com/news/science-environment-33524589",
        @"link 5": @"http://www.newsy.com/49120/"
               
               
    };
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)purgeCache:(id)sender {
    [YNFetchWebUrls purgeCache];
}

- (IBAction)onLinkClick:(UIButton *)sender {
    NSString *url = self.urlMap[sender.titleLabel.text];
    
    NSLog(@"clicking link: %@", url);
    
    NSDate *startTime = [NSDate date];
    
    
    [YNFetchWebUrls fetchDataForURL:url completion:^(NSCachedURLResponse *cachedResp) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Request load time: %1.1f",[[NSDate date] timeIntervalSinceDate:startTime]);
            NSStringEncoding encoding = cachedResp.response.textEncodingName == nil ? NSUTF8StringEncoding : CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)cachedResp.response.textEncodingName));

            NSString *htmlString = [[NSString alloc] initWithData:cachedResp.data encoding:encoding];
            
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
