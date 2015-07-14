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

@interface PrefetchViewController ()
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSDictionary *urlMap;
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
        @"link 5": @"http://yahoo.com"
               
               
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
    
    [YNFetchWebUrls fetchDataForURL:url completion:^(NSCachedURLResponse *cachedResp) {
        if (cachedResp == nil) {
            NSLog(@"not cached");
            [self.webView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]]];
        } else {
            NSString *htmlString = [[NSString alloc] initWithData:cachedResp.data encoding:NSUTF8StringEncoding];
            NSLog(@"load from cached");
            [self.webView loadHTMLString:htmlString baseURL:[cachedResp.response URL]];
        }
    }];

}


- (void)createWebView
{
    CGRect frame = self.view.bounds;
    frame.origin.y += 100;
    frame.size.height -= 100;
    self.webView = [[WKWebView alloc] initWithFrame:frame];
    [self.view addSubview:self.webView];
}


@end
