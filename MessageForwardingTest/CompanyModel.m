//
//  CompanyModel.m
//  
//
//  Created by Yanglaoshi on 17/9/18.
//
//

#import "CompanyModel.h"

@implementation CompanyModel

- (NSString *)companyName{
    
    return @"测试公司";
}

- (NSString *)deptName:(BOOL)isWithCompanyName{
    if (isWithCompanyName) {
        return @"测试公司研发部门";
    }else{
        return @"研发部门";
    }
}

@end
