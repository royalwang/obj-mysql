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
            NSMutableArray *current = [NSMutableArray array];
            for(int colIndex = 0; colIndex < numberOfFields; colIndex++)
            {
                if(currentRow[colIndex] != NULL)
                {
                    [current addObject:[NSString stringWithUTF8String:currentRow[colIndex]]]; // TODO: perhaps better to store as NSData, need to investigate
                }
                else
                {
                    [current addObject:@""]; // same comment as above
                }
            }
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
- (NSString *)stringValueFromRow:(int)row andColumn:(int)col
{
    return [[theRows objectAtIndex:row] objectAtIndex:col];
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
// Could I just 86 this method ?
- (long)insertedId
{
    return (long)mysql_insert_id([database dbInstance]);
}
@end
