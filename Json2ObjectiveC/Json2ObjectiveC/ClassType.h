//
//  ClassType.h
//  Json2ObjectiveC
//
//  Created by Netease on 16/1/5.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Property.h"

// This is documnet
@interface ClassType : NSObject
@property (nonatomic, strong) NSMutableArray *properties;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableDictionary *propertyDic;

-(instancetype)initWithName:(NSString *)name;
-(void)addProperty:(Property *)property;
/**
 *  test
 *
 *  @return test
 */
-(NSString *)parseClassInterface;
-(NSString *)parseClassImplementation;
@end
