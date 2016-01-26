//
//  Property.h
//  Json2ObjectiveC
//
//  Created by Netease on 16/1/5.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
enum PropertyType{STRING, NUMBER, ARRAY, DICTIONARY, ID};

//This is document
@interface Property : NSObject
@property (nonatomic, assign) enum PropertyType pType;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *classType;

- (instancetype)initWithName:(NSString *)name
                       type:(enum PropertyType)type
                  classType:(NSString *)cType;
@end
