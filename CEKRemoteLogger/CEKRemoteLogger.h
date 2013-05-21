//
//  CEKRemoteLogger.h
//  CEKRemoteLogger
//
//  Created by cihan emre kisakurek on 5/21/13.
//  Copyright (c) 2013 cekware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Server.h"
#define protocolName @"hebele"

@interface CEKRemoteLogger : NSObject<ServerDelegate>{

}


@property(strong)NSMutableArray *servers;

+ (id)startSessionWithProtocol:(NSString*)procotol;
-(void)close;
-(void)logMessage:(NSString*)string;

@end
