//
//  ViewController.m
//  Json2ObjectiveC
//
//  Created by Netease on 16/1/4.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "ViewController.h"
#import "Json2CalssTransformer.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allDic = [[NSMutableArray alloc] init];
    self.classFormater = @"#import <Foundation/Foundation.h>\n#import \"Mantle.h\"";
    self.classFormater = [self.classFormater stringByAppendingString:@"\n@interface %@ : MTLModel<MTLJSONSerializing>\n"];
    self.classFormater = @"\n@interface %@ : MTLModel<MTLJSONSerializing>\n";
    self.propertyFormater = @"@property (nonatomic, %@) %@ %@;\n";
    self.classDict = [[NSMutableDictionary alloc] init];
    self.interface = @"";
    self.implementation = @"";
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)transferClick:(id)sender {
    NSString *url = [self.urlLabel.stringValue isEqualTo:@""] ? self.urlLabel.placeholderString : self.urlLabel.stringValue;
    NSData *content = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString *jsonString = self.jsonField.stringValue;
    if (![jsonString isEqualToString:@""]) {
        content = [self.jsonField.stringValue dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    Json2CalssTransformer *trans = [[Json2CalssTransformer alloc] init];
    [trans transformData:content];
}

//创建新类型
-(NSString *)createClass:(NSDictionary *)dict name:(NSString *)name{
    NSString *class = [NSString stringWithFormat:self.classFormater, name];
    
    NSString *implement = @"\n@implementation %@\n+(NSDictionary *)JSONKeyPathsByPropertyKey{\nreturn\n@{\n";
    implement = [NSString stringWithFormat:implement, name];
    NSString *transformerStr = @"";
    NSString *propertyType = @"strong";
    //遍历所有属性
    for (NSString *key in dict.allKeys) {
        id value = dict[key];
        
        NSString *propertyClass = @"id";
        if ([value isKindOfClass:[NSDictionary class]]) {
            propertyClass = [key stringByAppendingString:@"Class"];
            if (![self isClassExists:value]) {
                [self createClass:value name:propertyClass];
            }
        }
        else if([value isKindOfClass:[NSArray class]]){
            //TODO:
            propertyClass = @"NSArray *";
            for (id obj in value) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    if ([self isClassExists:obj])
                        continue;
                    [self createClass:obj name:[[key stringByAppendingString:@"List"] stringByAppendingString:@"Class"]];
                }
            }
        }
        else
        {
            if([value isKindOfClass:[NSString class]])
            {
                propertyClass = @"NSString *";
                propertyType = @"copy";
            }
            if ([value isKindOfClass:[NSNumber class]]) {
                propertyType = @"assign";
            }
        }
        class = [class stringByAppendingString:[NSString stringWithFormat:self.propertyFormater, propertyType, propertyClass, key]];
        if (![transformerStr isEqualToString:@""]) {
            transformerStr = [transformerStr stringByAppendingString:@",\n"];
        }
        transformerStr = [transformerStr stringByAppendingString:[NSString stringWithFormat:@"@\"%@\":@\"%@\"", key, key]];
    }
    implement = [implement stringByAppendingString:transformerStr];
    implement = [implement stringByAppendingString:@"\n};\n}"];
    //implement = @"\n";
    class = [class stringByAppendingString:@"@end"];
    //NSLog(@"%@\n%@",class,implement);
    //[self.classDict setValue:class forKey:name];
    self.interface = [self.interface stringByAppendingString:class];
    self.implementation = [self.implementation stringByAppendingString:implement];
    return nil;
}
//判断类是否存在
-(BOOL)isClassExists:(NSDictionary *)dict{
    for (NSDictionary *d in self.allDic) {
        if ([self isDictionaryFormatEqual:d dict:dict]) {
            return YES;
        }
    }
    [self.allDic addObject:dict];
    return NO;
}

-(void)transformData:(id)jsonObject name:(NSString *)name{
    NSLog(@"--------------");
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        [self createClass:jsonObject name:name];
    }
    else if ([jsonObject isKindOfClass:[NSArray class]]) {
//        for (id obj in jsonObject) {
//            [self transformData:obj];
//        }
        //TODO:array
    }
}

-(BOOL)isDictionaryFormatEqual:(NSDictionary *)d1 dict:(NSDictionary *)d2{
    NSMutableSet *d1Keys = [NSMutableSet setWithArray:d1.allKeys];
    NSMutableSet *d2Keys = [NSMutableSet setWithArray:d2.allKeys];
    
    BOOL isEqual = [d1Keys isEqualToSet:d2Keys];
    if (isEqual) {
        return YES;
    }
    return NO;
}

@end
