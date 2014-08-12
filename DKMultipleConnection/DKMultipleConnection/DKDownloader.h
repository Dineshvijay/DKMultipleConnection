//
//  DKDownloader.h
//  AsyncDownloader
//
//  Created by Dinesh on 12/08/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKConnection.h"

/*
 Delegate is used to implement and it show the download progress state of offline enabled file
 */
@protocol DKDownloaderDelegate <NSObject>

-(void)getProgressState:(float)progressValue;

@end

@interface DKDownloader : NSObject

@property (nonatomic,retain)NSMutableArray *connectionArrayList; // add the DKConnection objects
@property (nonatomic,assign)id<DKDownloaderDelegate>delegate;

/*
 Singleton class
 */
+(DKDownloader *)multipleURLConnectionDownloader;

/*
 @name - download the multiple data from multiple url usinng NSURLConnection delegate
 @param 
 url - download url
 filename - save the download data with the filename
 isOffline - if the argument is YES and it is save to offline folder
           - if the argument is NO and it is save to New-videos folder
 */

-(void)startWithURL:(NSURL *)url saveWithFileName:(NSString *)fileName offline:(BOOL)isOffline;

@end
