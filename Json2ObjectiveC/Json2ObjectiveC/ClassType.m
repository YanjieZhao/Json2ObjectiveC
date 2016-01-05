//
//  ClassType.m
//  Json2ObjectiveC
//
//  Created by Netease on 16/1/5.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "ClassType.h"

@implementation ClassType
-(instancetype)initWithName:(NSString *)name{
    self = [super init];
    if (self != nil) {
        self.name = name;
        self.properties = [[NSMutableArray alloc] init];
        self.propertyDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}
-(void)addProperty:(Property *)property{
    if (property == nil) {
        return;
    }
    
    [self.properties addObject:property];
    [self.propertyDic setObject:property forKey:property.name];
}
-(NSString *)parseClassInterface{
    NSString *interface = [NSString stringWithFormat:@"\n@interface %@ : MTLModel<MTLJSONSerializing>\n", self.name];
    
    for (Property *property in self.properties) {
        NSString *secondType = @"";
        NSString *propertyType = @"";
        switch (property.pType) {
            case STRING:
                secondType = @"copy";
                propertyType = @"NSString *";
                break;
            case NUMBER:
                secondType = @"assign";
                propertyType = @"NSNumber* ";
                break;
            default:
                secondType = @"strong";
                if (property.classType == nil) {
                    propertyType = @"id ";
                }
                else
                {
                    propertyType = [property.classType stringByAppendingString:@" *"];
                }
                break;
        }
        
        NSString *pStr = [NSString stringWithFormat:@"@property (nonatomic, %@) %@ %@;\n", secondType, propertyType, property.name];
        interface = [interface stringByAppendingString:pStr];
    }
    
    interface = [interface stringByAppendingString:@"@end\n"];
    return interface;
}
-(NSString *)parseClassImplementation{
    NSString *implement = [NSString stringWithFormat:@"\n@implementation %@\n+(NSDictionary *)JSONKeyPathsByPropertyKey{\nreturn\n@{\n", self.name];
    
    NSString *dicStr = @"";
    for (Property *property in self.properties) {
        if (![dicStr isEqualToString:@""]) {
            dicStr = [dicStr stringByAppendingString:@",\n"];
        }
        dicStr = [dicStr stringByAppendingString:[NSString stringWithFormat:@"@\"%@\":@\"%@\"", property.name, property.name]];
    }
    implement = [implement stringByAppendingString:dicStr];
    implement = [implement stringByAppendingString:@"\n};\n}"];
    implement = [implement stringByAppendingString:@"@end"];
    return implement;
}
@end
