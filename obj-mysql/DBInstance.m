//
//  DBInstance.m
//  obj-mysql
//
//  Created by Christian Hansson on 10/13/13.
//  Copyright (c) 2013 ipluris. All rights reserved.
//

#import "DBInstance.h"

@implementation DBInstance

@synthesize socket = _socket;
@synthesize server = _server;
@synthesize databaseName = _databaseName;
@synthesize user = _user;
@synthesize password = _password;
@synthesize port = _port;

// ----------------------------------------------------------------------------
- (id) init
{
    self = [super init];
    
    if(self)
    {
        if(mysql_library_init(0, NULL, NULL))
        {
            NSLog(@"MySQL library intialization error");
            self = nil;
        }
    }
    return self;
}

// ----------------------------------------------------------------------------
// this is not really necessary but good style
- (void) finalize
{
    mysql_library_end();
}

// ----------------------------------------------------------------------------
- (void)connect
{
    
}
@end
