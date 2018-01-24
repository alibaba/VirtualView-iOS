//
//  VVPropertyExpressionSetter.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertyExpressionSetter.h"

@interface VVPropertyExpressionSetter ()

@property (nonatomic, strong, readwrite) VVExpression *expression;

@end

@implementation VVPropertyExpressionSetter

+ (VVPropertyExpressionSetter *)setterWithPropertyKey:(int)key expressionString:(NSString *)expressionString
{
    if (expressionString && expressionString.length > 0) {
        expressionString = [expressionString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (expressionString.length > 0 && ([expressionString hasPrefix:@"@{"] || [expressionString hasPrefix:@"${"])) {
            VVExpression *expression = [VVExpression expressionWithString:expressionString];
            if (expression && [expression isKindOfClass:[VVConstExpression class]] == NO) {
                VVPropertyExpressionSetter *setter = [[self alloc] initWithPropertyKey:key];
                setter.expression = expression;
                return setter;
            }
        }
    }
    return nil;
}

- (instancetype)initWithPropertyKey:(int)key
{
    if (self = [super initWithPropertyKey:key]) {
        switch (key) {
            case STR_ID_autoDimDirection:
            case STR_ID_stayTime:
            case STR_ID_animatorTime:
            case STR_ID_autoSwitchTime:
                _valueType = TYPE_INT;
                break;
            case STR_ID_paddingLeft:
            case STR_ID_paddingTop:
            case STR_ID_paddingRight:
            case STR_ID_paddingBottom:
            case STR_ID_layoutMarginLeft:
            case STR_ID_layoutMarginRight:
            case STR_ID_layoutMarginTop:
            case STR_ID_layoutMarginBottom:
            case STR_ID_autoDimX:
            case STR_ID_autoDimY:
            case STR_ID_borderWidth:
            case STR_ID_borderRadius:
            case STR_ID_borderTopLeftRadius:
            case STR_ID_borderTopRightRadius:
            case STR_ID_borderBottomLeftRadius:
            case STR_ID_borderBottomRightRadius:
            case STR_ID_itemHorizontalMargin:
            case STR_ID_itemVerticalMargin:
            case STR_ID_textSize:
                _valueType = TYPE_FLOAT;
                break;
            case STR_ID_data:
            case STR_ID_dataUrl:
            case STR_ID_dataParam:
            case STR_ID_action:
            case STR_ID_actionParam:
            case STR_ID_class:
            case STR_ID_name:
            case STR_ID_backgroundImage:
            case STR_ID_src:
            case STR_ID_text:
            case STR_ID_ck:
                _valueType = TYPE_STRING;
                break;
            case STR_ID_color:
            case STR_ID_textColor:
            case STR_ID_borderColor:
            case STR_ID_maskColor:
            case STR_ID_background:
                _valueType = TYPE_COLOR;
                break;
            case STR_ID_autoSwitch:
            case STR_ID_canSlide:
            case STR_ID_inmainthread:
                _valueType = TYPE_BOOLEAN;
                break;
            case STR_ID_visibility:
                _valueType = TYPE_VISIBILITY;
                break;
            case STR_ID_gravity:
                _valueType = TYPE_GRAVITY;
                break;
            case STR_ID_dataTag:
                _valueType = TYPE_OBJECT;
                break;
            default:
                _valueType = TYPE_OBJECT;
                break;
        }
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; name = %@; expression = %@>", self.class, self, self.name, self.expression];
}

- (BOOL)isExpression
{
    return YES;
}

- (void)applyToNode:(VVBaseNode *)node withDict:(NSDictionary *)dict
{
    if (self.expression) {
        id objectValue = [self.expression resultWithObject:dict];
        NSString *stringValue = [objectValue description];
        switch (self.valueType) {
            case TYPE_INT:
            {
                [node setIntValue:[stringValue intValue] forKey:self.key];
            }
                break;
            case TYPE_FLOAT:
            {
                [node setFloatValue:[stringValue floatValue] forKey:self.key];
            }
                break;
            case TYPE_STRING:
            case TYPE_COLOR:
            {
                [node setStringDataValue:stringValue forKey:self.key];
            }
                break;
            case TYPE_BOOLEAN:
            {
                if ([stringValue isEqualToString:@"true"]) {
                    [node setIntValue:1 forKey:self.key];
                } else {
                    [node setIntValue:0 forKey:self.key];
                }
            }
                break;
            case TYPE_VISIBILITY:
            {
                if ([stringValue isEqualToString:@"invisible"]) {
                    [node setIntValue:VVVisibilityInvisible forKey:self.key];
                } else if ([stringValue isEqualToString:@"visible"]) {
                    [node setIntValue:VVVisibilityVisible forKey:self.key];
                } else {
                    [node setIntValue:VVVisibilityGone forKey:self.key];
                }
            }
                break;
            case TYPE_GRAVITY:
            {
                [node setIntValue:[VVPropertyExpressionSetter getGravity:stringValue] forKey:self.key];
            }
                break;
            case TYPE_OBJECT:
            {
                [node setDataObj:objectValue forKey:self.key];
            }
                break;
            default:
                break;
        }
    }
}

+ (int)getGravity:(NSString *)stringValue
{
    NSArray *array = [stringValue componentsSeparatedByString:@"|"];
    int gravity = 0;
    for (NSString *item in array) {
        if ([item compare:@"left" options:NSCaseInsensitiveSearch]) {
            gravity |= VVGravityLeft;
        } else if ([item compare:@"right" options:NSCaseInsensitiveSearch]) {
            gravity |= VVGravityRight;
        } else if ([item compare:@"h_center" options:NSCaseInsensitiveSearch]) {
            gravity |= VVGravityHCenter;
        } else if ([item compare:@"top" options:NSCaseInsensitiveSearch]) {
            gravity |= VVGravityTop;
        } else if ([item compare:@"bottom" options:NSCaseInsensitiveSearch]) {
            gravity |= VVGravityBottom;
        } else if ([item compare:@"v_center" options:NSCaseInsensitiveSearch]) {
            gravity |= VVGravityVCenter;
        } else if ([item compare:@"center" options:NSCaseInsensitiveSearch]) {
            gravity |= VVGravityHCenter|VVGravityVCenter;
        }
    }
    return gravity;
}

@end
