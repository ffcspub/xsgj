//
//  NSObject+EasyCopy.m
//  AFNETTEST
//
//  Created by hesh on 13-8-26.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "NSObject+EasyCopy.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject(EasyCopy)

-(void)easyShallowCopy:(NSObject *)object;{
    void(^copyBlock)(objc_property_t *,unsigned int) = ^(objc_property_t * properties,unsigned int propertyCount){
        for ( NSUInteger i = 0; i < propertyCount; i++ )
        {
            const char *	name = property_getName(properties[i]);
            NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            SEL getSel= NSSelectorFromString(propertyName);
            if ([self respondsToSelector:getSel]) {
                id tempValue = [self valueForKey:propertyName];
                NSString *topchar = [[propertyName substringToIndex:1]uppercaseString];
                NSString *selectorString = [NSString stringWithFormat:@"set%@:",[propertyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:topchar]];
                SEL setSel = NSSelectorFromString(selectorString);
                if ([object respondsToSelector:setSel]) {
                    [object setValue:tempValue forKey:propertyName];
//                    objc_msgSend(object, setSel,tempValue);
                }
            }
        }
    };
    unsigned int		propertyCount = 0;
    Class superClass = class_getSuperclass(self.class);
    objc_property_t *	properties = nil;
    if (superClass && superClass != [NSObject class]) {
        properties = class_copyPropertyList( superClass, &propertyCount );
        copyBlock(properties,propertyCount);
    }
    properties = class_copyPropertyList( self.class, &propertyCount );
    copyBlock(properties,propertyCount);
}


-(void)easyDeepCopy:(NSObject *)object;{
    void(^copyBlock)(objc_property_t *,unsigned int) = ^(objc_property_t * properties,unsigned int propertyCount){
        for ( NSUInteger i = 0; i < propertyCount; i++ )
        {
            const char *	name = property_getName(properties[i]);
            NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            SEL getSel= NSSelectorFromString(propertyName);
            if ([self respondsToSelector:getSel]) {
                id tempValue = [self valueForKey:propertyName];
                NSString *topchar = [[propertyName substringToIndex:1]uppercaseString];
                NSString *selectorString = [NSString stringWithFormat:@"set%@:",[propertyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:topchar]];
                SEL setSel = NSSelectorFromString(selectorString);
                if ([object respondsToSelector:setSel]) {
                    Class tempClass = [tempValue class];
                    BOOL flag = [NSObject isNSObjectClass:tempClass];
                    if (flag) {
                        if ([(NSObject *)tempValue conformsToProtocol:@protocol(NSCopying) ]) {
                            NSObject *copyValue = [tempValue copy];
                            [object setValue:copyValue forKey:propertyName];
//                            objc_msgSend(object, setSel,copyValue);
                        }else{
                            NSObject *copyValue = [[[tempValue class]alloc]init];
                            [tempValue easyDeepCopy:copyValue];
//                            objc_msgSend(object, setSel,copyValue);
                            [object setValue:copyValue forKey:propertyName];
                        }
                    }else{
//                        objc_msgSend(object, setSel,tempValue);
                        [object setValue:tempValue forKey:propertyName];
                    }
                    
                }
            }
        }
    };
    unsigned int		propertyCount = 0;
    Class superClass = class_getSuperclass(self.class);
    objc_property_t *	properties = nil;
    if (superClass && superClass != [NSObject class]) {
        properties = class_copyPropertyList( superClass, &propertyCount );
        copyBlock(properties,propertyCount);
    }
    properties = class_copyPropertyList( self.class, &propertyCount );
    copyBlock(properties,propertyCount);    
}

+(BOOL)isNSObjectClass:(Class)clazz{
    BOOL flag = class_conformsToProtocol(clazz, @protocol(NSObject));
    if (flag) {
        return flag;
    }else{
        Class superClass = class_getSuperclass(clazz);
        if (!superClass) {
            return NO;
        }else{
           return  [NSObject isNSObjectClass:superClass];
        }
    }
}


@end
