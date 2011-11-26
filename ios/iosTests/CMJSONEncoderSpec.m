//
//  CMJSONEncoderSpec.m
//  cloudmine-iosTests
//
//  Copyright (c) 2011 CloudMine, LLC. All rights reserved.
//  See LICENSE file included with SDK for details.
//

#import "Kiwi.h"

#import <uuid/uuid.h>
#import "CMJSONEncoder.h"
#import "CMJSONSerializable.h"
#import "NSString+UUID.h"

#pragma mark - Supporting objects

@interface GenericSerializableObject : NSObject <CMJSONSerializable> {
    // The magical object id required by the CMJSONSerializable protocol.
    NSString *_objectId;
}

// All the properties we will try to serialize in the test.
@property (nonatomic, strong) NSString *string1;
@property (nonatomic, strong) NSString *string2;
@property (nonatomic, assign) int simpleInt;
@property (nonatomic, strong) NSArray *arrayOfBooleans;
@property (nonatomic, strong) GenericSerializableObject *nestedObject;

- (void)fillPropertiesWithDefaults;

@end

@implementation GenericSerializableObject
@synthesize string1, string2, simpleInt, arrayOfBooleans, nestedObject;

- (id)initWithObjectId:(NSString *)theObjectId {
    if (self = [super init]) {
        _objectId = theObjectId;
    }
    return self;
}

- (void)fillPropertiesWithDefaults {
    self.string1 = @"Hello World";
    self.string2 = @"Apple Macintosh";
    self.simpleInt = 42;
    self.arrayOfBooleans = [NSArray arrayWithObjects:[NSNumber numberWithBool:YES],
                            [NSNumber numberWithBool:NO],
                            [NSNumber numberWithBool:YES],
                            [NSNumber numberWithBool:YES],
                            [NSNumber numberWithBool:NO], nil];
    self.nestedObject = [[[self class] alloc] init];
    self.nestedObject.string1 = @"Nested 1";
    self.nestedObject.string2 = @"Nested 2";
    self.nestedObject.simpleInt = 999;
    self.nestedObject.arrayOfBooleans = nil;
    self.nestedObject.nestedObject = nil;
}

- (BOOL)isEqual:(GenericSerializableObject *)object {
    return ([self.string1 isEqualToString:object.string1] &&
            [self.string2 isEqualToString:object.string2] &&
             self.simpleInt == object.simpleInt &&
            [self.arrayOfBooleans isEqualToArray:object.arrayOfBooleans] &&
            [self.nestedObject isEqual:object.nestedObject]);
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.string1 forKey:@"string1"];
    [aCoder encodeObject:self.string2 forKey:@"string2"];
    [aCoder encodeInt:self.simpleInt forKey:@"simpleInt"];
    [aCoder encodeObject:self.arrayOfBooleans forKey:@"arrayOfBooleans"];
    [aCoder encodeObject:self.nestedObject forKey:@"nestedObject"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    // Not implemented for the purposes of this test suite.
    return nil;
}

- (NSString *)objectId {
    return _objectId;
}

- (NSString *)className {
    return NSStringFromClass([self class]);
}

@end

#pragma mark - Specs

SPEC_BEGIN(CMJSONEncoderSpec)

describe(@"CMJSONEncoder", ^{    
    it(@"should encode a single object correctly", ^{
        NSString *uuid = [NSString stringWithUUID];
        GenericSerializableObject *object = [[GenericSerializableObject alloc] initWithObjectId:uuid];
        [object fillPropertiesWithDefaults];
        
        // Run the serialization.
        NSData *jsonData = [CMJSONEncoder serializeObjects:[NSSet setWithObject:object]];
        [[jsonData shouldNot] beNil];
    });
});

SPEC_END