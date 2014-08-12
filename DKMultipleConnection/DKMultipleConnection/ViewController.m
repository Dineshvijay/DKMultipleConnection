//
//  ViewController.m
//  DKMultipleConnection
//
//  Created by Dinesh on 12/08/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "ViewController.h"
#import "DKDownloader.h"

@interface ViewController ()<DKDownloaderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self callMultipleNSURLConnections];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)callMultipleNSURLConnections{
    
    DKDownloader *downloader = [DKDownloader multipleURLConnectionDownloader];
    downloader.delegate = self;
    
    NSString *urlString1 = @"https://developer.apple.com/library/mac/releasenotes/MacOSX/WhatsNewInOSX/WhatsNewInOSX.pdf";
    NSString *urlString2 = @"https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/TransitionGuide/TransitionGuide.pdf";
    NSString *urlString3 = @"https://developer.apple.com/library/mac/documentation/MapKit/Reference/MKTileOverlay_class/MKTileOverlay_class.pdf";
    
    NSURL *url_1 =  [NSURL URLWithString:urlString1];
    NSURL *url_2 =  [NSURL URLWithString:urlString2];
    NSURL *url_3 = [ NSURL URLWithString:urlString3];
    
    [downloader startWithURL:url_1 saveWithFileName:@"WhatsNewInOSX" offline:NO];
    [downloader startWithURL:url_2 saveWithFileName:@"TransitionGuide" offline:NO];
    [downloader startWithURL:url_3 saveWithFileName:@"MKTileOverlay_class" offline:YES];
    
}

-(void)getProgressState:(float)progressValue{
    
    //Showing download progress of offline enable file
    self.progressLabel.text = [NSString stringWithFormat:@"Downloading MKTileOverlay_class PDF %.2f",progressValue];
    
}

@end
