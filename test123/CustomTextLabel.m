//
//  CustomTextLabel.h
//  test123
//
//  Created by 李磊钢 on 2024/5/9.
//

#import "CustomTextLabel.h"
#import "KWCustomTextRange.h"
#import "KWCustomTextPosition.h"
#import "KWCustomTextSelectionRect.h"
#import <CoreText/CoreText.h>

@interface CustomTextLabel ()
{
    NSInteger testCount;
}

@property (nonatomic, strong) NSString *labelText;
//@property (nonatomic, strong) NSString *labelText2;
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *attributes;
@property (nonatomic, strong) UITextRange *currentSelectedTextRange;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat caretWidth;

@property (nonatomic, strong) NSArray <NSString *> *lineArr;
@property (nonatomic, strong) NSArray <NSDictionary<NSAttributedStringKey, id> *> *attriArr;
@property (nonatomic, strong) NSArray <NSString *> *lineframeArr;
@end

@implementation CustomTextLabel

- (instancetype)initWithLabelText:(NSString *)labelText {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _labelText = labelText;
        testCount = 0;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}



- (void)commonInit {
    self.backgroundColor = [UIColor yellowColor];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 6;
    paragraphStyle.paragraphSpacingBefore = 10;
    paragraphStyle.paragraphSpacing = 6;
    paragraphStyle.firstLineHeadIndent = 0;
    paragraphStyle.headIndent = 10;

    // TODO: - (lg) 规避getLinesInfoArrayWithAtti调用频繁的问题
    NSTextTab *tab = [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:10 options:@{}];
    NSTextTab *tab2 = [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:130 options:@{}];
    NSArray<NSTextTab *> *tabs = @[tab,tab2];
    paragraphStyle.tabStops = tabs;
    
    _attributes = @{
        NSForegroundColorAttributeName: [UIColor labelColor],
        NSBackgroundColorAttributeName: [UIColor systemBackgroundColor],
        NSFontAttributeName: [UIFont systemFontOfSize:16.0],
        NSParagraphStyleAttributeName: paragraphStyle,
    };
    
    
    self.currentSelectedTextRange = [[KWCustomTextRange alloc] initWithStartOffset:0 endOffset:0];
    self.font = [UIFont systemFontOfSize:20.0];
    self.caretWidth = 2.0;
}

- (CGSize)intrinsicContentSize {
    CGSize size = [self.labelText sizeWithAttributes:self.attributes];
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.labelText attributes:self.attributes];
    [attributedString drawInRect:rect];
}


-(BOOL)canBecomeFirstResponder {
    return YES;
}



#pragma mark- UITextInput 协议
//根据range获取当前字符串
- (nullable NSString *)textInRange:(UITextRange *)range {
    
    KWCustomTextPosition *rangeStart = (KWCustomTextPosition *)range.start;
    KWCustomTextPosition *rangeEnd = (KWCustomTextPosition *)range.end;
    
    NSInteger location = MAX(rangeStart.offset, 0);
    NSInteger length = MAX(MIN(self.labelText.length - location, rangeEnd.offset - location), 0);
    
    if (location < self.labelText.length) {
        // TODO: - (lg)  加容错
        NSRange textRange = NSMakeRange(location, length);
        NSString *substring = [self subStringFromLine:self.labelText range:textRange];
        [self inputTextLog:[NSString stringWithFormat:@"1---textInRange -- %@",substring]];
        return substring;
    }
    [self inputTextLog:[NSString stringWithFormat:@"1null---textInRange"]];
    return nil;
}
- (void)replaceRange:(UITextRange *)range withText:(NSString *)text {
}


//当前选择区域get方法
- (UITextRange *)selectedTextRange {
    [self inputTextLog:[NSString stringWithFormat:@"3---selectedTextRange"]];
    return self.currentSelectedTextRange;
}
//当前选择区域set
- (void)setSelectedTextRange:(UITextRange *)selectedTextRange {
    KWCustomTextRange *customRange = (KWCustomTextRange *)selectedTextRange;
    [self inputTextLog:[NSString stringWithFormat:@"4---setSelectedTextRange - %ld, %ld", customRange.startOffset, customRange.endOffset]];
    
    self.currentSelectedTextRange = selectedTextRange;
}

