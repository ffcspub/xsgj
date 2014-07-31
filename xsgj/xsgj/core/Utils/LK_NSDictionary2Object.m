//
//  NSDiction+External.m
//  AFNETTEST
//
//  Created by hesh on 13-8-22.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "LK_NSDictionary2Object.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define DATEFORMAT_DEFAULT @"yyyy-MM-dd HH:mm:ss"

@interface NSString (TypeEncode)

-(NSString *)asString;
-(NSNumber *)asNumber;
-(int)asInteger;
-(long)asLong;
-(double)asDouble;
-(float)asFloat;
-(NSDate *)asDate;
-(NSData *)asData;

@end

@interface NSNumber (TypeEncode)

-(NSString *)asString;
-(NSNumber *)asNumber;
-(int)asInteger;
-(long)asLong;
-(double)asDouble;
-(float)asFloat;
-(NSDate *)asDate;
-(NSData *)asData;

@end

@interface NSObject (TypeEncode)

-(NSString *)asString;
-(NSNumber *)asNumber;
-(int)asInteger;
-(long)asLong;
-(double)asDouble;
-(float)asFloat;
-(NSDate *)asDate;
-(NSData *)asData;

-(id)objectAsBaseClass:(Class)class;

@end

@implementation NSString (TypeEncode)

-(NSString *)asString;{
    return [NSString stringWithString:self];
}

-(NSNumber *)asNumber;{
    NSString *regEx = @"^-?\\d+.?\\d?";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    BOOL isMatch            = [pred evaluateWithObject:self];
    if (isMatch) {
        return [NSNumber numberWithDouble:[self doubleValue]];
    }
    return nil;
}

-(int)asInteger;{
    NSNumber *number = [self asNumber];
    return [number asInteger];
}

-(long)asLong;{
    NSNumber *number = [self asNumber];
    return [number asLong];
}

-(double)asDouble;{
    NSNumber *number = [self asNumber];
    return [number asDouble];
}

-(float)asFloat;{
    NSNumber *number = [self asNumber];
    return [number asFloat];
}

-(NSDate *)asDate;{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:DATEFORMAT_DEFAULT];
    return [formatter dateFromString:self];
}

-(NSData *)asData;{
    return [self dataUsingEncoding: NSASCIIStringEncoding];
}

@end

@implementation NSNumber (TypeEncode)

-(NSString *)asString;{
    return self.description;
}

-(NSNumber *)asNumber;{
    return self;
}

-(int)asInteger;{
    return self.integerValue;
}

-(long)asLong;{
    return self.longValue;
}

-(double)asDouble;{
    return self.doubleValue;
}

-(float)asFloat;{
    return self.floatValue;
}

-(NSDate *)asDate;{
    double time = self.doubleValue;
    return [NSDate dateWithTimeIntervalSince1970:time];
}

-(NSData *)asData;{
    NSString *string = [self asString];
    return [string dataUsingEncoding: NSASCIIStringEncoding];
}

@end

@implementation NSObject (TypeEncode)

-(NSString *)asString;{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self asString];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self asString];
    }
    return self.description;
}

-(NSNumber *)asNumber;{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self asNumber];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self asNumber];
    }
    return nil;
}

-(int)asInteger;{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self asInteger];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self asInteger];
    }
    return 0;
}

-(long)asLong;{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self asLong];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self asLong];
    }
    return 0;
}

-(double)asDouble;{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self asDouble];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self asDouble];
    }
    return 0.0;
}

-(float)asFloat;{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self asFloat];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self asFloat];
    }
    return 0.0f;
}

-(NSDate *)asDate;{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self asDate];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self asDate];
    }
    return nil;
}

-(NSData *)asData;{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self asData];
    }else if([self isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)self asData];
    }
    return nil;
}

-(id)objectAsBaseClass:(Class)class;{
    if ([self isMemberOfClass:class]) {
        return self;
    }else if(class == [NSString class]){
        return [self asString];
    }else if(class == [NSNumber class]){
        return [self asNumber];
    }else if(class == [NSData class]){
        return [self asData];
    }else if(class == [NSDate class]){
        return [self asDate];
    }
    return [NSNull null];
}

@end

@implementation NSDictionary(LK_NSDictionary2Object)

