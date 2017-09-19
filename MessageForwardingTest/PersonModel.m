//
//  PersonModel.m
//  
//
//  Created by Yanglaoshi on 17/9/18.
//
//

#import "PersonModel.h"
#import "CompanyModel.h"
#import <objc/runtime.h>

@interface PersonModel()

@property(nonatomic, strong)CompanyModel *companyModel;

@end

@implementation PersonModel

@dynamic name;


- (id)init{
    
    self = [super init];
    if (self) {
        _companyModel = [[CompanyModel alloc] init];
    }
    
    return self;
}

#pragma mark --- 快速消息转发
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSString *selStr = NSStringFromSelector(sel);
    if ([selStr isEqualToString:@"name"]) {
        class_addMethod(self, sel, (IMP)nameGetter, "@@:");//添加name的get方法
        return YES;
    }
    if ([selStr isEqualToString:@"setName:"]) {
        class_addMethod(self, sel, (IMP)nameSetter, "v@:@");//添加name的set方法
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

void nameSetter(id self, SEL cmd, id value){
    NSString *fullName = value;
    NSArray *nameArray = [fullName componentsSeparatedByString:@" "];
    PersonModel *model = (PersonModel *)self;
    model.firstName = nameArray[0];
    model.lastName  = nameArray[1];
}

id nameGetter(id self, SEL cmd){
    PersonModel *model = (PersonModel *)self;
    NSMutableString *name = [[NSMutableString alloc] init];
    if (nil != model.firstName) {
        [name appendString:model.firstName];
        [name appendString:@" "];
    }
    if (nil != model.lastName) {
        [name appendString:model.lastName];
    }
    return name;
}

#pragma mark --- 标准消息转发
//------------------>>>>>>forwardingTargetForSelector
- (id)forwardingTargetForSelector:(SEL)aSelector{
    NSString *selStr = NSStringFromSelector(aSelector);
    if ([selStr isEqualToString:@"companyName"]) {
        return self.companyModel;// 调用CompanyModel类中的方法
    }else{
        return [super forwardingTargetForSelector:aSelector];//在父类中去找
    }
}

//------------------>>>>>>methodSignatureForSelector->>>>>forwardInvocation
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = nil;
    NSString *selStr = NSStringFromSelector(aSelector);
    if ([selStr isEqualToString:@"deptName"]) {
        //此处返回的sig是方法forwardInvocation的参数anInvocation中的methodSignature
        sig = [self.companyModel methodSignatureForSelector:@selector(deptName:)];//调用CompanyModel类中的方法
    }else{
        sig = [super methodSignatureForSelector:aSelector];
    }
    return sig;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    NSString *selStr = NSStringFromSelector(anInvocation.selector);//方法名映射成字符串
    if ([selStr isEqualToString:@"deptName"]) {
        [anInvocation setTarget:self.companyModel];
        [anInvocation setSelector:@selector(deptName:)];
        BOOL hasCompanyName = YES;
        //注意：设置参数的索引时不能从0开始，因为0已经被self占用，1已经被_cmd占用  所以从2开始
        [anInvocation setArgument:&hasCompanyName atIndex:2];
        [anInvocation retainArguments];//因为NSInvocation不会自己去retain参数，因此需要用户去retain，当然本例中其实没必要
        [anInvocation invoke];//执行方法
    }else{
        [super forwardInvocation:anInvocation];
    }
}
/////////////如果连forwardInvocation都找不到该方法，那么程序直接挂壁。。。。。。。。抛出找不到该方法
@end
