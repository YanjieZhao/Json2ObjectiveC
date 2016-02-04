//
//  Json2CalssTransformer.h
//  Json2ObjectiveC
//
//  Created by Netease on 16/1/5.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassType.h"
@interface Json2CalssTransformer : NSObject{
@private
    id delegate_;
}
@property (nonatomic, strong) NSMutableDictionary *classDict;
@property (nonatomic, strong) NSMutableArray *classes;
@property (nonatomic, copy) NSString *hResult;
@property (nonatomic, copy) NSString *mResult;
-(void)transformData:(NSData *)data;
-(void)printResult;
@end
