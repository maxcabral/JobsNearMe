//
//  JmeUserSearch.h
//  JobsNearMe
//
//  Created by Maxwell Cabral on 6/1/13.
//  Copyright (c) 2013 mCab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JmeUser;

@interface JmeUserSearch : NSManagedObject

@property (nonatomic, retain) NSNumber * searchId;
@property (nonatomic, retain) NSString * search;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * lattitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) JmeUser *user;

@end