-(UITextRange *)markedTextRange {
    [self inputTextLog:[NSString stringWithFormat:@"5---markedTextRange"]];
    return nil;
}
-(NSDictionary<NSAttributedStringKey,id> *)markedTextStyle {
    [self inputTextLog:[NSString stringWithFormat:@"6---markedTextStyle"]];
    return self.attributes;
}
-(void)setMarkedTextStyle:(NSDictionary<NSAttributedStringKey,id> *)markedTextStyle {
    [self inputTextLog:[NSString stringWithFormat:@"7---setMarkedTextStyle"]];
    self.attributes = markedTextStyle;
}

- (void)setMarkedText:(nullable NSString *)markedText selectedRange:(NSRange)selectedRange {
    [self inputTextLog:[NSString stringWithFormat:@"8---setMarkedText:(nullable NSString *)markedText selectedRange:(NSRange)selectedRange"]];
}
- (void)unmarkText {
    [self inputTextLog:[NSString stringWithFormat:@"9---unmarkText"]];
}

//起始触摸时，设置的起点position
-(UITextPosition *)beginningOfDocument {
    [self inputTextLog:[NSString stringWithFormat:@"10---beginningOfDocument"]];
    return [[KWCustomTextPosition alloc]initWithOffset:0];
}

//起始触摸式。设置的终点position
-(UITextPosition *)endOfDocument {
    [self inputTextLog:[NSString stringWithFormat:@"11---endOfDocument"]];
    return [[KWCustomTextPosition alloc]initWithOffset:self.labelText.length];
}


