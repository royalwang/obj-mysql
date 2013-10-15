//
//  DBInstance.h
//  obj-mysql
//
//  Created by Christian Hansson on 10/13/13.
//  Copyright (c) 2013 ipluris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBException.h"

#import "mysql.h"

@interface DBInstance : NSObject
{
    MYSQL *instance; // self explanatory
}

@property (readwrite)NSString *socket;
@property (readwrite)NSString *server;
@property (readwrite)NSString *databaseName;
@property (readwrite)NSString *user;
@property (readwrite)NSString *password;
@property unsigned int port;

@property (readwrite)NSString *error;

- (void)connect;
- (void)connectTo:(NSString *)server andDatabase:(NSString *)db onPort:(unsigned int)port withUser:(NSString *)user andPassword:(NSString *)password;
- (void)disconnect;
- (BOOL)connected;
- (void)recordError;

- (NSString *)safe:(NSString *)source;

- (MYSQL *)dbInstance;
@end
