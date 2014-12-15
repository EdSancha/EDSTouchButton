//
//  EDSTouchButton.h
//
//  Created by Eduardo Diaz Sancha on 12/13/14.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EDSTouchButtonType){
    EDSTouchButtonTypeDefault
};

IB_DESIGNABLE

@interface EDSTouchButton : UIControl

@property (nonatomic, readonly) EDSTouchButtonType  buttonType;

@property (nonatomic, strong) IBInspectable NSString *title;
@property (nonatomic, assign) IBInspectable UIColor *titleColor;

@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, strong) IBInspectable UIColor *touchColor;
@property (nonatomic, assign) IBInspectable CGFloat touchDiameter;

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

/**
 *  Class initializer which creates and returns a new button of the specified type.
 *
 *  @param frame Button frame
 *  @param type  Button type, currently there's only a default type
 *
 *  @return EDSTouchButton control
 */
+ (instancetype)buttonWithFrame:(CGRect)frame
                     buttonType:(EDSTouchButtonType)type;

/**
 *  which creates and returns a new button of the specified type.
 *
 *  @param frame Button frame
 *  @param type  Button type, currently there's only a default type
 *
 *  @return EDSTouchButton control
 */
- (instancetype)initWithFrame:(CGRect)frame
                   buttonType:(EDSTouchButtonType)type;
/**
 *  Detailed instance initializer with button type
 *
 *  @param frame           Button frame
 *  @param backgroundColor Background color
 *  @param title           Title
 *  @param titleColor      Title color, sets an associated touch color too
 *
 *  @return EDSTouchButton control
 */
- (instancetype) initWithButtonFrame:(CGRect)frame
                     backgroundColor:(UIColor *)backgroundColor
                               title:(NSString *)title
                          titleColor:(UIColor *)titleColor;

@end
