//
//  NSCalendar+HLSExtensionsTestCase.m
//  CoconutKit-test
//
//  Created by Samuel Défago on 17.08.11.
//  Copyright 2011 Hortis. All rights reserved.
//

#import "NSCalendar+HLSExtensionsTestCase.h"

@interface NSCalendar_HLSExtensionsTestCase ()

@property (nonatomic, retain) NSCalendar *calendar;
@property (nonatomic, retain) NSTimeZone *timeZoneZurich;
@property (nonatomic, retain) NSTimeZone *timeZoneTahiti;
@property (nonatomic, retain) NSDate *date1;
@property (nonatomic, retain) NSDate *date2;
@property (nonatomic, retain) NSDate *date3;
@property (nonatomic, retain) NSDate *date4;
@property (nonatomic, retain) NSDate *date5;

@end

@implementation NSCalendar_HLSExtensionsTestCase

#pragma mark Object creation and destruction

- (void)dealloc
{
    self.calendar = nil;
    self.date1 = nil;
    self.date2 = nil;
    self.date3 = nil;
    self.date4 = nil;
    self.date5 = nil;
    self.timeZoneZurich = nil;
    self.timeZoneTahiti = nil;
    
    [super dealloc];
}

#pragma mark Accessors and mutators

@synthesize calendar = m_calendar;

@synthesize timeZoneZurich = m_timeZoneZurich;

@synthesize timeZoneTahiti = m_timeZoneTahiti;

@synthesize date1 = m_date1;

@synthesize date2 = m_date2;

@synthesize date3 = m_date3;

@synthesize date4 = m_date4;

@synthesize date5 = m_date5;

#pragma mark Test setup and tear down

- (void)setUpClass
{
    [super setUpClass];
    
    // Europe/Zurich uses CEST during summer, between 1:00 UTC on the last Sunday of March and until 1:00 on the last Sunday of October. 
    // CET is used for the rest of the year. Pacific/Tahiti does not use daylight saving times. In summary:
    //   - when Europe/Zurich uses CET (UTC+1): Zurich is 11 hours ahead of Tahiti (UTC-10)
    //   - when Europe/Zurich uses CEST (UTC+2): Zurich is 12 hours ahead of Tahiti (UTC-10)
    self.calendar = [NSCalendar currentCalendar];
    self.timeZoneZurich = [NSTimeZone timeZoneWithName:@"Europe/Zurich"];
    self.timeZoneTahiti = [NSTimeZone timeZoneWithName:@"Pacific/Tahiti"];
    
    // The two dates below correspond to days which are different whether we are in the Zurich time zone or in the Tahiti time zone
    // Date corresponding to the beginning of the year
    
    // For Europe/Zurich, this corresponds to 2012-01-01 08:23:00 (CET, UTC+1); for Pacific/Tahiti to 2011-12-31 21:23:00 (UTC-10)
    self.date1 = [NSDate dateWithTimeIntervalSinceReferenceDate:347095380.];
    
    // Date corresponding to March 1st on a leap year
    // For Europe/Zurich, this corresponds to 2012-03-01 06:12:00 (CET, UTC+1); for Pacific/Tahiti to 2012-02-29 19:12:00 (UTC-10)
    self.date2 = [NSDate dateWithTimeIntervalSinceReferenceDate:352271520.];
    
    // The three dates below are used to test the CET -> CEST transition in the Europe/Zurich time zone
        
    // For Europe/Zurich, this corresponds to 2012-03-25 01:00:00 (CET, UTC+1); for Pacific/Tahiti to 2012-03-24 14:00:00 (UTC-10). This
    // is one hour before the transition occurs
    self.date3 = [NSDate dateWithTimeIntervalSinceReferenceDate:354326400.];
    
    // For Europe/Zurich, this corresponds to 2012-03-25 03:00:00 (CEST, UTC+2); for Pacific/Tahiti to 2012-03-24 15:00:00 (UTC-10). This
    // is the exact time at which the transition occurs (i.e. the first date in CEST)
    self.date4 = [NSDate dateWithTimeIntervalSinceReferenceDate:354330000.];
    
    // For Europe/Zurich, this corresponds to 2012-03-26 05:00:00 (CEST, UTC+2); for Pacific/Tahiti to 2012-03-25 17:00:00 (UTC-10). This
    // is about a day after the CET -> CEST transition has occurred
    self.date5 = [NSDate dateWithTimeIntervalSinceReferenceDate:354423600.];
}

#pragma mark Tests

