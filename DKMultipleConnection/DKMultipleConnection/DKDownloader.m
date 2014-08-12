//
//  DKDownloader.m
//  AsyncDownloader
//
//  Created by Dinesh on 12/08/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//
#define DIRNAME1 @"NEW"
#define DIRNAME2 @"OFFLINE"
#define FILE_FORMAT @".pdf" //File type

#import "DKDownloader.h"

@interface DKDownloader()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    
    long long totolDownloadSize;
}

@end

@implementation DKDownloader

+(DKDownloader *)multipleURLConnectionDownloader{
    
    static DKDownloader *sharedDownloader = nil;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        sharedDownloader = [[self alloc]init];
    });
    
    return sharedDownloader;
}

-(id)init{
    
    if(self = [super init]){
        
        self.connectionArrayList = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)startWithURL:(NSURL *)url saveWithFileName:(NSString *)fileName offline:(BOOL)isOffline{
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    DKConnection *dkConnector = [[DKConnection alloc]init];
    dkConnector.connection = connection;
    dkConnector.data = [NSMutableData data];
    dkConnector.videoFileName = fileName;
    dkConnector.isSaveForOffline = isOffline;
    [self.connectionArrayList addObject:dkConnector];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    DKConnection  *dkConnection = [self getConnection:connection];
    [dkConnection.data setLength:0];
    if(dkConnection.isSaveForOffline){
        
        totolDownloadSize = [response expectedContentLength];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    DKConnection *dkConnection = [self getConnection:connection];
    [dkConnection.data appendData:data];
    NSLog(@"APPEND DATA FOR FileName %@",dkConnection.videoFileName);
    
    if(dkConnection.isSaveForOffline){
        
        float progress = ((float)[dkConnection.data length] )/ ((float) totolDownloadSize);
        NSLog(@"progress %0.2f",progress);
        
        //Delegate method for passing the progress state of offline enabled NURL
        [self.delegate getProgressState:progress];
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    DKConnection *dkConnection = [self getConnection:connection];
    [self writeData:dkConnection.data atFileName:dkConnection.videoFileName andCheckOffline:dkConnection.isSaveForOffline];
       
}

//get the relevant connection object
-(DKConnection *)getConnection:(NSURLConnection *)connection{
    
    for(DKConnection *dkConnection in self.connectionArrayList){
        
        if([dkConnection.connection isEqual:connection]){
            return dkConnection;
        }
    }
    return nil;
}

-(void)writeData:(NSMutableData *)data atFileName:(NSString *)fileName andCheckOffline:(BOOL)isOffline{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dirPath = [path objectAtIndex:0];
    NSString *dir = nil;
    if(isOffline){
        dir=[NSString stringWithFormat:@"/%@",DIRNAME2];
    }
    else{
        dir = [NSString stringWithFormat:@"/%@",DIRNAME1];
    }
    NSString *folder = [dirPath stringByAppendingPathComponent:dir];
    
    NSFileManager *filemanager =[NSFileManager defaultManager];
    
    if(![filemanager fileExistsAtPath:folder]){
        
        [filemanager createDirectoryAtPath:folder withIntermediateDirectories:NO attributes:nil error:nil];
        NSString *file = [NSString stringWithFormat:@"%@%@",fileName,FILE_FORMAT];
        NSString *videoFilePath = [folder stringByAppendingPathComponent:file];
        [data writeToFile:videoFilePath atomically:YES];
        NSLog(@"FILE PATH %@",videoFilePath);
    }
    else{
        
        NSString *file = [NSString stringWithFormat:@"%@%@",fileName,FILE_FORMAT];
        NSString *videoFilePath = [folder stringByAppendingPathComponent:file];
        [data writeToFile:videoFilePath atomically:YES];
        NSLog(@"FILE PATH %@",videoFilePath);
    }
    
}
@end