-(id)objectByClass:(Class)clazz;{
    if (clazz == [NSDictionary class]) {
        return [NSDictionary dictionaryWithDictionary:self];
    }else if(clazz == [NSMutableDictionary class]){
        return [NSMutableDictionary dictionaryWithDictionary:self];
    }else if(clazz == [NSString class]){
        return self.description;
    }else if(clazz == [NSMutableString class]){
        return [NSMutableString stringWithString:self.description];
    }else if(clazz == [NSArray class] || clazz == [NSMutableArray class]){
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject * key in self.allKeys) {
            NSString *string = [NSString stringWithFormat:@"%@:%@",key,[self objectForKey:key]];
            [array addObject:string];
        }
        return array;
    }
    __autoreleasing NSObject *object = [[clazz alloc]init];
    NSArray *allkeys = self.allKeys;
    int flag = NO;
    for (NSObject * tkey in allkeys) {
        if ([tkey isKindOfClass:[NSString class]]) {
            NSString *key = (NSString *)tkey;
            objc_property_t protpery_t = class_getProperty(clazz, [key UTF8String]);
            if (protpery_t) {
                id value = [self objectForKey:key];
                if (!value) {
                    continue;
                }
                if ([value isKindOfClass:[NSArray class]]) {
                    NSString *propertyClass = [NSString stringWithFormat:@"__%@Class",key];
                    SEL sel = NSSelectorFromString(propertyClass);
                    if ([clazz respondsToSelector:sel]) {
                        NSMutableArray *array =  [NSMutableArray array];
                        for (NSObject * cValue in (NSArray *)value) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                            Class propertyClass = [clazz performSelector:sel];
#pragma clang diagnostic pop
                            id tvalue = [(NSDictionary *)cValue objectByClass:propertyClass];
                            [array addObject:tvalue];
                        }
                        value = array;
                    }
                }else if ([value isKindOfClass:[NSDictionary class]]) {
                    const char *	attr = property_getAttributes(protpery_t);
                    if ( attr[0] != 'T' ){
                        continue;
                    }
                    const char * type = &attr[1];
                    if ( type[0] == '@' )
                    {
                        if ( type[1] != '"' )
                            continue;
                        char typeClazz[128] = { 0 };
                        const char * mclazz = &type[2];
                        const char * clazzEnd = strchr( mclazz, '"' );
                        if ( clazzEnd && mclazz != clazzEnd )
                        {
                            unsigned int size = (unsigned int)(clazzEnd - mclazz);
                            strncpy( &typeClazz[0], mclazz, size );
                        }
                        if (typeClazz) {
                            Class mclass = NSClassFromString([NSString stringWithUTF8String:typeClazz]);
                            value = [(NSDictionary *)value objectByClass:mclass];
                        }
                    }
                }else{
                    const char *	attr = property_getAttributes(protpery_t);
                    if ( attr[0] != 'T' ){
                        continue;
                    }
                    const char * type = &attr[1];
                    if ( type[0] == '@' )
                    {
                        if ( type[1] != '"' )
                            continue;
                        char typeClazz[128] = { 0 };
                        const char * mclazz = &type[2];
                        const char * clazzEnd = strchr( mclazz, '"' );
                        if ( clazzEnd && mclazz != clazzEnd )
                        {
                            unsigned int size = (unsigned int)(clazzEnd - mclazz);
                            strncpy( &typeClazz[0], mclazz, size );
                        }
                        if (typeClazz) {
                            Class mclass = NSClassFromString([NSString stringWithUTF8String:typeClazz]);
                            value = [(NSObject *)value objectAsBaseClass:mclass];
                        }
                    }else{
                        if ( type[0] == _C_INT || type[0] == _C_UINT || type[0] == _C_BOOL || type[0] == _C_SHT || type[0] == _C_BFLD || type[0] == _C_CHR)
                        {
                            int tvalue =[(NSObject *)value asInteger];
                            NSString *topchar = [[key substringToIndex:1]uppercaseString];
                            NSString *selectorString = [NSString stringWithFormat:@"set%@:",[key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:topchar]];
                            SEL selector = NSSelectorFromString(selectorString);
                            objc_msgSend(object, selector,tvalue);
                            flag = YES;
                        }
                        else if ( type[0] == _C_ULNG || type[0] == _C_LNG || type[0] == _C_ULNG || type[0] == _C_LNG_LNG )
                        {
                            long tvalue =[(NSObject *)value asLong];
                            NSString *topchar = [[key substringToIndex:1]uppercaseString];
                            NSString *selectorString = [NSString stringWithFormat:@"set%@:",[key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:topchar]];
                            SEL selector = NSSelectorFromString(selectorString);
                            objc_msgSend(object, selector,tvalue);
                            flag = YES;
                        }
                        else if ( type[0] == _C_ULNG_LNG)
                        {
                            [object setValue:value forKey:key];
                            flag = YES;
                        }
                        else if ( type[0] == _C_DBL)
                        {
                            double tvalue = [(NSObject *)value asDouble];
                            NSNumber *number = [NSNumber numberWithDouble:tvalue];
                            [object setValue:number forKey:key];
                            flag = YES;
                        }
                        else if ( type[0] == _C_FLT)
                        {
                            float tvalue = [(NSObject *)value asFloat];
                            NSNumber *number = [NSNumber numberWithFloat:tvalue];
                            [object setValue:number forKey:key];
//                            NSString *topchar = [[key substringToIndex:1]uppercaseString];
//                            NSString *selectorString = [NSString stringWithFormat:@"set%@:",[key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:topchar]];
//                            SEL selector = NSSelectorFromString(selectorString);
//                            [object setValue:[NSValue value:tvalue withObjCType:_C_FLT] forKey:<#(NSString *)#>]
//                            objc_msgSend(object, selector,tvalue);
                            flag = YES;
                        }
                        else if ( type[0] == _C_LNG_LNG)
                        {
                            double tvalue = [(NSObject *)value asFloat];
                            [object setValue:[NSValue value:&tvalue withObjCType:@encode(int)] forKey:key];
//                            NSString *topchar = [[key substringToIndex:1]uppercaseString];
//                            NSString *selectorString = [NSString stringWithFormat:@"set%@:",[key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:topchar]];
//                            SEL selector = NSSelectorFromString(selectorString);
//                            objc_msgSend(object, selector,tvalue);
                            flag = YES;
                        }
                        continue;
                    }
                }
                if (!value || [value isEqual:[NSNull null]]) {
                    continue;
                }
                [object setValue:value forKey:key];
                flag = YES;
            }
        }
        
    }
    if (flag) {
        return object;
    }
    return NO;
}