- (void)testDateFromComponentsInTimeZone
{
    NSDateComponents *dateComponentsZurich1 = [[[NSDateComponents alloc] init] autorelease];
    [dateComponentsZurich1 setYear:2012];
    [dateComponentsZurich1 setMonth:1];
    [dateComponentsZurich1 setDay:1];
    [dateComponentsZurich1 setHour:8];
    [dateComponentsZurich1 setMinute:23];
    NSDate *dateZurich1 = [self.calendar dateFromComponents:dateComponentsZurich1 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([dateZurich1 isEqualToDate:self.date1], @"Incorrect date");
    
    NSDateComponents *dateComponentsZurich2 = [[[NSDateComponents alloc] init] autorelease];
    [dateComponentsZurich2 setYear:2012];
    [dateComponentsZurich2 setMonth:3];
    [dateComponentsZurich2 setDay:1];
    [dateComponentsZurich2 setHour:6];
    [dateComponentsZurich2 setMinute:12];
    NSDate *dateZurich2 = [self.calendar dateFromComponents:dateComponentsZurich2 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([dateZurich2 isEqualToDate:self.date2], @"Incorrect date");
    
    NSDateComponents *dateComponentsZurich3 = [[[NSDateComponents alloc] init] autorelease];
    [dateComponentsZurich3 setYear:2012];
    [dateComponentsZurich3 setMonth:3];
    [dateComponentsZurich3 setDay:25];
    [dateComponentsZurich3 setHour:1];
    NSDate *dateZurich3 = [self.calendar dateFromComponents:dateComponentsZurich3 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([dateZurich3 isEqualToDate:self.date3], @"Incorrect date");
    
    NSDateComponents *dateComponentsZurich4 = [[[NSDateComponents alloc] init] autorelease];
    [dateComponentsZurich4 setYear:2012];
    [dateComponentsZurich4 setMonth:3];
    [dateComponentsZurich4 setDay:25];
    [dateComponentsZurich4 setHour:3];
    NSDate *dateZurich4 = [self.calendar dateFromComponents:dateComponentsZurich4 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([dateZurich4 isEqualToDate:self.date4], @"Incorrect date");
    
    NSDateComponents *dateComponentsZurich5 = [[[NSDateComponents alloc] init] autorelease];
    [dateComponentsZurich5 setYear:2012];
    [dateComponentsZurich5 setMonth:3];
    [dateComponentsZurich5 setDay:26];
    [dateComponentsZurich5 setHour:5];
    NSDate *dateZurich5 = [self.calendar dateFromComponents:dateComponentsZurich5 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([dateZurich5 isEqualToDate:self.date5], @"Incorrect date");
    
    NSDateComponents *dateComponentsTahiti1 = [[[NSDateComponents alloc] init] autorelease];
    [dateComponentsTahiti1 setYear:2011];
    [dateComponentsTahiti1 setMonth:12];
    [dateComponentsTahiti1 setDay:31];
    [dateComponentsTahiti1 setHour:21];
    [dateComponentsTahiti1 setMinute:23];
    NSDate *dateTahiti1 = [self.calendar dateFromComponents:dateComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([dateTahiti1 isEqualToDate:self.date1], @"Incorrect date");
    
    NSDateComponents *dateComponentsTahiti2 = [[[NSDateComponents alloc] init] autorelease];
    [dateComponentsTahiti2 setYear:2012];
    [dateComponentsTahiti2 setMonth:2];
    [dateComponentsTahiti2 setDay:29];
    [dateComponentsTahiti2 setHour:19];
    [dateComponentsTahiti2 setMinute:12];
    NSDate *dateTahiti2 = [self.calendar dateFromComponents:dateComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([dateTahiti2 isEqualToDate:self.date2], @"Incorrect date");
    
    NSDateComponents *dateComponentsTahiti3 = [[[NSDateComponents alloc] init] autorelease];
    [dateComponentsTahiti3 setYear:2012];
    [dateComponentsTahiti3 setMonth:3];
    [dateComponentsTahiti3 setDay:24];
    [dateComponentsTahiti3 setHour:14];
    NSDate *dateTahiti3 = [self.calendar dateFromComponents:dateComponentsTahiti3 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([dateTahiti3 isEqualToDate:self.date3], @"Incorrect date");
    
    NSDateComponents *dateComponentsTahiti4 = [[[NSDateComponents alloc] init] autorelease];
    [dateComponentsTahiti4 setYear:2012];
    [dateComponentsTahiti4 setMonth:3];
    [dateComponentsTahiti4 setDay:24];
    [dateComponentsTahiti4 setHour:15];
    NSDate *dateTahiti4 = [self.calendar dateFromComponents:dateComponentsTahiti4 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([dateTahiti4 isEqualToDate:self.date4], @"Incorrect date");
    
    NSDateComponents *dateComponentsTahiti5 = [[[NSDateComponents alloc] init] autorelease];
    [dateComponentsTahiti5 setYear:2012];
    [dateComponentsTahiti5 setMonth:3];
    [dateComponentsTahiti5 setDay:25];
    [dateComponentsTahiti5 setHour:17];
    NSDate *dateTahiti5 = [self.calendar dateFromComponents:dateComponentsTahiti5 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([dateTahiti5 isEqualToDate:self.date5], @"Incorrect date");
}

- (void)testComponentsFromDateInTimeZone
{
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    // iOS 4 and above only
    // TODO: When iOS 4 and above required: Can use NSTimeZoneCalendarUnit and remove respondsToSelector test
    unitFlags |= NSTimeZoneCalendarUnit;
    
    NSDateComponents *dateComponentsZurich1 = [self.calendar components:unitFlags fromDate:self.date1 inTimeZone:self.timeZoneZurich];
    GHAssertEquals([dateComponentsZurich1 year], 2012, @"Incorrect year");
    GHAssertEquals([dateComponentsZurich1 month], 1, @"Incorrect month");
    GHAssertEquals([dateComponentsZurich1 day], 1, @"Incorrect day");
    GHAssertEquals([dateComponentsZurich1 hour], 8, @"Incorrect hour");
    GHAssertEquals([dateComponentsZurich1 minute], 23, @"Incorrect minute");
    // TODO: When iOS 4 and above required: Can remove respondsToSelector test
    if ([dateComponentsZurich1 respondsToSelector:@selector(timeZone)]) {       // iOS 4 and above
        NSTimeZone *componentsTimeZone = [dateComponentsZurich1 performSelector:@selector(timeZone)];
        GHAssertEqualStrings([componentsTimeZone name], [self.timeZoneZurich name], @"Incorrect time zone");
    }
    
    unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    NSDateComponents *dateComponentsZurich2 = [self.calendar components:unitFlags fromDate:self.date2 inTimeZone:self.timeZoneZurich];
    GHAssertEquals([dateComponentsZurich2 year], 2012, @"Incorrect year");
    GHAssertEquals([dateComponentsZurich2 month], 3, @"Incorrect month");
    GHAssertEquals([dateComponentsZurich2 day], 1, @"Incorrect day");
    GHAssertEquals([dateComponentsZurich2 hour], 6, @"Incorrect hour");
    GHAssertEquals([dateComponentsZurich2 minute], 12, @"Incorrect minute");
    // TODO: When iOS 4 and above required: Can remove respondsToSelector test
    if ([dateComponentsZurich2 respondsToSelector:@selector(timeZone)]) {       // iOS 4 and above
        NSTimeZone *componentsTimeZone = [dateComponentsZurich2 performSelector:@selector(timeZone)];
        GHAssertNil(componentsTimeZone, @"Incorrect time zone");
    }
    
    NSDateComponents *dateComponentsZurich3 = [self.calendar components:unitFlags fromDate:self.date3 inTimeZone:self.timeZoneZurich];
    GHAssertEquals([dateComponentsZurich3 year], 2012, @"Incorrect year");
    GHAssertEquals([dateComponentsZurich3 month], 3, @"Incorrect month");
    GHAssertEquals([dateComponentsZurich3 day], 25, @"Incorrect day");
    
    NSDateComponents *dateComponentsZurich4 = [self.calendar components:unitFlags fromDate:self.date4 inTimeZone:self.timeZoneZurich];
    GHAssertEquals([dateComponentsZurich4 year], 2012, @"Incorrect year");
    GHAssertEquals([dateComponentsZurich4 month], 3, @"Incorrect month");
    GHAssertEquals([dateComponentsZurich4 day], 25, @"Incorrect day");
    GHAssertEquals([dateComponentsZurich4 hour], 3, @"Incorrect hour");
    
    NSDateComponents *dateComponentsZurich5 = [self.calendar components:unitFlags fromDate:self.date5 inTimeZone:self.timeZoneZurich];
    GHAssertEquals([dateComponentsZurich5 year], 2012, @"Incorrect year");
    GHAssertEquals([dateComponentsZurich5 month], 3, @"Incorrect month");
    GHAssertEquals([dateComponentsZurich5 day], 26, @"Incorrect day");
    GHAssertEquals([dateComponentsZurich5 hour], 5, @"Incorrect hour");

    NSDateComponents *dateComponentsTahiti1 = [self.calendar components:unitFlags fromDate:self.date1 inTimeZone:self.timeZoneTahiti];
    GHAssertEquals([dateComponentsTahiti1 year], 2011, @"Incorrect year");
    GHAssertEquals([dateComponentsTahiti1 month], 12, @"Incorrect month");
    GHAssertEquals([dateComponentsTahiti1 day], 31, @"Incorrect day");
    GHAssertEquals([dateComponentsTahiti1 hour], 21, @"Incorrect hour");
    GHAssertEquals([dateComponentsTahiti1 minute], 23, @"Incorrect minute");
    
    NSDateComponents *dateComponentsTahiti2 = [self.calendar components:unitFlags fromDate:self.date2 inTimeZone:self.timeZoneTahiti];
    GHAssertEquals([dateComponentsTahiti2 year], 2012, @"Incorrect year");
    GHAssertEquals([dateComponentsTahiti2 month], 2, @"Incorrect month");
    GHAssertEquals([dateComponentsTahiti2 day], 29, @"Incorrect day");
    GHAssertEquals([dateComponentsTahiti2 hour], 19, @"Incorrect hour");
    GHAssertEquals([dateComponentsTahiti2 minute], 12, @"Incorrect minute");
    
    NSDateComponents *dateComponentsTahiti3 = [self.calendar components:unitFlags fromDate:self.date3 inTimeZone:self.timeZoneTahiti];
    GHAssertEquals([dateComponentsTahiti3 year], 2012, @"Incorrect year");
    GHAssertEquals([dateComponentsTahiti3 month], 3, @"Incorrect month");
    GHAssertEquals([dateComponentsTahiti3 day], 24, @"Incorrect day");
    GHAssertEquals([dateComponentsTahiti3 hour], 14, @"Incorrect hour");
    
    NSDateComponents *dateComponentsTahiti4 = [self.calendar components:unitFlags fromDate:self.date4 inTimeZone:self.timeZoneTahiti];
    GHAssertEquals([dateComponentsTahiti4 year], 2012, @"Incorrect year");
    GHAssertEquals([dateComponentsTahiti4 month], 3, @"Incorrect month");
    GHAssertEquals([dateComponentsTahiti4 day], 24, @"Incorrect day");
    GHAssertEquals([dateComponentsTahiti4 hour], 15, @"Incorrect hour");
    
    NSDateComponents *dateComponentsTahiti5 = [self.calendar components:unitFlags fromDate:self.date5 inTimeZone:self.timeZoneTahiti];
    GHAssertEquals([dateComponentsTahiti5 year], 2012, @"Incorrect year");
    GHAssertEquals([dateComponentsTahiti5 month], 3, @"Incorrect month");
    GHAssertEquals([dateComponentsTahiti5 day], 25, @"Incorrect day");
    GHAssertEquals([dateComponentsTahiti5 hour], 17, @"Incorrect hour");
}

- (void)testNumberOfDaysInUnitContainingDateInTimeZone
{
    NSUInteger nbrDaysInMonthZurich1 = [self.calendar numberOfDaysInUnit:NSMonthCalendarUnit containingDate:self.date1 inTimeZone:self.timeZoneZurich];
    GHAssertEquals(nbrDaysInMonthZurich1, 31U, @"Incorrect days in month");
    
    NSUInteger nbrDaysInYearZurich1 = [self.calendar numberOfDaysInUnit:NSYearCalendarUnit containingDate:self.date1 inTimeZone:self.timeZoneZurich];
    GHAssertEquals(nbrDaysInYearZurich1, 366U, @"Incorrect days in year");
    
    NSUInteger nbrDaysInMonthZurich2 = [self.calendar numberOfDaysInUnit:NSMonthCalendarUnit containingDate:self.date2 inTimeZone:self.timeZoneZurich];
    GHAssertEquals(nbrDaysInMonthZurich2, 31U, @"Incorrect days in month");
    
    NSUInteger nbrDaysInYearZurich2 = [self.calendar numberOfDaysInUnit:NSYearCalendarUnit containingDate:self.date2 inTimeZone:self.timeZoneZurich];
    GHAssertEquals(nbrDaysInYearZurich2, 366U, @"Incorrect days in year");
    
    NSUInteger nbrDaysInMonthTahiti1 = [self.calendar numberOfDaysInUnit:NSMonthCalendarUnit containingDate:self.date1 inTimeZone:self.timeZoneTahiti];
    GHAssertEquals(nbrDaysInMonthTahiti1, 31U, @"Incorrect days in month");
    
    NSUInteger nbrDaysInYearTahiti1 = [self.calendar numberOfDaysInUnit:NSYearCalendarUnit containingDate:self.date1 inTimeZone:self.timeZoneTahiti];
    GHAssertEquals(nbrDaysInYearTahiti1, 365U, @"Incorrect days in year");
    
    NSUInteger nbrDaysInMonthTahiti2 = [self.calendar numberOfDaysInUnit:NSMonthCalendarUnit containingDate:self.date2 inTimeZone:self.timeZoneTahiti];
    GHAssertEquals(nbrDaysInMonthTahiti2, 29U, @"Incorrect days in month");
    
    NSUInteger nbrDaysInYearTahiti2 = [self.calendar numberOfDaysInUnit:NSYearCalendarUnit containingDate:self.date2 inTimeZone:self.timeZoneTahiti];
    GHAssertEquals(nbrDaysInYearTahiti2, 366U, @"Incorrect days in year");
}

- (void)testStartDateOfUnitContainingDateInTimeZone
{
    NSDate *startDateMonthZurich1 = [self.calendar startDateOfUnit:NSMonthCalendarUnit containingDate:self.date1 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedStartDateMonthComponentsZurich1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedStartDateMonthComponentsZurich1 setYear:2012];
    [expectedStartDateMonthComponentsZurich1 setMonth:1];
    [expectedStartDateMonthComponentsZurich1 setDay:1];
    NSDate *expectedStartDateMonthZurich1 = [self.calendar dateFromComponents:expectedStartDateMonthComponentsZurich1 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([startDateMonthZurich1 isEqualToDate:expectedStartDateMonthZurich1], @"Incorrect date");
    
    NSDate *startDateYearZurich1 = [self.calendar startDateOfUnit:NSYearCalendarUnit containingDate:self.date1 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedStartDateYearComponentsZurich1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedStartDateYearComponentsZurich1 setYear:2012];
    [expectedStartDateYearComponentsZurich1 setMonth:1];
    [expectedStartDateYearComponentsZurich1 setDay:1];
    NSDate *expectedStartDateYearZurich1 = [self.calendar dateFromComponents:expectedStartDateYearComponentsZurich1 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([startDateYearZurich1 isEqualToDate:expectedStartDateYearZurich1], @"Incorrect date");
    
    NSDate *startDateMonthZurich2 = [self.calendar startDateOfUnit:NSMonthCalendarUnit containingDate:self.date2 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedStartDateMonthComponentsZurich2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedStartDateMonthComponentsZurich2 setYear:2012];
    [expectedStartDateMonthComponentsZurich2 setMonth:3];
    [expectedStartDateMonthComponentsZurich2 setDay:1];
    NSDate *expectedStartDateMonthZurich2 = [self.calendar dateFromComponents:expectedStartDateMonthComponentsZurich2 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([startDateMonthZurich2 isEqualToDate:expectedStartDateMonthZurich2], @"Incorrect date");
    
    NSDate *startDateYearZurich2 = [self.calendar startDateOfUnit:NSYearCalendarUnit containingDate:self.date2 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedStartDateYearComponentsZurich2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedStartDateYearComponentsZurich2 setYear:2012];
    [expectedStartDateYearComponentsZurich2 setMonth:1];
    [expectedStartDateYearComponentsZurich2 setDay:1];
    NSDate *expectedStartDateYearZurich2 = [self.calendar dateFromComponents:expectedStartDateYearComponentsZurich2 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([startDateYearZurich2 isEqualToDate:expectedStartDateYearZurich2], @"Incorrect date");
    
    NSDate *startDateMonthTahiti1 = [self.calendar startDateOfUnit:NSMonthCalendarUnit containingDate:self.date1 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedStartDateMonthComponentsTahiti1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedStartDateMonthComponentsTahiti1 setYear:2011];
    [expectedStartDateMonthComponentsTahiti1 setMonth:12];
    [expectedStartDateMonthComponentsTahiti1 setDay:1];
    NSDate *expectedStartDateMonthTahiti1 = [self.calendar dateFromComponents:expectedStartDateMonthComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([startDateMonthTahiti1 isEqualToDate:expectedStartDateMonthTahiti1], @"Incorrect date");
    
    NSDate *startDateYearTahiti1 = [self.calendar startDateOfUnit:NSYearCalendarUnit containingDate:self.date1 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedStartDateYearComponentsTahiti1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedStartDateYearComponentsTahiti1 setYear:2011];
    [expectedStartDateYearComponentsTahiti1 setMonth:1];
    [expectedStartDateYearComponentsTahiti1 setDay:1];
    NSDate *expectedStartDateYearTahiti1 = [self.calendar dateFromComponents:expectedStartDateYearComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([startDateYearTahiti1 isEqualToDate:expectedStartDateYearTahiti1], @"Incorrect date");
    
    NSDate *startDateMonthTahiti2 = [self.calendar startDateOfUnit:NSMonthCalendarUnit containingDate:self.date2 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedStartDateMonthComponentsTahiti2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedStartDateMonthComponentsTahiti2 setYear:2012];
    [expectedStartDateMonthComponentsTahiti2 setMonth:2];
    [expectedStartDateMonthComponentsTahiti2 setDay:1];
    NSDate *expectedStartDateMonthTahiti2 = [self.calendar dateFromComponents:expectedStartDateMonthComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([startDateMonthTahiti2 isEqualToDate:expectedStartDateMonthTahiti2], @"Incorrect date");
    
    NSDate *startDateYearTahiti2 = [self.calendar startDateOfUnit:NSYearCalendarUnit containingDate:self.date2 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedStartDateYearComponentsTahiti2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedStartDateYearComponentsTahiti2 setYear:2012];
    [expectedStartDateYearComponentsTahiti2 setMonth:1];
    [expectedStartDateYearComponentsTahiti2 setDay:1];
    NSDate *expectedStartDateYearTahiti2 = [self.calendar dateFromComponents:expectedStartDateYearComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([startDateYearTahiti2 isEqualToDate:expectedStartDateYearTahiti2], @"Incorrect date");
}

- (void)testEndDateOfUnitContainingDateInTimeZone
{
    NSDate *endDateMonthZurich1 = [self.calendar endDateOfUnit:NSMonthCalendarUnit containingDate:self.date1 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedEndDateMonthComponentsZurich1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedEndDateMonthComponentsZurich1 setYear:2012];
    [expectedEndDateMonthComponentsZurich1 setMonth:2];
    [expectedEndDateMonthComponentsZurich1 setDay:1];
    NSDate *expectedEndDateMonthZurich1 = [self.calendar dateFromComponents:expectedEndDateMonthComponentsZurich1 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([endDateMonthZurich1 isEqualToDate:expectedEndDateMonthZurich1], @"Incorrect date");
    
    NSDate *endDateYearZurich1 = [self.calendar endDateOfUnit:NSYearCalendarUnit containingDate:self.date1 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedEndDateYearComponentsZurich1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedEndDateYearComponentsZurich1 setYear:2013];
    [expectedEndDateYearComponentsZurich1 setMonth:1];
    [expectedEndDateYearComponentsZurich1 setDay:1];
    NSDate *expectedEndDateYearZurich1 = [self.calendar dateFromComponents:expectedEndDateYearComponentsZurich1 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([endDateYearZurich1 isEqualToDate:expectedEndDateYearZurich1], @"Incorrect date");
    
    NSDate *endDateMonthZurich2 = [self.calendar endDateOfUnit:NSMonthCalendarUnit containingDate:self.date2 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedEndDateMonthComponentsZurich2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedEndDateMonthComponentsZurich2 setYear:2012];
    [expectedEndDateMonthComponentsZurich2 setMonth:4];
    [expectedEndDateMonthComponentsZurich2 setDay:1];
    NSDate *expectedEndDateMonthZurich2 = [self.calendar dateFromComponents:expectedEndDateMonthComponentsZurich2 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([endDateMonthZurich2 isEqualToDate:expectedEndDateMonthZurich2], @"Incorrect date");
    
    NSDate *endDateYearZurich2 = [self.calendar endDateOfUnit:NSYearCalendarUnit containingDate:self.date2 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedEndDateYearComponentsZurich2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedEndDateYearComponentsZurich2 setYear:2013];
    [expectedEndDateYearComponentsZurich2 setMonth:1];
    [expectedEndDateYearComponentsZurich2 setDay:1];
    NSDate *expectedEndDateYearZurich2 = [self.calendar dateFromComponents:expectedEndDateYearComponentsZurich2 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([endDateYearZurich2 isEqualToDate:expectedEndDateYearZurich2], @"Incorrect date");
    
    NSDate *endDateMonthTahiti1 = [self.calendar endDateOfUnit:NSMonthCalendarUnit containingDate:self.date1 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedEndDateMonthComponentsTahiti1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedEndDateMonthComponentsTahiti1 setYear:2012];
    [expectedEndDateMonthComponentsTahiti1 setMonth:1];
    [expectedEndDateMonthComponentsTahiti1 setDay:1];
    NSDate *expectedEndDateMonthTahiti1 = [self.calendar dateFromComponents:expectedEndDateMonthComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([endDateMonthTahiti1 isEqualToDate:expectedEndDateMonthTahiti1], @"Incorrect date");
    
    NSDate *endDateYearTahiti1 = [self.calendar endDateOfUnit:NSYearCalendarUnit containingDate:self.date1 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedEndDateYearComponentsTahiti1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedEndDateYearComponentsTahiti1 setYear:2012];
    [expectedEndDateYearComponentsTahiti1 setMonth:1];
    [expectedEndDateYearComponentsTahiti1 setDay:1];
    NSDate *expectedEndDateYearTahiti1 = [self.calendar dateFromComponents:expectedEndDateYearComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([endDateYearTahiti1 isEqualToDate:expectedEndDateYearTahiti1], @"Incorrect date");
    
    NSDate *endDateMonthTahiti2 = [self.calendar endDateOfUnit:NSMonthCalendarUnit containingDate:self.date2 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedEndDateMonthComponentsTahiti2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedEndDateMonthComponentsTahiti2 setYear:2012];
    [expectedEndDateMonthComponentsTahiti2 setMonth:3];
    [expectedEndDateMonthComponentsTahiti2 setDay:1];
    NSDate *expectedEndDateMonthTahiti2 = [self.calendar dateFromComponents:expectedEndDateMonthComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([endDateMonthTahiti2 isEqualToDate:expectedEndDateMonthTahiti2], @"Incorrect date");
    
    NSDate *endDateYearTahiti2 = [self.calendar endDateOfUnit:NSYearCalendarUnit containingDate:self.date2 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedEndDateYearComponentsTahiti2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedEndDateYearComponentsTahiti2 setYear:2013];
    [expectedEndDateYearComponentsTahiti2 setMonth:1];
    [expectedEndDateYearComponentsTahiti2 setDay:1];
    NSDate *expectedEndDateYearTahiti2 = [self.calendar dateFromComponents:expectedEndDateYearComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([endDateYearTahiti2 isEqualToDate:expectedEndDateYearTahiti2], @"Incorrect date");
}

- (void)testRangeOfUnitInUnitForDateInTimeZone
{
    // Days in a year are always in [1; 31], whatever the date
    NSRange rangeDayInYearZurich1 = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:self.date1 inTimeZone:self.timeZoneZurich];
    GHAssertTrue(NSEqualRanges(rangeDayInYearZurich1, NSMakeRange(1, 31)), @"Incorrect range");
    
    // Months in a year are always in [1; 12], whatever the date
    NSRange rangeMonthInYearZurich1 = [self.calendar rangeOfUnit:NSMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:self.date1 inTimeZone:self.timeZoneZurich];
    GHAssertTrue(NSEqualRanges(rangeMonthInYearZurich1, NSMakeRange(1, 12)), @"Incorrect range");
    
    // January 2012: 31 days
    NSRange rangeDayInMonthZurich1 = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.date1 inTimeZone:self.timeZoneZurich];
    GHAssertTrue(NSEqualRanges(rangeDayInMonthZurich1, NSMakeRange(1, 31)), @"Incorrect range");
    
    // March 2012: 31 days
    NSRange rangeDayInMonthZurich2 = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.date2 inTimeZone:self.timeZoneZurich];
    GHAssertTrue(NSEqualRanges(rangeDayInMonthZurich2, NSMakeRange(1, 31)), @"Incorrect range");
    
    // December 2011: 31 days
    NSRange rangeDayInMonthTahiti1 = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.date1 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue(NSEqualRanges(rangeDayInMonthTahiti1, NSMakeRange(1, 31)), @"Incorrect range");
    
    // February 2012: 29 days
    NSRange rangeDayInMonthTahiti2 = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.date2 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue(NSEqualRanges(rangeDayInMonthTahiti2, NSMakeRange(1, 29)), @"Incorrect range");    
}

- (void)testOrdinalityOfUnitInUnitForDateInTimeZone
{
    NSUInteger ordinalityDayInYearZurich1 = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:self.date1 inTimeZone:self.timeZoneZurich];
    GHAssertEquals(ordinalityDayInYearZurich1, 1U, @"Incorrect ordinality");
    
    NSUInteger ordinalityDayInYearZurich2 = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:self.date2 inTimeZone:self.timeZoneZurich];
    GHAssertEquals(ordinalityDayInYearZurich2, 61U, @"Incorrect ordinality");
    
    NSUInteger ordinalityDayInYearTahiti1 = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:self.date1 inTimeZone:self.timeZoneTahiti];
    GHAssertEquals(ordinalityDayInYearTahiti1, 365U, @"Incorrect ordinality");
    
    NSUInteger ordinalityDayInYearTahiti2 = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:self.date2 inTimeZone:self.timeZoneTahiti];
    GHAssertEquals(ordinalityDayInYearTahiti2, 60U, @"Incorrect ordinality");
    
    NSUInteger ordinalityMonthInYearZurich1 = [self.calendar ordinalityOfUnit:NSMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:self.date1 inTimeZone:self.timeZoneZurich];
    GHAssertEquals(ordinalityMonthInYearZurich1, 1U, @"Incorrect ordinality");

    NSUInteger ordinalityMonthInYearZurich2 = [self.calendar ordinalityOfUnit:NSMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:self.date2 inTimeZone:self.timeZoneZurich];
    GHAssertEquals(ordinalityMonthInYearZurich2, 3U, @"Incorrect ordinality");

    NSUInteger ordinalityMonthInYearTahiti1 = [self.calendar ordinalityOfUnit:NSMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:self.date1 inTimeZone:self.timeZoneTahiti];
    GHAssertEquals(ordinalityMonthInYearTahiti1, 12U, @"Incorrect ordinality");
    
    NSUInteger ordinalityMonthInYearTahiti2 = [self.calendar ordinalityOfUnit:NSMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:self.date2 inTimeZone:self.timeZoneTahiti];
    GHAssertEquals(ordinalityMonthInYearTahiti2, 2U, @"Incorrect ordinality");
    
    NSUInteger ordinalityDayInMonthZurich1 = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.date1 inTimeZone:self.timeZoneZurich];
    GHAssertEquals(ordinalityDayInMonthZurich1, 1U, @"Incorrect ordinality");
    
    NSUInteger ordinalityDayInMonthZurich2 = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.date2 inTimeZone:self.timeZoneZurich];
    GHAssertEquals(ordinalityDayInMonthZurich2, 1U, @"Incorrect ordinality");
    
    NSUInteger ordinalityDayInMonthTahiti1 = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.date1 inTimeZone:self.timeZoneTahiti];
    GHAssertEquals(ordinalityDayInMonthTahiti1, 31U, @"Incorrect ordinality");
    
    NSUInteger ordinalityDayInMonthTahiti2 = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.date2 inTimeZone:self.timeZoneTahiti];
    GHAssertEquals(ordinalityDayInMonthTahiti2, 29U, @"Incorrect ordinality");
}

- (void)testRangeOfUnitStartDateIntervalForDateInTimeZone
{
    NSTimeInterval intervalDayInMonthZurich1 = 0.;
    NSDate *startDateZurich1 = nil;
    [self.calendar rangeOfUnit:NSMonthCalendarUnit startDate:&startDateZurich1 interval:&intervalDayInMonthZurich1 forDate:self.date1 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedStartDateComponentsZurich1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedStartDateComponentsZurich1 setYear:2012];
    [expectedStartDateComponentsZurich1 setMonth:1];
    [expectedStartDateComponentsZurich1 setDay:1];
    NSDate *expectedStartDateZurich1 = [self.calendar dateFromComponents:expectedStartDateComponentsZurich1 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([startDateZurich1 isEqualToDate:expectedStartDateZurich1], @"Incorrect date");
    GHAssertEquals(round(intervalDayInMonthZurich1 / (24 * 60 * 60)), 31.,        // January 2012: 31 days
                   @"Incorrect time interval");
    
    NSTimeInterval intervalDayInMonthZurich2 = 0.;
    NSDate *startDateZurich2 = nil;
    [self.calendar rangeOfUnit:NSMonthCalendarUnit startDate:&startDateZurich2 interval:&intervalDayInMonthZurich2 forDate:self.date2 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedStartDateComponentsZurich2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedStartDateComponentsZurich2 setYear:2012];
    [expectedStartDateComponentsZurich2 setMonth:3];
    [expectedStartDateComponentsZurich2 setDay:1];
    NSDate *expectedStartDateZurich2 = [self.calendar dateFromComponents:expectedStartDateComponentsZurich2 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([startDateZurich2 isEqualToDate:expectedStartDateZurich2], @"Incorrect date");
    GHAssertEquals(round(intervalDayInMonthZurich2 / (24 * 60 * 60)), 31.,        // March 2012: 31 days
                   @"Incorrect time interval");
    
    NSTimeInterval intervalDayInMonthTahiti1 = 0.;
    NSDate *startDateTahiti1 = nil;
    [self.calendar rangeOfUnit:NSMonthCalendarUnit startDate:&startDateTahiti1 interval:&intervalDayInMonthTahiti1 forDate:self.date1 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedStartDateComponentsTahiti1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedStartDateComponentsTahiti1 setYear:2011];
    [expectedStartDateComponentsTahiti1 setMonth:12];
    [expectedStartDateComponentsTahiti1 setDay:1];
    NSDate *expectedStartDateTahiti1 = [self.calendar dateFromComponents:expectedStartDateComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([startDateTahiti1 isEqualToDate:expectedStartDateTahiti1], @"Incorrect date");
    GHAssertEquals(round(intervalDayInMonthTahiti1 / (24 * 60 * 60)), 31.,        // December 2011: 31 days
                   @"Incorrect time interval");
    
    NSTimeInterval intervalDayInMonthTahiti2 = 0.;
    NSDate *startDateTahiti2 = nil;
    [self.calendar rangeOfUnit:NSMonthCalendarUnit startDate:&startDateTahiti2 interval:&intervalDayInMonthTahiti2 forDate:self.date2 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedStartDateComponentsTahiti2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedStartDateComponentsTahiti2 setYear:2012];
    [expectedStartDateComponentsTahiti2 setMonth:2];
    [expectedStartDateComponentsTahiti2 setDay:1];
    NSDate *expectedStartDateTahiti2 = [self.calendar dateFromComponents:expectedStartDateComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([startDateTahiti2 isEqualToDate:expectedStartDateTahiti2], @"Incorrect date");
    GHAssertEquals(round(intervalDayInMonthTahiti2 / (24 * 60 * 60)), 29.,        // February 2012: 29 days
                   @"Incorrect time interval");
}

- (void)testDateByAddingComponentsToDateOptionsInTimeZone
{
    NSDateComponents *addedDateComponents = [[[NSDateComponents alloc] init] autorelease];
    [addedDateComponents setYear:2];
    [addedDateComponents setMonth:-1];
    [addedDateComponents setDay:6];
    [addedDateComponents setHour:2];
    [addedDateComponents setMinute:-20];
    
    NSDate *dateZurich1 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date1 options:0 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedDateComponentsZurich1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsZurich1 setYear:2013];
    [expectedDateComponentsZurich1 setMonth:12];
    [expectedDateComponentsZurich1 setDay:7];
    [expectedDateComponentsZurich1 setHour:10];
    [expectedDateComponentsZurich1 setMinute:3];
    NSDate *expectedDateZurich1 = [self.calendar dateFromComponents:expectedDateComponentsZurich1 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([dateZurich1 isEqualToDate:expectedDateZurich1], @"Date");
    
    NSDate *dateZurich2 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date2 options:0 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedDateComponentsZurich2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsZurich2 setYear:2014];
    [expectedDateComponentsZurich2 setMonth:2];
    [expectedDateComponentsZurich2 setDay:7];
    [expectedDateComponentsZurich2 setHour:7];
    [expectedDateComponentsZurich2 setMinute:52];
    NSDate *expectedDateZurich2 = [self.calendar dateFromComponents:expectedDateComponentsZurich2 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([dateZurich2 isEqualToDate:expectedDateZurich2], @"Date");
    
    NSDate *dateZurich3 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date3 options:0 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedDateComponentsZurich3 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsZurich3 setYear:2014];
    [expectedDateComponentsZurich3 setMonth:3];
    [expectedDateComponentsZurich3 setDay:3];
    [expectedDateComponentsZurich3 setHour:2];
    [expectedDateComponentsZurich3 setMinute:40];
    NSDate *expectedDateZurich3 = [self.calendar dateFromComponents:expectedDateComponentsZurich3 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([dateZurich3 isEqualToDate:expectedDateZurich3], @"Date");
    
    NSDate *dateZurich4 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date4 options:0 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedDateComponentsZurich4 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsZurich4 setYear:2014];
    [expectedDateComponentsZurich4 setMonth:3];
    [expectedDateComponentsZurich4 setDay:3];
    [expectedDateComponentsZurich4 setHour:4];
    [expectedDateComponentsZurich4 setMinute:40];
    NSDate *expectedDateZurich4 = [self.calendar dateFromComponents:expectedDateComponentsZurich4 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([dateZurich4 isEqualToDate:expectedDateZurich4], @"Date");
    
    NSDate *dateZurich5 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date5 options:0 inTimeZone:self.timeZoneZurich];
    NSDateComponents *expectedDateComponentsZurich5 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsZurich5 setYear:2014];
    [expectedDateComponentsZurich5 setMonth:3];
    [expectedDateComponentsZurich5 setDay:4];
    [expectedDateComponentsZurich5 setHour:6];
    [expectedDateComponentsZurich5 setMinute:40];
    NSDate *expectedDateZurich5 = [self.calendar dateFromComponents:expectedDateComponentsZurich5 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([dateZurich5 isEqualToDate:expectedDateZurich5], @"Date");
    
    NSDate *dateTahiti1 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date1 options:0 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedDateComponentsTahiti1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsTahiti1 setYear:2013];
    [expectedDateComponentsTahiti1 setMonth:12];
    [expectedDateComponentsTahiti1 setDay:6];
    [expectedDateComponentsTahiti1 setHour:23];
    [expectedDateComponentsTahiti1 setMinute:3];
    NSDate *expectedDateTahiti1 = [self.calendar dateFromComponents:expectedDateComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([dateTahiti1 isEqualToDate:expectedDateTahiti1], @"Date");
    
    NSDate *dateTahiti2 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date2 options:0 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedDateComponentsTahiti2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsTahiti2 setYear:2014];
    [expectedDateComponentsTahiti2 setMonth:2];
    [expectedDateComponentsTahiti2 setDay:3];
    [expectedDateComponentsTahiti2 setHour:20];
    [expectedDateComponentsTahiti2 setMinute:52];
    NSDate *expectedDateTahiti2 = [self.calendar dateFromComponents:expectedDateComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([dateTahiti2 isEqualToDate:expectedDateTahiti2], @"Date");
    
    NSDate *dateTahiti3 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date3 options:0 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedDateComponentsTahiti3 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsTahiti3 setYear:2014];
    [expectedDateComponentsTahiti3 setMonth:3];
    [expectedDateComponentsTahiti3 setDay:2];
    [expectedDateComponentsTahiti3 setHour:15];
    [expectedDateComponentsTahiti3 setMinute:40];
    NSDate *expectedDateTahiti3 = [self.calendar dateFromComponents:expectedDateComponentsTahiti3 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([dateTahiti3 isEqualToDate:expectedDateTahiti3], @"Date");
    
    NSDate *dateTahiti4 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date4 options:0 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedDateComponentsTahiti4 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsTahiti4 setYear:2014];
    [expectedDateComponentsTahiti4 setMonth:3];
    [expectedDateComponentsTahiti4 setDay:2];
    [expectedDateComponentsTahiti4 setHour:16];
    [expectedDateComponentsTahiti4 setMinute:40];
    NSDate *expectedDateTahiti4 = [self.calendar dateFromComponents:expectedDateComponentsTahiti4 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([dateTahiti4 isEqualToDate:expectedDateTahiti4], @"Date");
    
    NSDate *dateTahiti5 = [self.calendar dateByAddingComponents:addedDateComponents toDate:self.date5 options:0 inTimeZone:self.timeZoneTahiti];
    NSDateComponents *expectedDateComponentsTahiti5 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsTahiti5 setYear:2014];
    [expectedDateComponentsTahiti5 setMonth:3];
    [expectedDateComponentsTahiti5 setDay:3];
    [expectedDateComponentsTahiti5 setHour:18];
    [expectedDateComponentsTahiti5 setMinute:40];
    NSDate *expectedDateTahiti5 = [self.calendar dateFromComponents:expectedDateComponentsTahiti5 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([dateTahiti5 isEqualToDate:expectedDateTahiti5], @"Date");
}

- (void)testComponentsFromDateToDateOptionsInTimeZone
{
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    NSDateComponents *dateComponentsZurich43 = [self.calendar components:unitFlags fromDate:self.date3 toDate:self.date4 options:0 inTimeZone:self.timeZoneZurich];
    GHAssertEquals([dateComponentsZurich43 hour], 1, @"Hour");
    
    NSDateComponents *dateComponentsZurich53 = [self.calendar components:unitFlags fromDate:self.date3 toDate:self.date5 options:0 inTimeZone:self.timeZoneZurich];
    GHAssertEquals([dateComponentsZurich53 day], 1, @"Day");
    GHAssertEquals([dateComponentsZurich53 hour], 4, @"Hour");
    
    NSDateComponents *dateComponentsZurich54 = [self.calendar components:unitFlags fromDate:self.date4 toDate:self.date5 options:0 inTimeZone:self.timeZoneZurich];
    GHAssertEquals([dateComponentsZurich54 day], 1, @"Day");
    GHAssertEquals([dateComponentsZurich54 hour], 2, @"Hour");
}

- (void)testDateAtNoonTheSameDayAsDate
{
    NSDateComponents *expectedDateComponents1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponents1 setYear:2012];
    [expectedDateComponents1 setMonth:1];
    [expectedDateComponents1 setDay:1];
    [expectedDateComponents1 setHour:12];
    NSDate *expectedDate1 = [self.calendar dateFromComponents:expectedDateComponents1];
    NSDate *date1 = [self.calendar dateAtNoonTheSameDayAsDate:self.date1];
    GHAssertTrue([date1 isEqualToDate:expectedDate1], @"Date");
    
    NSDateComponents *expectedDateComponents2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponents2 setYear:2012];
    [expectedDateComponents2 setMonth:3];
    [expectedDateComponents2 setDay:1];
    [expectedDateComponents2 setHour:12];
    NSDate *expectedDate2 = [self.calendar dateFromComponents:expectedDateComponents2];
    NSDate *date2 = [self.calendar dateAtNoonTheSameDayAsDate:self.date2];
    GHAssertTrue([date2 isEqualToDate:expectedDate2], @"Date");
}

- (void)testDateAtNoonTheSameDayAsDateInTimeZone
{
    NSDateComponents *expectedDateComponentsZurich1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsZurich1 setYear:2012];
    [expectedDateComponentsZurich1 setMonth:1];
    [expectedDateComponentsZurich1 setDay:1];
    [expectedDateComponentsZurich1 setHour:12];
    NSDate *expectedDateZurich1 = [self.calendar dateFromComponents:expectedDateComponentsZurich1 inTimeZone:self.timeZoneZurich];
    NSDate *dateZurich1 = [self.calendar dateAtNoonTheSameDayAsDate:self.date1 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([dateZurich1 isEqualToDate:expectedDateZurich1], @"Date");
    
    NSDateComponents *expectedDateComponentsZurich2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsZurich2 setYear:2012];
    [expectedDateComponentsZurich2 setMonth:3];
    [expectedDateComponentsZurich2 setDay:1];
    [expectedDateComponentsZurich2 setHour:12];
    NSDate *expectedDateZurich2 = [self.calendar dateFromComponents:expectedDateComponentsZurich2 inTimeZone:self.timeZoneZurich];
    NSDate *dateZurich2 = [self.calendar dateAtNoonTheSameDayAsDate:self.date2 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([dateZurich2 isEqualToDate:expectedDateZurich2], @"Date");
    
    NSDateComponents *expectedDateComponentsTahiti1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsTahiti1 setYear:2011];
    [expectedDateComponentsTahiti1 setMonth:12];
    [expectedDateComponentsTahiti1 setDay:31];
    [expectedDateComponentsTahiti1 setHour:12];
    NSDate *expectedDateTahiti1 = [self.calendar dateFromComponents:expectedDateComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    NSDate *dateTahiti1 = [self.calendar dateAtNoonTheSameDayAsDate:self.date1 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([dateTahiti1 isEqualToDate:expectedDateTahiti1], @"Date");
    
    NSDateComponents *expectedDateComponentsTahiti2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsTahiti2 setYear:2012];
    [expectedDateComponentsTahiti2 setMonth:2];
    [expectedDateComponentsTahiti2 setDay:29];
    [expectedDateComponentsTahiti2 setHour:12];
    NSDate *expectedDateTahiti2 = [self.calendar dateFromComponents:expectedDateComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    NSDate *dateTahiti2 = [self.calendar dateAtNoonTheSameDayAsDate:self.date2 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([dateTahiti2 isEqualToDate:expectedDateTahiti2], @"Date");
}

- (void)testDateAtMidnightTheSameDayAsDate
{
    NSDateComponents *expectedDateComponents1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponents1 setYear:2012];
    [expectedDateComponents1 setMonth:1];
    [expectedDateComponents1 setDay:1];
    NSDate *expectedDate1 = [self.calendar dateFromComponents:expectedDateComponents1];
    NSDate *date1 = [self.calendar dateAtMidnightTheSameDayAsDate:self.date1];
    GHAssertTrue([date1 isEqualToDate:expectedDate1], @"Date");
    
    NSDateComponents *expectedDateComponents2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponents2 setYear:2012];
    [expectedDateComponents2 setMonth:3];
    [expectedDateComponents2 setDay:1];
    NSDate *expectedDate2 = [self.calendar dateFromComponents:expectedDateComponents2];
    NSDate *date2 = [self.calendar dateAtMidnightTheSameDayAsDate:self.date2];
    GHAssertTrue([date2 isEqualToDate:expectedDate2], @"Date");
}

- (void)testDateAtMidnightTheSameDayAsDateInTimeZone
{
    NSDateComponents *expectedDateComponentsZurich1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsZurich1 setYear:2012];
    [expectedDateComponentsZurich1 setMonth:1];
    [expectedDateComponentsZurich1 setDay:1];
    NSDate *expectedDateZurich1 = [self.calendar dateFromComponents:expectedDateComponentsZurich1 inTimeZone:self.timeZoneZurich];
    NSDate *dateZurich1 = [self.calendar dateAtMidnightTheSameDayAsDate:self.date1 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([dateZurich1 isEqualToDate:expectedDateZurich1], @"Date");
    
    NSDateComponents *expectedDateComponentsZurich2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsZurich2 setYear:2012];
    [expectedDateComponentsZurich2 setMonth:3];
    [expectedDateComponentsZurich2 setDay:1];
    NSDate *expectedDateZurich2 = [self.calendar dateFromComponents:expectedDateComponentsZurich2 inTimeZone:self.timeZoneZurich];
    NSDate *dateZurich2 = [self.calendar dateAtMidnightTheSameDayAsDate:self.date2 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([dateZurich2 isEqualToDate:expectedDateZurich2], @"Date");
    
    NSDateComponents *expectedDateComponentsTahiti1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsTahiti1 setYear:2011];
    [expectedDateComponentsTahiti1 setMonth:12];
    [expectedDateComponentsTahiti1 setDay:31];
    NSDate *expectedDateTahiti1 = [self.calendar dateFromComponents:expectedDateComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    NSDate *dateTahiti1 = [self.calendar dateAtMidnightTheSameDayAsDate:self.date1 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([dateTahiti1 isEqualToDate:expectedDateTahiti1], @"Date");
    
    NSDateComponents *expectedDateComponentsTahiti2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsTahiti2 setYear:2012];
    [expectedDateComponentsTahiti2 setMonth:2];
    [expectedDateComponentsTahiti2 setDay:29];
    NSDate *expectedDateTahiti2 = [self.calendar dateFromComponents:expectedDateComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    NSDate *dateTahiti2 = [self.calendar dateAtMidnightTheSameDayAsDate:self.date2 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([dateTahiti2 isEqualToDate:expectedDateTahiti2], @"Date");
}

- (void)testDateAtHourMinuteSecondTheSameDayAsDate
{
    NSDateComponents *expectedDateComponents1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponents1 setYear:2012];
    [expectedDateComponents1 setMonth:1];
    [expectedDateComponents1 setDay:1];
    [expectedDateComponents1 setHour:14];
    [expectedDateComponents1 setMinute:27];
    [expectedDateComponents1 setSecond:36];
    NSDate *expectedDate1 = [self.calendar dateFromComponents:expectedDateComponents1];
    NSDate *date1 = [self.calendar dateAtHour:14 minute:27 second:36 theSameDayAsDate:self.date1];
    GHAssertTrue([date1 isEqualToDate:expectedDate1], @"Date");
    
    NSDateComponents *expectedDateComponents2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponents2 setYear:2012];
    [expectedDateComponents2 setMonth:3];
    [expectedDateComponents2 setDay:1];
    [expectedDateComponents2 setHour:14];
    [expectedDateComponents2 setMinute:27];
    [expectedDateComponents2 setSecond:36];
    NSDate *expectedDate2 = [self.calendar dateFromComponents:expectedDateComponents2];
    NSDate *date2 = [self.calendar dateAtHour:14 minute:27 second:36 theSameDayAsDate:self.date2];
    GHAssertTrue([date2 isEqualToDate:expectedDate2], @"Date");
}

- (void)testDateAtHourMinuteSecondTheSameDayAsDateInTimeZone
{
    NSDateComponents *expectedDateComponentsZurich1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsZurich1 setYear:2012];
    [expectedDateComponentsZurich1 setMonth:1];
    [expectedDateComponentsZurich1 setDay:1];
    [expectedDateComponentsZurich1 setHour:14];
    [expectedDateComponentsZurich1 setMinute:27];
    [expectedDateComponentsZurich1 setSecond:36];
    NSDate *expectedDateZurich1 = [self.calendar dateFromComponents:expectedDateComponentsZurich1 inTimeZone:self.timeZoneZurich];
    NSDate *dateZurich1 = [self.calendar dateAtHour:14 minute:27 second:36 theSameDayAsDate:self.date1 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([dateZurich1 isEqualToDate:expectedDateZurich1], @"Date");
    
    NSDateComponents *expectedDateComponentsZurich2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsZurich2 setYear:2012];
    [expectedDateComponentsZurich2 setMonth:3];
    [expectedDateComponentsZurich2 setDay:1];
    [expectedDateComponentsZurich2 setHour:14];
    [expectedDateComponentsZurich2 setMinute:27];
    [expectedDateComponentsZurich2 setSecond:36];
    NSDate *expectedDateZurich2 = [self.calendar dateFromComponents:expectedDateComponentsZurich2 inTimeZone:self.timeZoneZurich];
    NSDate *dateZurich2 = [self.calendar dateAtHour:14 minute:27 second:36 theSameDayAsDate:self.date2 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([dateZurich2 isEqualToDate:expectedDateZurich2], @"Date");
    
    NSDateComponents *expectedDateComponentsTahiti1 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsTahiti1 setYear:2011];
    [expectedDateComponentsTahiti1 setMonth:12];
    [expectedDateComponentsTahiti1 setDay:31];
    [expectedDateComponentsTahiti1 setHour:14];
    [expectedDateComponentsTahiti1 setMinute:27];
    [expectedDateComponentsTahiti1 setSecond:36];
    NSDate *expectedDateTahiti1 = [self.calendar dateFromComponents:expectedDateComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    NSDate *dateTahiti1 = [self.calendar dateAtHour:14 minute:27 second:36 theSameDayAsDate:self.date1 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([dateTahiti1 isEqualToDate:expectedDateTahiti1], @"Date");
    
    NSDateComponents *expectedDateComponentsTahiti2 = [[[NSDateComponents alloc] init] autorelease];
    [expectedDateComponentsTahiti2 setYear:2012];
    [expectedDateComponentsTahiti2 setMonth:2];
    [expectedDateComponentsTahiti2 setDay:29];
    [expectedDateComponentsTahiti2 setHour:14];
    [expectedDateComponentsTahiti2 setMinute:27];
    [expectedDateComponentsTahiti2 setSecond:36];
    NSDate *expectedDateTahiti2 = [self.calendar dateFromComponents:expectedDateComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    NSDate *dateTahiti2 = [self.calendar dateAtHour:14 minute:27 second:36 theSameDayAsDate:self.date2 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([dateTahiti2 isEqualToDate:expectedDateTahiti2], @"Date");
}

- (void)testCompareDaysBetweenDateAndDate
{
    NSDateComponents *otherDateComponents1 = [[[NSDateComponents alloc] init] autorelease];
    [otherDateComponents1 setYear:2012];
    [otherDateComponents1 setMonth:1];
    [otherDateComponents1 setDay:1];
    [otherDateComponents1 setHour:15];
    NSDate *otherDate1 = [self.calendar dateFromComponents:otherDateComponents1];
    GHAssertTrue([self.calendar compareDaysBetweenDate:self.date1 andDate:otherDate1] == NSOrderedSame, @"Day");
    
    NSDateComponents *otherDateComponents2 = [[[NSDateComponents alloc] init] autorelease];
    [otherDateComponents2 setYear:2012];
    [otherDateComponents2 setMonth:3];
    [otherDateComponents2 setDay:1];
    [otherDateComponents2 setHour:15];
    NSDate *otherDate2 = [self.calendar dateFromComponents:otherDateComponents2];
    GHAssertTrue([self.calendar compareDaysBetweenDate:self.date2 andDate:otherDate2] == NSOrderedSame, @"Day");
}

- (void)testCompareDaysBetweenDateAndDateInTimeZone
{
    NSDateComponents *otherDateComponentsZurich1 = [[[NSDateComponents alloc] init] autorelease];
    [otherDateComponentsZurich1 setYear:2012];
    [otherDateComponentsZurich1 setMonth:1];
    [otherDateComponentsZurich1 setDay:1];
    [otherDateComponentsZurich1 setHour:15];
    NSDate *otherDateZurich1 = [self.calendar dateFromComponents:otherDateComponentsZurich1 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([self.calendar compareDaysBetweenDate:self.date1 andDate:otherDateZurich1 inTimeZone:self.timeZoneZurich] == NSOrderedSame, @"Day");
    
    NSDateComponents *otherDateComponentsZurich2 = [[[NSDateComponents alloc] init] autorelease];
    [otherDateComponentsZurich2 setYear:2012];
    [otherDateComponentsZurich2 setMonth:3];
    [otherDateComponentsZurich2 setDay:1];
    [otherDateComponentsZurich2 setHour:15];
    NSDate *otherDateZurich2 = [self.calendar dateFromComponents:otherDateComponentsZurich2 inTimeZone:self.timeZoneZurich];
    GHAssertTrue([self.calendar compareDaysBetweenDate:self.date2 andDate:otherDateZurich2 inTimeZone:self.timeZoneZurich] == NSOrderedSame, @"Day");
    
    NSDateComponents *otherDateComponentsTahiti1 = [[[NSDateComponents alloc] init] autorelease];
    [otherDateComponentsTahiti1 setYear:2011];
    [otherDateComponentsTahiti1 setMonth:12];
    [otherDateComponentsTahiti1 setDay:31];
    [otherDateComponentsTahiti1 setHour:15];
    NSDate *otherDateTahiti1 = [self.calendar dateFromComponents:otherDateComponentsTahiti1 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([self.calendar compareDaysBetweenDate:self.date1 andDate:otherDateTahiti1 inTimeZone:self.timeZoneTahiti] == NSOrderedSame, @"Day");
    
    NSDateComponents *otherDateComponentsTahiti2 = [[[NSDateComponents alloc] init] autorelease];
    [otherDateComponentsTahiti2 setYear:2012];
    [otherDateComponentsTahiti2 setMonth:2];
    [otherDateComponentsTahiti2 setDay:29];
    [otherDateComponentsTahiti2 setHour:15];
    NSDate *otherDateTahiti2 = [self.calendar dateFromComponents:otherDateComponentsTahiti2 inTimeZone:self.timeZoneTahiti];
    GHAssertTrue([self.calendar compareDaysBetweenDate:self.date2 andDate:otherDateTahiti2 inTimeZone:self.timeZoneTahiti] == NSOrderedSame, @"Day");
}

@end
