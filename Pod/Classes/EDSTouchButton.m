//
//  EDSTouchButton.m
//
//  Created by Eduardo Diaz Sancha on 12/13/14.
//
//

#import "EDSTouchButton.h"
#import <QuartzCore/QuartzCore.h>
#import <POP.h>

static const float kDefaultDuration = .5f;
static const float kDefaultTouchDiameter = 100.f;
static const float kDefaultCornerRadius = 5.f;

#define MAX_CORNER_RADIUS    MIN(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0)

@interface EDSTouchButton () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *touchView;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, assign) CGPathRef borderPath;

@property (nonatomic, assign) BOOL restoreSelectedState;

@end


@implementation EDSTouchButton

@synthesize borderPath;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];{
        [self setupButton];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                   buttonType:(EDSTouchButtonType)type {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupButton];
        _buttonType = type;
    
    }
    return self;
}

+ (instancetype)buttonWithFrame:(CGRect)frame
                     buttonType:(EDSTouchButtonType)type {
    return [[EDSTouchButton alloc] initWithFrame:frame buttonType:type];
}

- (instancetype) initWithButtonFrame:(CGRect)frame
                     backgroundColor:(UIColor *)backgroundColor
                               title:(NSString *)title
                          titleColor:(UIColor *)titleColor {
    
    self = [self initWithFrame:frame buttonType:EDSTouchButtonTypeDefault];
    if (self) {
        self.backgroundColor = backgroundColor;
        self.title = title;
        self.titleColor = titleColor;
        self.touchColor = [titleColor colorWithAlphaComponent:0.3];
    }
    return self;
}

- (void) setupButton {
    
    _touchDiameter = kDefaultTouchDiameter;
    
    _restoreSelectedState = YES;
    _cornerRadius = kDefaultCornerRadius;
    _contentEdgeInsets = UIEdgeInsetsZero;
    
    _touchColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    
    self.layer.cornerRadius = _cornerRadius;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    [self addGestureRecognizer:tap];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.minimumScaleFactor = 0.1;
    self.textLabel.numberOfLines = 1;
    
    [self addSubview:self.textLabel];
}

- (CGRect)contentRect {
    return UIEdgeInsetsInsetRect(self.bounds, self.contentEdgeInsets);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = self.frame;
    
    CGFloat cornerRadius = self.layer.cornerRadius = MAX(MIN(MAX_CORNER_RADIUS, self.cornerRadius), 0);
    
    _cornerRadius = cornerRadius;
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                           cornerRadius:self.layer.cornerRadius].CGPath;
    CGPathRef cgPath = CGPathCreateCopy(mask.path);
    
    CGPathRelease(borderPath);
    borderPath = cgPath;
    CGPathRetain(borderPath);
    
    mask.fillColor = [UIColor blackColor].CGColor;
    mask.strokeColor = [UIColor clearColor].CGColor;
    mask.borderColor = [UIColor clearColor].CGColor;
    mask.borderWidth = 0;
    mask.cornerRadius = cornerRadius;
    
    // Set tap circle layer's mask to the mask:
    self.layer.mask = mask;
    
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderWidth;
    
    switch (self.buttonType) {
            
        case EDSTouchButtonTypeDefault:
        default: {
            self.textLabel.frame = [self contentRect];
        }
            break;
    }
}


#pragma mark - Setter and getters
- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius == cornerRadius) {
        return;
    }
    
    _cornerRadius = cornerRadius;
    [self setNeedsLayout];
}


- (void)setTitle:(NSString *)title {
    self.textLabel.text = title;
}

- (void)setTitleColor:(UIColor *)titleColor {
    self.textLabel.textColor = titleColor;
}


#pragma mark - Touches