@end

@implementation NSObject(LK_NSDictionary2Object)


-(NSDictionary *)dictionaryWithClass:(Class)class{
    if (class == [NSDictionary class]) {
        return (NSDictionary*) self;
    }
    if (class == [NSString class]) {
        return nil;
    }
    if (class == [NSObject class]) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
    for ( NSUInteger i = 0; i < propertyCount; i++ )
    {
        const char *	name = property_getName(properties[i]);
        const char *	attr = property_getAttributes(properties[i]);
        NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:propertyName];
        if (!value) {
            continue;
        }
        if ( attr[0] != 'T' ){
            continue;
        }
        const char * type = &attr[1];
        if ( type[0] == '@' )
        {
            if ( type[1] != '"' )
                continue;
            char typeClazz[128] = { 0 };
            const char * mclazz = &type[2];
            const char * clazzEnd = strchr( mclazz, '"' );
            if ( clazzEnd && mclazz != clazzEnd )
            {
                unsigned int size = (unsigned int)(clazzEnd - mclazz);
                strncpy( &typeClazz[0], mclazz, size );
            }
            if (typeClazz) {
                if ([value isKindOfClass:[NSArray class]]) {
                     NSMutableArray *array =  [NSMutableArray array];
                    for (NSObject * cValue in (NSArray *)value) {
                        Class clazz = (Class)[cValue class];
                        [array addObject:[cValue dictionaryWithClass:clazz]];
                    }
                    value = array;
                    [dict setValue:value forKey:propertyName];
                    continue;
                }
                if (![value isKindOfClass:[NSString class]] && ![value isKindOfClass:[NSNumber class]] ) {
                    value = [(NSObject *)value lkDictionary];
                    if (!value) {
                        continue;
                    }
                }
                [dict setValue:value forKey:propertyName];
            }
        }else{
            if ( type[0] == _C_INT || type[0] == _C_UINT || type[0] == _C_BOOL || type[0] == _C_SHT || type[0] == _C_BFLD)
            {
                NSNumber *number = nil;
                if ([value isKindOfClass:[NSString class]]) {
                    int intvalue = [(NSString *)value integerValue];
                    value = [NSNumber numberWithInt:intvalue];
                }
                number = (NSNumber *)value;
                [dict setObject:number forKey:propertyName];
            }
            else if ( type[0] == _C_ULNG || type[0] == _C_LNG || type[0] == _C_ULNG || type[0] == _C_LNG_LNG || type[0] == _C_ULNG_LNG || type[0] == _C_FLT)
            {
                NSNumber *number = nil;
                if ([value isKindOfClass:[NSString class]]) {
                    long long intvalue = [(NSString *)value longLongValue];
                    value = [NSNumber numberWithLongLong:intvalue];
                }
                number = (NSNumber *)value;
                [dict setObject:number forKey:propertyName];
            }
            else if ( type[0] == _C_DBL || type[0] == _C_BFLD )
            {
                NSNumber *number = nil;
                if ([value isKindOfClass:[NSString class]]) {
                    float intvalue = [(NSString *)value floatValue];
                    value = [NSNumber numberWithFloat:intvalue];
                }
                number = (NSNumber *)value;

                [dict setObject:number forKey:propertyName];
            }
        }
        
    }
    return dict;
}

-(NSDictionary *)lkDictionary;{
    if ([self isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary*) self;
    }
    if ([self isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setDictionary:[self dictionaryWithClass:[self class]]];
    Class clazz = [[self class]superclass];
    BOOL flag = YES;
    do {
        NSDictionary *dicttemp = [self dictionaryWithClass:clazz];
        if (!dicttemp) {
            flag = NO;
        }else{
            [dict addEntriesFromDictionary:dicttemp];
            clazz = [clazz superclass];
        }
        
    } while (flag);
    return dict;
}

@end
