//
//  XNSimpleMessageCell.m
//  XNLiNing
//
//  Created by xunan on 2017/3/27.
//  Copyright © 2017年 xunan. All rights reserved.
//

#import "XNSimpleMessageCell.h"
#import "XNChatSystemMessage.h"

@interface XNSimpleMessageCell()

- (void)initialize;

@end

@implementation XNSimpleMessageCell


- (NSDictionary *)attributeDictionary {
    if (self.messageDirection == MessageDirection_SEND) {
        return @{
                 @(NSTextCheckingTypeLink) : @{NSForegroundColorAttributeName : [UIColor blueColor]},
                 @(NSTextCheckingTypePhoneNumber) : @{NSForegroundColorAttributeName : [UIColor blueColor]}
                 };
    } else {
        return @{
                 @(NSTextCheckingTypeLink) : @{NSForegroundColorAttributeName : [UIColor blueColor]},
                 @(NSTextCheckingTypePhoneNumber) : @{NSForegroundColorAttributeName : [UIColor blueColor]}
                 };
    }
    return nil;
}

- (NSDictionary *)highlightedAttributeDictionary {
    return [self attributeDictionary];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize {
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    self.textLabel = [[RCAttributedLabel alloc] initWithFrame:CGRectZero];
    self.textLabel.attributeDictionary = [self attributeDictionary];
    self.textLabel.highlightedAttributeDictionary = [self highlightedAttributeDictionary];
    [self.textLabel setFont:[UIFont systemFontOfSize:12.0f]];
    
    self.textLabel.numberOfLines = 0;
    [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.textLabel setTextAlignment:NSTextAlignmentCenter];
    [self.textLabel setTextColor:XNColor_Hex(0x666666)];
    //[self.textLabel setBackgroundColor:[UIColor yellowColor]];
    
    [self.bubbleBackgroundView addSubview:self.textLabel];
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    //    UILongPressGestureRecognizer *longPress =
    //    [[UILongPressGestureRecognizer alloc]
    //     initWithTarget:self
    //     action:@selector(longPressed:)];
    //[self.bubbleBackgroundView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *textMessageTap = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(tapTextMessage:)];
    //    textMessageTap.numberOfTapsRequired = 1;
    //    textMessageTap.numberOfTouchesRequired = 1;
    [self.bubbleBackgroundView addGestureRecognizer:textMessageTap];
    //self.textLabel.userInteractionEnabled = YES;
    
}

- (void)tapTextMessage:(UIGestureRecognizer *)gestureRecognizer {
    
    RCMessageModel *model = self.model;
    XNChatSystemMessage *message = (XNChatSystemMessage *)model.content;
    NSString *decodeStr=[self URLDecodedString:message.extra];
    if ([decodeStr rangeOfString:@"__oadest="].location !=NSNotFound) {
        NSArray *urlArray = [decodeStr componentsSeparatedByString:@"__oadest="];
        if (urlArray.count > 1) {
            if (![urlArray[1] isEqualToString:@"https://blank"]) {
                
            }
        }
    } else {
        
    }
}

- (void)longPressed:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model
                                        inView:self.bubbleBackgroundView];
    }
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    [self setAutoLayout];
}
- (void)setAutoLayout {
    XNChatSystemMessage *_textMessage = (XNChatSystemMessage *)self.model.content;
    if (_textMessage) {
        self.textLabel.text = _textMessage.content;
    } else {
//        DebugLog(@”[RongIMKit]: RCMessageModel.content is NOT RCTextMessage object”);
    }
    // ios 7
    CGSize __textSize =
    [_textMessage.content
     boundingRectWithSize:CGSizeMake(self.baseContentView.bounds.size.width -
                                     (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 -
                                     35,
                                     MAXFLOAT)
     options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
     NSStringDrawingUsesFontLeading
     attributes:@{
                  NSFontAttributeName : [UIFont systemFontOfSize:12.0f]
                  } context:nil]
    .size;
    __textSize = CGSizeMake(ceilf(__textSize.width), ceilf(__textSize.height));
    CGSize __labelSize = CGSizeMake(__textSize.width + 5, __textSize.height + 5);
    
    CGFloat __bubbleWidth = __labelSize.width + 5 + 5 < 25 ? 25 : (__labelSize.width + 5 + 5);
    CGFloat __bubbleHeight = __labelSize.height < 20 ? 20 : (__labelSize.height );
    
    CGSize __bubbleSize = CGSizeMake(__bubbleWidth, __bubbleHeight);
    
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    
    messageContentViewRect.size.width = __bubbleSize.width ;
    messageContentViewRect.origin.x = (XNScreen_Width - messageContentViewRect.size.width)/2;
    self.messageContentView.frame = messageContentViewRect;
    
    self.bubbleBackgroundView.frame = CGRectMake(0, 0, __bubbleSize.width, __bubbleSize.height);
    
    self.textLabel.frame = CGRectMake(5, 0, __labelSize.width, __labelSize.height);
    
    self.bubbleBackgroundView.backgroundColor = XNColor_Hex(0xdddddd);
    self.bubbleBackgroundView.layer.cornerRadius = 5;
    self.bubbleBackgroundView.layer.masksToBounds = YES;
    

    UILabel *label = (UILabel *)self.nicknameLabel;
    label.hidden = YES;
    UIView *avatar = (UIView *)self.portraitImageView;
    avatar.hidden = YES;
    
    
}

- (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName {
    UIImage *image = nil;
    NSString *image_name = [NSString stringWithFormat:@"%@.png", name];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];
    image = [[UIImage alloc] initWithContentsOfFile:image_path];
    
    return image;
}

+ (CGSize)getTextLabelSize:(XNChatSystemMessage *)message {
    if ([message.content length] > 0) {
        float maxWidth =
        [UIScreen mainScreen].bounds.size.width -
        (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 -
        35;
        CGRect textRect = [message.content
                           boundingRectWithSize:CGSizeMake(maxWidth, 8000)
                           options:(NSStringDrawingTruncatesLastVisibleLine |
                                    NSStringDrawingUsesLineFragmentOrigin |
                                    NSStringDrawingUsesFontLeading)
                           attributes:@{
                                        NSFontAttributeName :
                                            [UIFont systemFontOfSize:12]
                                        }
                           context:nil];
        textRect.size.height = ceilf(textRect.size.height);
        textRect.size.width = ceilf(textRect.size.width);
        return CGSizeMake(textRect.size.width + 5, textRect.size.height + 5);
    } else {
        return CGSizeZero;
    }
}

+ (CGSize)getBubbleSize:(CGSize)textLabelSize {
    CGSize bubbleSize = CGSizeMake(textLabelSize.width, textLabelSize.height);
    
    if (bubbleSize.width + 5 + 5 > 15) {
        bubbleSize.width = bubbleSize.width + 5 + 5;
    } else {
        bubbleSize.width = 25;
    }
    if (bubbleSize.height > 20) {
        bubbleSize.height = bubbleSize.height;
    } else {
        bubbleSize.height = 20;
    }
    return bubbleSize;
}

+ (CGSize)getBubbleBackgroundViewSize:(XNChatSystemMessage *)message {
    CGSize textLabelSize = [[self class] getTextLabelSize:message];
    return [[self class] getBubbleSize:textLabelSize];
}
/** url解码*/
-(NSString *)URLDecodedString:(NSString *)str {
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

@end
