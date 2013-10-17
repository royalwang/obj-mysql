//
//  DBQuery.m
//  obj-mysql
//
//  Created by Christian Hansson on 10/15/13.
//  Copyright (c) 2013 ipluris. All rights reserved.
//

#import "DBQuery.h"

@implementation DBQuery

@synthesize sqlStatement = _sqlStatement;

// ----------------------------------------------------------------------------
- (id)initWithDatabase:(DBInstance *)db;
{
    self = [super init];
    
    if(self)
    {
        database = db;
        theRows = [NSMutableArray array];
    }
    
    return self;
}

// ----------------------------------------------------------------------------
- (void)executeQuery
{
    // make sure there are nothing in the internal data representation
    [theRows removeAllObjects];
    numberOfFields = 0;
    
    // and execute the query, checking the result. Again using
    // exception here rather than error object
    if(mysql_query([database dbInstance], [_sqlStatement UTF8String]))
    {
        [database recordError];
        @throw [[DBException alloc] initWithName:@"Query Exception" reason:[database error] userInfo:nil];
    }
    
    // ok now lets get the result set.
    // TODO: NOTE! This means keeping it all in memory. Consider taking each row as requested. I.e. an iterator style db read
    
    MYSQL_RES *result  = mysql_use_result([database dbInstance]);
    
    if(result)
    {
        numberOfFields = mysql_num_fields(result);
        
        MYSQL_ROW currentRow;
        while((currentRow = mysql_fetch_row(result)))
        {
            unsigned long *colLength = mysql_fetch_lengths(result);
            
            NSMutableArray *current = [NSMutableArray array];
            for(int colIndex = 0; colIndex < numberOfFields; colIndex++)
            {
                if(currentRow[colIndex] != NULL)
                {
                    [current addObject:[NSData dataWithBytes:currentRow[colIndex] length:colLength[colIndex]]];
                }
                else
                {
                    [current addObject:[NSData data]]; // same comment as above
                }
            }
            [theRows addObject:current];
        }
        
        mysql_free_result(result);
    }
}

// ----------------------------------------------------------------------------
- (void)executeQuery:(NSString *)statement
{
    _sqlStatement = statement;
    
    [self executeQuery];
}

// ----------------------------------------------------------------------------
- (int)rowCount
{
    return (int)[theRows count];
}

// ----------------------------------------------------------------------------
- (NSString *)stringValueFromRow:(int)row andColumn:(int)col
{
    NSData *raw = [[theRows objectAtIndex:row] objectAtIndex:col];
    
    NSString *returnData = [[NSString alloc] initWithBytes:[raw bytes] length:[raw length] encoding:NSUTF8StringEncoding];
    
    return returnData;
}

// ----------------------------------------------------------------------------
- (NSDate *)dateValueFromRow:(int)row andColumn:(int)col
{
    NSString *stringRep = [self stringValueFromRow:row andColumn:col];
    
    NSDateFormatter *dateFormate = [NSDateFormatter new];
    [dateFormate setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormate dateFromString:stringRep];
}

// ----------------------------------------------------------------------------
- (NSDate *)dateTimeValueFromRow:(int)row andColumn:(int)col
{
    NSString *stringRep = [self stringValueFromRow:row andColumn:col];
    
    NSDateFormatter *dateFormate = [NSDateFormatter new];
    [dateFormate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormate dateFromString:stringRep];
}

// ----------------------------------------------------------------------------
- (int)intValueFromRow:(int)row andColumn:(int)col
{
    return [[self stringValueFromRow:row andColumn:col] intValue];
}

// ----------------------------------------------------------------------------
- (double)doubleValueFromRow:(int)row andColumn:(int)col
{
    return [[self stringValueFromRow:row andColumn:col] doubleValue];
}

// ----------------------------------------------------------------------------
- (NSData *)rawValueFromRow:(int)row andColumn:(int)col
{
    return [[theRows objectAtIndex:row] objectAtIndex:col];
}

// ----------------------------------------------------------------------------
// Could I just 86 this method ?
- (long)insertedId
{
    return (long)mysql_insert_id([database dbInstance]);
}
@end
