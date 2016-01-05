//
//  Json2CalssTransformer.m
//  Json2ObjectiveC
//
//  Created by Netease on 16/1/5.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "Json2CalssTransformer.h"

@implementation Json2CalssTransformer
-(instancetype)init{
    self = [super init];
    if (self != nil) {
        self.classDict = [[NSMutableDictionary alloc] init];
        self.classes = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)transformData:(NSData *)data{
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    [self createClass:jsonObject name:@"RootObject"];
    [self printResult];
    
}
-(void)printResult{
    NSString *interfaceResult = @"#import <Foundation/Foundation.h>\n#import \"Mantle.h\"";
    NSString *implementResult = @"#import <Foundation/Foundation.h>\n#import \"Mantle.h\"";
    for (ClassType *c in self.classes) {
        interfaceResult = [interfaceResult stringByAppendingString:[c parseClassInterface]];
        implementResult = [implementResult stringByAppendingString:[c parseClassImplementation]];
    }
    
    NSLog(@"%@ \n\n\n %@", interfaceResult, implementResult);
}



#pragma mark - 私有方法
//创建新类型
-(NSString *)createClass:(NSDictionary *)dict name:(NSString *)name{
    ClassType *newClass = [[ClassType alloc] initWithName:name];
    
    //遍历所有属性
    for (NSString *key in dict.allKeys) {
        Property *property;
        id value = dict[key];
        NSString *propertyClass = key;
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            propertyClass = [key stringByAppendingString:@"Class"];
            [self createClass:value name:propertyClass];
            property = [[Property alloc] initWithName:key type:DICTIONARY classType:propertyClass];
        }
        else if([value isKindOfClass:[NSArray class]]){
            propertyClass = [[key stringByAppendingString:@"List"] stringByAppendingString:@"Class"];
            property = [[Property alloc] initWithName:key type:ARRAY classType:propertyClass];
            if ([value count] > 0) {
                for (id obj in value) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        [self createClass:obj name:propertyClass];
                    }
                }
            }
            else
            {
                [self createClass:nil name:propertyClass];
            }
        }
        else
        {
            if([value isKindOfClass:[NSString class]])
            {
                property = [[Property alloc] initWithName:key type:STRING classType:nil];
            }
            if ([value isKindOfClass:[NSNumber class]]) {
                property = [[Property alloc] initWithName:key type:NUMBER classType:nil];
            }
        }
        [newClass addProperty:property];
    }
    [self handleClassCopy:newClass className:name];
    return name;
}
-(void)handleClassCopy:(ClassType *)class className:(NSString *)name{
    if (![self.classDict.allKeys containsObject:name]) {
        [self addClassToCache:class];
        return;
    }
    
    ClassType *oldClass = self.classDict[name];
    
    for (NSString *key in class.propertyDic.allKeys) {
        if ([oldClass.propertyDic objectForKey:key] == nil) {
            [oldClass addProperty:class.propertyDic[key]];
        }
    }
}
-(void)addClassToCache:(ClassType *)class{
    [self.classes addObject:class];
    [self.classDict setObject:class forKey:class.name];
}
@end
