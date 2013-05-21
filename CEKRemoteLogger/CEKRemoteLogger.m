//
//  CEKRemoteLogger.m
//  CEKRemoteLogger
//
//  Created by cihan emre kisakurek on 5/21/13.
//  Copyright (c) 2013 cekware. All rights reserved.
//

#import "CEKRemoteLogger.h"

@interface CEKRemoteLogger ()
@property(nonatomic,strong)Server *server;

@end


@implementation CEKRemoteLogger
@synthesize server;
@synthesize servers;

+ (id)startSessionWithProtocol:(NSString*)procotol{
    
    static dispatch_once_t once;
    static CEKRemoteLogger *shared;
    
    dispatch_once(&once, ^ {
        shared = [[self alloc] initWithProtocol:procotol];
    });
    
    return shared;
}

-(id)initWithProtocol:(NSString*)protocol{
    
    self = [super init];
    if (self) {
    
        Server *_server=[[Server alloc]initWithProtocol:protocol];
        _server.delegate = self;
        NSError *error = nil;
        
        if(![_server start:&error]) {
            NSLog(@"error = %@", error);
        }
        
        [self setServer:_server];
        [self setServers:[NSMutableArray array]];
    }
    return self;

}

- (void)addService:(NSNetService *)service moreComing:(BOOL)more {
    
    [self.servers addObject:service];
    [self.server connectToRemoteService:service];

}

- (void)removeService:(NSNetService *)service moreComing:(BOOL)more {
    [self.servers removeObject:service];

}

-(void)close{
    [self.server stop];
    [self.servers removeAllObjects];
}

-(void)logMessage:(NSString*)string{

    NSData* data = [[NSString stringWithFormat:@"%@:%@\n",[NSDate date],string] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error=nil;
    [self.server sendData:data error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
}

- (void)serverRemoteConnectionComplete:(Server *)server {
    
    NSLog(@"Server Started");
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(handShake:) userInfo:nil repeats:NO];
}

-(void)handShake:(id)sender{
    
    [self logMessage:@"Initializing remote logger"];
}

- (void)serverStopped:(Server *)server {
    NSLog(@"Server stopped");
    
}

- (void)server:(Server *)server didNotStart:(NSDictionary *)errorDict {
    
    NSLog(@"Server did not start %@", errorDict);
}

- (void)server:(Server *)server didAcceptData:(NSData *)data {
    
//    NSLog(@"Server did accept data %@", data);
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",str);
}

- (void)server:(Server *)server lostConnection:(NSDictionary *)errorDict {
    
    NSLog(@"Server lost connection %@", errorDict);
}

- (void)serviceAdded:(NSNetService *)service moreComing:(BOOL)more {
    
    [self addService:service moreComing:more];
}

- (void)serviceRemoved:(NSNetService *)service moreComing:(BOOL)more {
    
    [self removeService:service moreComing:more];
}

@end
