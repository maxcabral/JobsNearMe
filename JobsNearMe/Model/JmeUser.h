//
//  JmeUser.h
//  JobsNearMe
//
//  Created by Maxwell Cabral on 6/1/13.
//  Copyright (c) 2013 mCab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JmeUserSearch;

@interface JmeUser : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * email;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSManagedObject *userSkills;
@property (nonatomic, retain) JmeUserSearch *userSearches;

@end