- (BOOL)pointInside:(CGPoint)point {
    return CGPathContainsPoint(borderPath, NULL, point, FALSE);
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{

    CGPoint point = [touch locationInView:self];
    
    if ([self pointInside:point]) {
        [self addRippleView:point];
    }
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint pt = [touch locationInView:self];

    // Set new location
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    //    anim.springBounciness = 12;
    //    anim.springSpeed = 5;
    anim.dynamicsTension = 2000;
    anim.fromValue = [NSValue valueWithCGPoint:self.touchView.center];
    anim.toValue = [NSValue valueWithCGPoint:pt];
    [anim setValue:@"touchAnim" forKey:@"animName"];
    [anim setValue:self.touchView forKey:@"rippleObject"];
    anim.delegate = self;
    [self.touchView pop_addAnimation:anim forKey:@"moveTouchView"];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint pt = [touch locationInView:self];
    
    if ([self pointInside:pt]) {
        [self addRippleEffectToPoint:pt];
    }
    
    [self.touchView removeFromSuperview];
    self.touchView = nil;
}



- (void) viewTapped:(UITapGestureRecognizer *)tapGesture {

    CGPoint point = [tapGesture locationInView:self];
    if ([self pointInside:point]) {
        
        [self addRippleEffectToPoint:point];
        [self.touchView removeFromSuperview];
        self.touchView = nil;
    }
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    
    if (finished) {
        if ([[anim valueForKey:@"animName"] isEqualToString:@"progressBar"]){
            
            UIView *rippleEffect = [anim valueForKey:@"rippleObject"];

            POPBasicAnimation *alpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            alpha.duration = kDefaultDuration/3;
            alpha.toValue = @(0.f);
            [anim setValue:@"dilute" forKey:@"animName"];
            [anim setValue:rippleEffect forKey:@"rippleObject"];

            [rippleEffect pop_addAnimation:alpha forKey:@"alpha"];
            
            [self sendActionsForControlEvents:UIControlEventTouchUpInside];
            
        } else if ([[anim valueForKey:@"animName"] isEqualToString:@"dilute"]){
            
            UIView *rippleEffect = [anim valueForKey:@"rippleObject"];
            [rippleEffect removeFromSuperview];
            rippleEffect = nil;
            
        }

    }
}

- (void)addRippleView:(CGPoint)point {
    
    self.touchView = [[UIView alloc]initWithFrame:CGRectMake(point.x, point.y, _touchDiameter, _touchDiameter)];
    self.touchView.center = point;
    self.touchView.layer.cornerRadius = _touchDiameter / 2;
    self.touchView.backgroundColor = self.touchColor;
    
    [self addSubview:self.touchView];
    
}

- (void)addRippleEffectToPoint:(CGPoint)point {


    UIView *rippleEffect = [[UIView alloc]initWithFrame:CGRectMake(point.x, point.y, _touchDiameter, _touchDiameter)];
    rippleEffect.center = point;
    rippleEffect.layer.cornerRadius = _touchDiameter / 2;
    rippleEffect.backgroundColor = self.touchColor;
    
    [self addSubview:rippleEffect];

    POPBasicAnimation *alpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alpha.duration = kDefaultDuration;
    alpha.toValue = @(0.2);
    [rippleEffect pop_addAnimation:alpha forKey:@"alpha"];

    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewSize];
    anim.fromValue = [NSValue valueWithCGSize:rippleEffect.frame.size];
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(self.frame.size.width*2, self.frame.size.width*2)];
    [anim setValue:@"progressBar" forKey:@"animName"];
    [anim setValue:rippleEffect forKey:@"rippleObject"];
    anim.delegate = self;
    anim.duration = kDefaultDuration;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [rippleEffect pop_addAnimation:anim forKey:@"progressBar"];
    
    POPBasicAnimation *cornerRad = [POPBasicAnimation animation];
    POPAnimatableProperty *cornerRadius = [POPAnimatableProperty propertyWithName:@"layer.cornerRadius"
                                                                      initializer:^(POPMutableAnimatableProperty *prop) {
                                                                          // read value
                                                                          prop.readBlock = ^(id obj, CGFloat values[]) {
                                                                              values[0] = [obj cornerRadius];
                                                                          };
                                                                          // write value
                                                                          prop.writeBlock = ^(id obj, const CGFloat values[]) {
                                                                              [obj setCornerRadius:values[0]];
                                                                          };
                                                                          // dynamics threshold
                                                                          prop.threshold = 0.01;
                                                                      }];

    cornerRad.property = cornerRadius;
    cornerRad.duration = kDefaultDuration;
    cornerRad.fromValue = @(_touchDiameter / 2);
    cornerRad.toValue = @(self.frame.size.width);
    cornerRad.timingFunction = anim.timingFunction;
    [rippleEffect.layer pop_addAnimation:cornerRad forKey:@"cornerRadius"];
    
}

@end