//根据两个position获取range
- (UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition {
    KWCustomTextPosition *customFromPosition = (KWCustomTextPosition *)fromPosition;
    KWCustomTextPosition *customToPosition = (KWCustomTextPosition *)toPosition;
    [self inputTextLog:[NSString stringWithFormat:@"12---textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition - %ld - %ld",customFromPosition.offset, customToPosition.offset]];
    
    if (customFromPosition && customToPosition) {
        return [[KWCustomTextRange alloc] initWithStartOffset:customFromPosition.offset endOffset:customToPosition.offset];
    }
    
    return nil;
}
//根据position和offset获取新的position，然后调用textRangeFromPosition:toPosition:方法获取range
- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset {
    KWCustomTextPosition *customPosition = (KWCustomTextPosition *)position;
    
    if (customPosition) {
        NSInteger proposedIndex = customPosition.offset + offset;
        
        // Return nil if proposed index is out of bounds, per documentation
        if (proposedIndex >= 0 && proposedIndex <= self.labelText.length) {
            [self inputTextLog:[NSString stringWithFormat:@"13---positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset-- %ld -- %ld -- %ld",customPosition.offset,offset,proposedIndex]];
            return [[KWCustomTextPosition alloc] initWithOffset:proposedIndex];
        }
    }
    [self inputTextLog:[NSString stringWithFormat:@"13null---positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset-- %ld -- %ld",customPosition.offset,offset]];
    return nil;
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset {
    [self inputTextLog:[NSString stringWithFormat:@"14---positionFromPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset"]];
    KWCustomTextPosition *customPosition = (KWCustomTextPosition *)position;
    
    if (customPosition) {
        NSInteger proposedIndex = customPosition.offset;
        
        if (direction == UITextLayoutDirectionLeft) {
            proposedIndex -= offset;
        } else if (direction == UITextLayoutDirectionRight) {
            proposedIndex += offset;
        }
        
        // Return nil if proposed index is out of bounds
        if (proposedIndex >= 0 && proposedIndex <= self.labelText.length) {
            return [[KWCustomTextPosition alloc] initWithOffset:proposedIndex];
        }
    }
    
    return nil;
}
- (NSComparisonResult)comparePosition:(UITextPosition *)position toPosition:(UITextPosition *)other {
    KWCustomTextPosition *customPosition = (KWCustomTextPosition *)position;
    KWCustomTextPosition *otherCustomPosition = (KWCustomTextPosition *)other;
    [self inputTextLog:[NSString stringWithFormat:@"15---comparePosition:(UITextPosition *)position toPosition:(UITextPosition *)other --%ld -- %ld",customPosition.offset,otherCustomPosition.offset]];
    
    if (customPosition && otherCustomPosition) {
        if (customPosition.offset < otherCustomPosition.offset) {
            return NSOrderedAscending;
        } else if (customPosition.offset > otherCustomPosition.offset) {
            return NSOrderedDescending;
        }
    }
    
    return NSOrderedSame;
}
//根据两个position获取offset
- (NSInteger)offsetFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition {
    KWCustomTextPosition *fromCustomPosition = (KWCustomTextPosition *)fromPosition;
    KWCustomTextPosition *toCustomPosition = (KWCustomTextPosition *)toPosition;
    [self inputTextLog:[NSString stringWithFormat:@"16---offsetFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition - %ld -- %ld", fromCustomPosition.offset, toCustomPosition.offset]];
    if (fromCustomPosition && toCustomPosition) {
        return toCustomPosition.offset - fromCustomPosition.offset;
    }
    [self inputTextLog:[NSString stringWithFormat:@"16---offsetFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition"]];
    return 0;
}

-(id<UITextInputDelegate>)inputDelegate {
    [self inputTextLog:[NSString stringWithFormat:@"17---inputDelegate"]];
    return self.m_inputDelegate;
}

-(void)setInputDelegate:(id<UITextInputDelegate>)inputDelegate {
    [self inputTextLog:[NSString stringWithFormat:@"18---setInputDelegate"]];
    self.m_inputDelegate = inputDelegate;
}

- (id<UITextInputTokenizer>)tokenizer {
    [self inputTextLog:[NSString stringWithFormat:@"19---tokenizer"]];
    return [[UITextInputStringTokenizer alloc] initWithTextInput:self];
}


- (nullable UITextPosition *)positionWithinRange:(UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction {
    [self inputTextLog:[NSString stringWithFormat:@"20---positionWithinRange:(UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction"]];
    KWCustomTextPosition *startPosition = (KWCustomTextPosition *)range.start;
    KWCustomTextPosition *endPosition = (KWCustomTextPosition *)range.end;
    
    BOOL isStartFirst = [self comparePosition:startPosition toPosition:endPosition] == NSOrderedAscending;
    
    switch (direction) {
        case UITextLayoutDirectionLeft:
        case UITextLayoutDirectionUp:
            return isStartFirst ? startPosition : endPosition;
        case UITextLayoutDirectionRight:
        case UITextLayoutDirectionDown:
            return isStartFirst ? endPosition : startPosition;
        default:
            [NSException raise:NSGenericException format:@"Unknown UITextLayoutDirection"];
            return nil;
    }
}

- (nullable UITextRange *)characterRangeByExtendingPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction {
    [self inputTextLog:[NSString stringWithFormat:@"21---characterRangeByExtendingPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction"]];
    KWCustomTextPosition *textPosition = (KWCustomTextPosition *)position;
    
    switch (direction) {
        case UITextLayoutDirectionLeft:
        case UITextLayoutDirectionUp:
            return [[KWCustomTextRange alloc] initWithStartOffset:0 endOffset:textPosition.offset];
        case UITextLayoutDirectionRight:
        case UITextLayoutDirectionDown:
            return [[KWCustomTextRange alloc] initWithStartOffset:textPosition.offset endOffset:self.labelText.length];
        default:
            [NSException raise:NSGenericException format:@"Unknown UITextLayoutDirection"];
            return nil;
    }
}

/* Writing direction */
- (NSWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction {
    [self inputTextLog:[NSString stringWithFormat:@"22---baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction"]];
    return NSWritingDirectionNatural; // Only support natural alignment
}
- (void)setBaseWritingDirection:(NSWritingDirection)writingDirection forRange:(UITextRange *)range {
    // Only support natural alignment
    [self inputTextLog:[NSString stringWithFormat:@"23---setBaseWritingDirection:(NSWritingDirection)writingDirection forRange:(UITextRange *)range"]];
}

/* Geometry used to provide, for example, a correction rect. */
- (CGRect)firstRectForRange:(UITextRange *)range {
    [self inputTextLog:[NSString stringWithFormat:@"24---firstRectForRange:(UITextRange *)range"]];
    return CGRectZero;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    KWCustomTextPosition *positionT = (KWCustomTextPosition *)position;
    [self inputTextLog:[NSString stringWithFormat:@"25---caretRectForPosition:(UITextPosition *)position  %ld",positionT.offset]];
    return CGRectZero; //不需要光标
}

//根据range生成部分选择区域数组（由涉及行数决定数组数量）
- (NSArray<UITextSelectionRect *> *)selectionRectsForRange:(UITextRange *)range {
//    range = self.currentSelectedTextRange;
    KWCustomTextPosition *rangeStart = (KWCustomTextPosition *)range.start;
    KWCustomTextPosition *rangeEnd = (KWCustomTextPosition *)range.end;
    [self inputTextLog:[NSString stringWithFormat:@"26---selectionRectsForRange:(UITextRange *)range - start:%ld end:%ld",rangeStart.offset,rangeEnd.offset]];
    
    //获取当前view所有行文本数组（包含因换行符导致的行文本，也包含因宽度不够需要换行的行文本，所以外部传入数组需严格此规则来传入，否则会导致选择不准确）
//    NSArray<NSString *> *lines = [self linesFromString:self.labelText];
    NSArray *lineTextArr  = [self getLinesTextFromLinesInfo:nil];
    NSArray *lineFrameArr = [self getLinesFrameFromLinesInfo:nil];
    NSArray *lineAttriArr = [self getLinesAttrisFromLinesInfo:nil];
    int count = (int)MIN(MIN(lineTextArr.count, lineFrameArr.count), lineAttriArr.count);
    
    //获取range区域下的“开始行”和“结束行”（全闭包：比如0和3，则表示选中区域包含前四行）
    NSInteger startLineIndex = [[[self indexAndLineFromPosition:rangeStart] objectAtIndex:1] unsignedIntegerValue];
    NSInteger endLineIndex = [[[self indexAndLineFromPosition:rangeEnd] objectAtIndex:1] unsignedIntegerValue];
    
    //获取range区域下的文字开始和结束索引（0开始，半闭包。比如0-1获取的是第一个字符，1-2获取第二个字符）
    NSUInteger startTextIndex = [self stringIndexFromPosition:rangeStart];
    NSUInteger endTextIndex = [self stringIndexFromPosition:rangeEnd];
    
    // 当前行开始和结束索引（0开始）
    NSUInteger curLineStart = 0;
    NSUInteger curLineEnd = 0;
    NSMutableArray<KWCustomTextSelectionRect *> *selectionRects = [NSMutableArray array];
    for (NSInteger index = 0; index < count; index++) {
        NSString *line = lineTextArr[index];
        curLineEnd += line.length;      //赋值当前行结束索引
        
        //检测当前行是否在选中区域，并且长度是否合法
        if (line.length && index >= startLineIndex && index <= endLineIndex) {
            BOOL containsStart = startTextIndex >= curLineStart && startTextIndex <= curLineEnd;
            BOOL containsEnd = endTextIndex >= curLineStart && endTextIndex <= curLineEnd;
            
            //获取当前选中区域在当前行的“有效区域”
            NSUInteger selectionLineStartIndex = MAX(startTextIndex, curLineStart);
            NSUInteger selectionLineEndIndex   = MAX(MIN(endTextIndex, curLineEnd), selectionLineStartIndex);
            // TODO: - (lg) 加容错
            NSRange range = NSMakeRange((selectionLineStartIndex - curLineStart), (selectionLineEndIndex - selectionLineStartIndex));
            NSString *actualSubstring = [self subStringFromLine:line range:range];
            CGSize actualSize = [[NSAttributedString alloc] initWithString:actualSubstring attributes:lineAttriArr[index]].size;
            
            //获取X坐标偏移量
            CGFloat initialXPosition = 0;
            if (containsStart) {
                NSString *preSubstring = [line substringToIndex:startTextIndex - curLineStart];
                CGSize preSize = [[NSAttributedString alloc] initWithString:preSubstring attributes:lineAttriArr[index]].size;
                initialXPosition = preSize.width;
            }
            
            CGFloat rectWidth = actualSize.width;
            
            //构造当前行选中rect
            NSString *frame = lineFrameArr[index];
            CGRect rectT = CGRectFromString(frame);
//            CGRect rect = CGRectMake(initialXPosition, index * (self.font.lineHeight + 6), rectWidth, (self.font.lineHeight + 6));
            CGRect rect = CGRectMake(initialXPosition + rectT.origin.x, rectT.origin.y, rectWidth, rectT.size.height);
            KWCustomTextSelectionRect *selectionRect = [[KWCustomTextSelectionRect alloc] initWithRect:rect writingDirection:NSWritingDirectionLeftToRight containsStart:containsStart containsEnd:containsEnd isVertical:NO];
            [selectionRects addObject:selectionRect];
        }
        curLineStart += line.length;
    }
    
    
    for (UITextSelectionRect *rect in [selectionRects copy]) {
        [self inputTextLog:[NSString stringWithFormat:@"26.1---selectionRectsForRange:(UITextRange *)range - rect:%@",NSStringFromCGRect(rect.rect)]];
    }
    //返回部分选择区域数组（由涉及行数决定数组数量）
    return [selectionRects copy];
}

//获取靠近触摸点的UITextPosition
- (UITextPosition *)closestPositionToPoint:(CGPoint)point {
    
    NSArray *lineTextArr  = [self getLinesTextFromLinesInfo:nil];
    NSArray *lineFrameArr = [self getLinesFrameFromLinesInfo:nil];
    NSArray *lineAttriArr = [self getLinesAttrisFromLinesInfo:nil];
    int count = (int)MIN(MIN(lineTextArr.count, lineFrameArr.count), lineAttriArr.count);
    NSString *currentLine = @"";
    NSInteger curLineLoc = 0;
    if (lineTextArr.count) {
        NSInteger lineIndex = 0;    //如果下面找不到所在行，则默认为第一行
        if (point.y > 20) {
            lineIndex = count - 1;  //如果触摸点大于20，下面未找到所在行时，默认为最后一行
        }
        currentLine = lineTextArr[lineIndex];
        NSDictionary *currentAttri = lineAttriArr[lineIndex];
        CGRect currentRect = CGRectFromString(lineFrameArr[lineIndex]);
        
        for (int i = 0; i < count; i++) {
            NSString *frame = lineFrameArr[i];
            CGRect rect = CGRectFromString(frame);
            CGFloat lineOriginY = rect.origin.y;
            CGFloat lineHeight = rect.size.height;
            
            //寻找触摸点所在行
            if (point.y >= lineOriginY && point.y <= lineOriginY + lineHeight) {
                lineIndex = i;
                currentLine = lineTextArr[i];
                currentAttri = lineAttriArr[i];
                currentRect = CGRectFromString(lineFrameArr[i]);
                break;
            }
        }
        
        curLineLoc = [self currentLineLocation:lineIndex];
        //获取当前遍历到的字符宽度，和触摸点x坐标做比较
        CGFloat totalWidth = currentRect.origin.x;
        for (NSInteger index = 0; index < [currentLine length]; index++) {
            NSString *character = [self subStringFromLine:currentLine range:NSMakeRange(index, 1)];
            CGSize characterSize = [[NSAttributedString alloc] initWithString:character attributes:currentAttri].size;
            
            //根据触摸点X坐标判断最近的position
            if (totalWidth <= point.x && point.x < totalWidth + characterSize.width) {
                //触摸点x坐标超过右边字符宽度一半时，返回下一个position
                NSInteger offset = (point.x - totalWidth > characterSize.width / 2.0) ? index + 1 : index;
                [self inputTextLog:[NSString stringWithFormat:@"27寻找距离point最近position---closestPositionToPoint:(CGPoint)point: %.2f %.2f --- %ld",point.x, point.y,curLineLoc + offset]];
                return [[KWCustomTextPosition alloc] initWithOffset:curLineLoc + offset];
            } else {
                totalWidth = totalWidth + characterSize.width;
            }
        }
    }

    [self inputTextLog:[NSString stringWithFormat:@"27null---closestPositionToPoint:(CGPoint)point: %.2f %.2f",point.x, point.y]];
    NSInteger offset = 0;
    // TODO: - (lg) 待优化。根据point看如何寻找默认值（200和80后续需调整为label实际尺寸）
    if (point.x >= 200) {
        //上面未找到时，且x坐标大于200，则offset默认为当前触摸行的最左边
        offset = curLineLoc + currentLine.length;
        [self inputTextLog:[NSString stringWithFormat:@"27null---closestPositionToPoint:(CGPoint)point: %.2f %.2f --- %ld --- %ld --- %@",point.x, point.y,offset,curLineLoc,currentLine]];
    }
    if (point.y >= 105) {
        //如果上面未找到距离触摸点最近position，根据触摸点位置决定是否为末尾position
        offset = self.labelText.length;
    }
    return [[KWCustomTextPosition alloc] initWithOffset:offset];
}

//在range区域内获取靠近触摸点的UITextPosition
- (UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(UITextRange *)range {
    [self inputTextLog:[NSString stringWithFormat:@"28---closestPositionToPoint:(CGPoint)point withinRange:(UITextRange *)range"]];
    KWCustomTextPosition *proposedPosition = (KWCustomTextPosition *)[self closestPositionToPoint:point];
    KWCustomTextPosition *rangeStart = (KWCustomTextPosition *)[range start];
    KWCustomTextPosition *rangeEnd = (KWCustomTextPosition *)[range end];
    
    if (!proposedPosition || !rangeStart || !rangeEnd) {
        return nil;
    }
    
    NSInteger maxProposedPositionOffsetAndRangeStart = MAX(proposedPosition.offset, rangeStart.offset);
    NSInteger offset = MIN(maxProposedPositionOffsetAndRangeStart, rangeEnd.offset);
    
    return [[KWCustomTextPosition alloc] initWithOffset:offset];
}

- (UITextRange *)characterRangeAtPoint:(CGPoint)point {
    [self inputTextLog:[NSString stringWithFormat:@"29---characterRangeAtPoint:(CGPoint)point"]];
    KWCustomTextPosition *textPosition = (KWCustomTextPosition *)[self closestPositionToPoint:point];
    if (!textPosition) {
        return nil;
    }
    return [[KWCustomTextRange alloc] initWithStartOffset:textPosition.offset endOffset:textPosition.offset + 1];
}

#pragma mark- UIKeyInput
-(BOOL)hasText {
    [self inputTextLog:[NSString stringWithFormat:@"30---"]];
    return self.labelText.length > 0;
}
-(void)insertText:(NSString *)text {
    [self inputTextLog:[NSString stringWithFormat:@"31---"]];
}
-(void)deleteBackward {
    [self inputTextLog:[NSString stringWithFormat:@"32---"]];
}

#pragma mark- Helper
//根据position获取距离最近的文本行，以及该行的索引
- (NSArray *)indexAndLineFromPosition:(UITextPosition *)position {
    //获取当前position的索引坐标
    NSUInteger labelTextPositionIndex = [self stringIndexFromPosition:position];
    
    //获取当前所有文本行
    NSArray<NSString *> *lines = [self getLinesTextFromLinesInfo:nil];//[self linesFromString:self.labelText];
    
    if (!lines.count) {
        return @[@"",@(0)];
    }
    
    //记录当前行起始索引
    __block NSUInteger currentLoc = 0;
    NSUInteger lineIndex = [lines indexOfObjectPassingTest:^BOOL(NSString *line, NSUInteger idx, BOOL *stop) {
        NSRange range = NSMakeRange(currentLoc, line.length);
        currentLoc += line.length;
        //校验当前position的索引坐标是否属于当前行，属于就返回lineIndex
        return (labelTextPositionIndex >= range.location) && (labelTextPositionIndex < NSMaxRange(range));
    }];
    if (lineIndex == NSNotFound) {
        // 未找到时，如果labelTextPositionIndex大于currentLoc，则返回最后一行
        if (currentLoc > 0 && labelTextPositionIndex >= currentLoc) {
            lineIndex = lines.count - 1;
        }else {
            lineIndex = 0;
        }
    }
    return @[ lines[lineIndex], @(lineIndex) ];
}

//获取当前position的偏移索引
- (NSUInteger)stringIndexFromPosition:(UITextPosition *)position {
    KWCustomTextPosition *customPosition = (KWCustomTextPosition *)position;
    if (!customPosition) {
        // Handle error
        return 0;
    }
    
    // Turn our text position into an index into `labelText`
    NSInteger offset = MAX(customPosition.offset, 0);
    return offset;
}

//计算当前行的loc
- (NSUInteger)currentLineLocation:(NSUInteger)lineIndex {
    NSInteger curLineLoc = 0;
//    NSArray<NSString *> *lines = [self linesFromString:self.labelText];
    NSArray<NSString *> *lines = [self getLinesTextFromLinesInfo:nil];
    for (NSInteger index = 0; index < lineIndex; index++) {
        NSString *line = lines[index];
        curLineLoc += line.length;
    }
    return curLineLoc;
}

//根据文本和range获取子串
- (NSString *)subStringFromLine:(NSString *)line range:(NSRange)range {
    NSString *subString = @"";
    if (NSMaxRange(range) <= line.length) {
        subString = [line substringWithRange:range];
    }
    return subString;
}

- (NSArray<NSDictionary *> *)getLinesInfoArrayWithAtti:(nullable NSAttributedString *)attributedString constainedToSize:(CGSize)size {
//    return @[];
//    NSLog(@"调用次数--- %ld",testCount);
    testCount++;
    if (!attributedString) {
        attributedString = [[NSAttributedString alloc] initWithString:self.labelText attributes:self.attributes];
    }
    if (size.width == 0 || size.height == 0) {
        size = CGSizeMake(self.frame.size.width, MAXFLOAT);
    }
    
    NSString *text = [attributedString string];
    if ([text length] < 1) {
        return @[];
    }
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CTFrameRef ctFrame;
    CGRect frameRect;
    CFRange rangeAll = CFRangeMake(0, text.length);

    
    // Measure how mush specec will be needed for this attributed string
    // So we can find minimun frame needed
    CFRange fitRange;
    CGSize s = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, rangeAll, NULL, CGSizeMake(size.width, MAXFLOAT), &fitRange);

//    return @[];
    
    frameRect = CGRectMake(0, 0, s.width, s.height);
    CGPathRef framePath = CGPathCreateWithRect(frameRect, NULL);
    ctFrame = CTFramesetterCreateFrame(framesetter, rangeAll, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the lines in our frame
    NSArray* lines = (NSArray*)CTFrameGetLines(ctFrame);
    NSUInteger lineCount = [lines count];
    
//    CGPoint *lineOrigins = malloc(sizeof(CGPoint) * lineCount);
    CGRect *lineFrames = malloc(sizeof(CGRect) * lineCount);

    CGFloat originY = 0;
    CGFloat originX = 0;
    BOOL previousLineContainsLinebreak = NO;    //上一行是否包含换行符
    NSMutableArray <NSDictionary *>*arr = [NSMutableArray arrayWithCapacity:lineCount];
    // Loop throught the lines
    for(CFIndex i = 0; i < lineCount; ++i) {
        
        CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
        
        CFRange lineRange = CTLineGetStringRange(line);

//        CGPoint lineOrigin = lineOrigins[i];
        CGFloat ascent, descent, leading;
        CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
//        CGFloat lineHeight = ascent + descent + leading;
        
        
        NSRange nsRange = NSMakeRange(lineRange.location, lineRange.length);
        NSAttributedString *attributedSubstring = [attributedString attributedSubstringFromRange:nsRange];
        NSString *lineString = [text substringWithRange:NSMakeRange(lineRange.location, lineRange.length)];
        
        UIFont *font = [attributedSubstring attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
        CGFloat lineHeight = font.lineHeight;
        
        
        // 获取行间距增量（通过CTParagraphStyle获取行间距信息）
        CTParagraphStyleRef paragraphStyle = (__bridge CTParagraphStyleRef)[attributedSubstring attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
        CGFloat paragraphSpacing = 0;
        CGFloat paragraphSpacingBefore = 0;
        CGFloat lineSpacing = 0;
        CGFloat firstLineHeadIndent = 0;
        CGFloat headIndent = 0;
        CTTextAlignment alignment = kCTTextAlignmentLeft;
        NSArray <NSTextTab *>*tabsArr = [NSArray array];
        if (paragraphStyle) {
            CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing);
            CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore);
            CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing);
            CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierAlignment, sizeof(CGFloat), &alignment);
            CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent);
            CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent);
            CFArrayRef tabStopsCF;
            CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef), &tabStopsCF);
            if (tabStopsCF != NULL) {
                tabsArr = (__bridge NSArray *)tabStopsCF;
            }
            
            //将行间距增量添加到下一行的行高
            if (lineSpacing > 0 && i > 0) {
                lineHeight += lineSpacing;
            }
            
            //将段间距增量添加到下一行的行高
            if (i > 0 && previousLineContainsLinebreak) {
                lineHeight += paragraphSpacing;
                lineHeight += paragraphSpacingBefore;
            }
            
            //处理首行和次行缩进（X坐标）
            if (i == 0 || previousLineContainsLinebreak) {
                //首行
                originX = firstLineHeadIndent;
            }else {
                originX = headIndent;
            }
            
            //重置标志位（上一行是否有换行符）
            if (previousLineContainsLinebreak) {
                previousLineContainsLinebreak = NO;
            }
            
            if ([lineString containsString:@"\n"]) {
                previousLineContainsLinebreak = YES;
            }
        }
//        return @[];
        lineFrames[i].origin = CGPointMake(originX, originY);
        lineFrames[i].size = CGSizeMake(lineWidth, lineHeight);
        originY += lineHeight;
        
        NSMutableParagraphStyle *paragraphStyleT = [[NSMutableParagraphStyle alloc]init];
        paragraphStyleT.lineSpacing = lineSpacing;
        paragraphStyleT.paragraphSpacingBefore = paragraphSpacingBefore;
        paragraphStyleT.paragraphSpacing = paragraphSpacing;
        paragraphStyleT.tabStops = tabsArr;
        
        NSDictionary *attributes = @{
            NSForegroundColorAttributeName: [UIColor labelColor],
            NSBackgroundColorAttributeName: [UIColor systemBackgroundColor],
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraphStyleT,
        };
        
        NSDictionary *dict = @{@"line":lineString ? : @"",
                               @"attributes":attributes ? : @{},
                               @"lineFrame":NSStringFromCGRect(lineFrames[i]),
                             };
        [arr addObject:dict];
    }
    
    //free stuff
