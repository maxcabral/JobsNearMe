//
//  JmeUserSkill.h
//  JobsNearMe
//
//  Created by Maxwell Cabral on 6/1/13.
//  Copyright (c) 2013 mCab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JmeUser;

@interface JmeUserSkill : NSManagedObject

@property (nonatomic, retain) NSString * skillName;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * skillId;
@property (nonatomic, retain) JmeUser *user;

@end
