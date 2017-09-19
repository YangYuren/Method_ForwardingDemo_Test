//
//  PersonModel.h
//  
//
//  Created by Yanglaoshi on 17/9/18.
//
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject

@property(nonatomic, copy)NSString *firstName;

@property(nonatomic, copy)NSString *lastName;

@property(nonatomic, copy)NSString *name;

- (NSString *)companyName;

- (NSString *)deptName;

@end