//    free(lineOrigins);
    free(lineFrames);
    
    CFRelease(framesetter);
    CFRelease(ctFrame);

    
    return arr;
}

//根据linesInfo遍历出文本行数组
- (NSArray<NSString *> *)getLinesTextFromLinesInfo:(nullable NSArray <NSDictionary *>*)linesInfo {
    
    if (self.lineArr.count) {
        return self.lineArr;
    }
    
    if (linesInfo.count == 0) {
        linesInfo = [self getLinesInfoArrayWithAtti:nil constainedToSize:CGSizeMake(0, 0)];
    }
    NSMutableArray *lineArr = [NSMutableArray arrayWithCapacity:linesInfo.count];
    for (NSDictionary *dict in linesInfo) {
        [lineArr addObject:[dict valueForKey:@"line"] ? : @""];
    }
    self.lineArr = [NSMutableArray arrayWithArray:lineArr];
    return lineArr;
}
//根据linesInfo遍历出Attri数组
- (NSArray<NSDictionary<NSAttributedStringKey, id> *> *)getLinesAttrisFromLinesInfo:(nullable NSArray <NSDictionary *>*)linesInfo {
    
    if (self.attriArr.count) {
        return self.attriArr;
    }
    if (linesInfo.count == 0) {
        linesInfo = [self getLinesInfoArrayWithAtti:nil constainedToSize:CGSizeMake(0, 0)];
    }
    NSMutableArray <NSDictionary<NSAttributedStringKey, id> *>*attriArr = [NSMutableArray arrayWithCapacity:linesInfo.count];
    for (NSDictionary *dict in linesInfo) {
        [attriArr addObject:[dict valueForKey:@"attributes"] ? : @{}];
    }
    self.attriArr = [NSMutableArray arrayWithArray:attriArr];
    return attriArr;
}
//根据linesInfo遍历出文本行frame数组
- (NSArray<NSString *> *)getLinesFrameFromLinesInfo:(nullable NSArray <NSDictionary *>*)linesInfo {
    if (self.lineframeArr.count) {
        return self.lineframeArr;
    }
    if (linesInfo.count == 0) {
        linesInfo = [self getLinesInfoArrayWithAtti:nil constainedToSize:CGSizeMake(0, 0)];
    }
    NSMutableArray *lineFrameArr = [NSMutableArray arrayWithCapacity:linesInfo.count];
    for (NSDictionary *dict in linesInfo) {
        [lineFrameArr addObject:[dict valueForKey:@"lineFrame"] ? : NSStringFromCGRect(CGRectMake(0, 0, 0, 0))];
    }
    self.lineframeArr = [NSMutableArray arrayWithArray:lineFrameArr];
    return lineFrameArr;
}

#pragma mark- Log
- (void)inputTextLog:(NSString *)text {
//    if (![text containsString:@"27寻找距离"] && ![text containsString:@"1---textInRange"] && ![text containsString:@"4---setSelectedTextRange"] && ![text containsString:@"26---selectionRectsForRange"]) {
//        return;
//    }
    
    if (![text containsString:@"27null---closestPositionToPoint"]) {
        return;
    }
    NSLog(@"%@",text);
}

@end
