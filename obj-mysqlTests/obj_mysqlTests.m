//
//  obj_mysqlTests.m
//  obj-mysqlTests
//
//  Created by Christian Hansson on 10/13/13.
//  Copyright (c) 2013 ipluris. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DBInstance.h"
#import "DBQuery.h"

@interface obj_mysqlTests : XCTestCase
{
    DBInstance *db;
}

@end

@implementation obj_mysqlTests

// ----------------------------------------------------------------------------
- (void)setUp
{
    [super setUp];
    
    db = [[DBInstance alloc] init];
    
    @try
    {
        [db connectTo:@"localhost" andDatabase:@"unittest" onPort:3306 withUser:@"unittest" andPassword:@"unittest"];
    }
    @catch (DBException *exception)
    {
        XCTFail(@"Failed to connect: %@", [exception reason]);
    }
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [db disconnect];
}

// ----------------------------------------------------------------------------
- (void)testReadInt
{
    @try
    {
        DBQuery *query = [[DBQuery alloc] initWithDatabase:db];
        
        [query executeQuery:@"SELECT * FROM test"];
        
        int readValue = [query intValueFromRow:0 andColumn:0];
        
        if(readValue != 1)
           XCTFail(@"Excepted int value of : 1, received int value of %d", readValue);
        
    }
    @catch (DBException *exception) {
        XCTFail(@"Failed reading in: %@", [exception reason]);
    }

    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

// ----------------------------------------------------------------------------
- (void)testReadDouble
{
    @try
    {
        DBQuery *query = [[DBQuery alloc] initWithDatabase:db];
        
        [query executeQuery:@"SELECT * FROM test"];
        
        double readValue = [query doubleValueFromRow:0 andColumn:1];
        
        if(readValue != 3.1415)
            XCTFail(@"Excepted double value of : 3.1415, received double value of %f", readValue);
        
    }
    @catch (DBException *exception) {
        XCTFail(@"Failed reading in: %@", [exception reason]);
    }
}

// ----------------------------------------------------------------------------
- (void)testReadString
{
    @try {
        DBQuery *query = [[DBQuery alloc] initWithDatabase:db];
        
        [query executeQuery:@"SELECT * FROM test"];
        
        NSString *readValue = [query stringValueFromRow:0 andColumn:2];
        
        NSComparisonResult result = [readValue compare:@"this is a string"];
        
        if(result != NSOrderedSame)
            XCTFail(@"Excepted string 'this is a string' received string value of '%@'", readValue);
    }
    @catch (DBException *exception) {
        XCTFail(@"Failed reading in: %@", [exception reason]);
    }
    
}
@end
