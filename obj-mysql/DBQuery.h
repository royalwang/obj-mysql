//
//  DBQuery.h
//  obj-mysql
//
//  Created by Christian Hansson on 10/15/13.
//  Copyright (c) 2013 ipluris. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBInstance.h"

@interface DBQuery : NSObject
{
    DBInstance *database;
    NSMutableArray *theRows;
    int numberOfFields;
}

@property (readwrite)NSString *sqlStatement;

- (id)initWithDatabase:(DBInstance *)db;

- (void)executeQuery;
- (void)executeQuery:(NSString *)statement;

- (long)insertedId;
- (int)rowCount;

- (NSString *)stringValueFromRow:(int)row andColumn:(int)col;
- (NSDate *)dateValueFromRow:(int)row andColumn:(int)col;
- (NSDate *)dateTimeValueFromRow:(int)row andColumn:(int)col;
- (NSData *)rawValueFromRow:(int)row andColumn:(int)col;

- (int)intValueFromRow:(int)row andColumn:(int)col;
- (double)doubleValueFromRow:(int)row andColumn:(int)col;

@end
