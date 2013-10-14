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
    // make sure we have what we need, and throw an exception if we do not
    // yes I know the use of an error object is more common in Objc / Cocoa
    // but just because everyone jumps of a bridge does not mean it is a good
    // idea to do it.
    
    // ok long nasty check, default port to 3306 though
    if(!_server & !_user & !_password)
    {
        @throw [[DBException alloc] initWithName:@"Missing information" reason:@"server, user and password required" userInfo:nil];
    }
    
    // now set it all, well what is required, setting optionals to null
    // if not specified
    instance = mysql_init(NULL);
    
    const char *parameters[5];
    
    // ugly chain of if/else, TOOD: Clean this up later
    if(_socket)
        parameters[0] = [_socket UTF8String];
    else
        parameters[0] = NULL;
    
    parameters[1] = [_server UTF8String];
    
    if(_databaseName)
        parameters[2] = [_databaseName UTF8String];
    else
        parameters[2] = NULL;
    
    parameters[3] = [_user UTF8String];
    
    parameters[4] = [_password UTF8String];
    
    if(!_port)
        _port = 3306;
    
    // and now attempt the actual connection
    if(!mysql_real_connect(instance, parameters[1], parameters[3], parameters[4], parameters[2], _port, parameters[0], 0))
    {
        @throw [[DBException alloc] initWithName:@"Connection Exception" reason:error userInfo:nil];
    }
    
    // and theoretically this is not needed
    mysql_set_character_set(instance, "utf8");
    
}
@end
