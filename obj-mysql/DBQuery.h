//
//  DBQuery.h
//  obj-mysql
//
//  Created by Christian Hansson on 10/15/13.
//  Copyright (c) 2013 ipluris. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
