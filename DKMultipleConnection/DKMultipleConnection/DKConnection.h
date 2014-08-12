//
//  DKConnection.h
//  AsyncDownloader
//
//  Created by Dinesh on 12/08/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKConnection : NSObject

@property (nonatomic,retain)NSURLConnection *connection;
@property (nonatomic,retain)NSMutableData *data;
@property (nonatomic,retain)NSString *videoFileName;
@property (nonatomic,assign)BOOL isSaveForOffline;


@end
