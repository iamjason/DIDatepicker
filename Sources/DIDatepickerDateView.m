//
//  Created by Dmitry Ivanenko on 15.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import "DIDatepickerDateView.h"


const CGFloat kDIDatepickerItemWidth = 48.;
const CGFloat kDIDatepickerSelectionLineWidth = 55.;


@interface DIDatepickerDateView ()

@property (strong, nonatomic) UILabel *dateLabel;
@property (nonatomic, strong) UIView *selectionView;

@end


@implementation DIDatepickerDateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self setupViews];

    return self;
}

- (void)setupViews
{
    [self addTarget:self action:@selector(dateWasSelected) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDate:(NSDate *)date
{
    _date = date;
  [self updateLabelUI];
  
}

- (void)updateLabelUI {
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  
  [dateFormatter setDateFormat:@"dd"];
  NSString *dayFormattedString = [dateFormatter stringFromDate:_date];
  
  [dateFormatter setDateFormat:@"EEE"];
  NSString *dayInWeekFormattedString = [dateFormatter stringFromDate:_date];
  dayInWeekFormattedString = [dayInWeekFormattedString uppercaseString];
  
  [dateFormatter setDateFormat:@"MMM"];
  NSString *monthFormattedString = [[dateFormatter stringFromDate:_date] uppercaseString];
  
  NSString *str = [NSString stringWithFormat:@"%@\n%@\n%@", dayInWeekFormattedString, dayFormattedString, monthFormattedString];
  
  NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:str];
  
  UIColor *dateColor;
  if (_isSelected) {
    dateColor = [UIColor whiteColor];
    // UIColor(red: 0.357, green: 0.769, blue: 0.749, alpha: 1.000)
    self.selectionView.backgroundColor = [UIColor colorWithRed:0.357 green:0.769 blue:0.749 alpha:1.0];
  } else {
    dateColor = [UIColor grayColor];
    self.selectionView.backgroundColor = [UIColor whiteColor];
  }
  self.selectionView.alpha = 1.0;
  
  [dateString addAttributes:@{
                              NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:10],
                              NSForegroundColorAttributeName: dateColor
                              }
                      range:[str rangeOfString:dayInWeekFormattedString]];
  
  [dateString addAttributes:@{
                              NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:22],
                              NSForegroundColorAttributeName: dateColor
                              }
                      range:[str rangeOfString:dayFormattedString]];
  
  [dateString addAttributes:@{
                              NSFontAttributeName: [UIFont fontWithName:@"ProximaNova-Semibold" size:10],
                              NSForegroundColorAttributeName: dateColor
                              }
                      range:[str rangeOfString:monthFormattedString]];
  
  //    if ([self isWeekday:date]) {
  //        [dateString addAttribute:NSFontAttributeName
  //                           value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:8]
  //                           range:NSMakeRange(dayFormattedString.length + 1, dayInWeekFormattedString.length)];
  //    }
  
  self.dateLabel.attributedText = dateString;
  
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;

//
//  self.selectionView.alpha = (int)_isSelected;
  [self updateLabelUI];
  
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dateLabel.numberOfLines = 3;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dateLabel];
    }

    return _dateLabel;
}

- (UIView *)selectionView
{
    if (!_selectionView) {
        _selectionView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 51) / 2, 12, 52, 56)];
        _selectionView.alpha = 0;
      _selectionView.backgroundColor = [UIColor greenColor];
      _selectionView.userInteractionEnabled = false;
      
      [self insertSubview:_selectionView atIndex:0];
    }

    return _selectionView;
}

- (void)setItemSelectionColor:(UIColor *)itemSelectionColor
{
    self.selectionView.backgroundColor = itemSelectionColor;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
  
  
    if (highlighted) {
        self.selectionView.alpha = self.isSelected ? 1 : .5;
    } else {
        self.selectionView.alpha = self.isSelected ? 1 : 0.5;
    }
  
  //[self updateLabelUI];
  
}

//-(void)setSelected:(BOOL)selected {
//  [super setSelected:selected];
//  [self updateLabelUI];
//}

#pragma mark Other methods

- (BOOL)isWeekday:(NSDate *)date
{
    NSInteger day = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date] weekday];

    const NSInteger kSunday = 1;
    const NSInteger kSaturday = 7;

    BOOL isWeekdayResult = day == kSunday || day == kSaturday;

    return isWeekdayResult;
}

- (void)dateWasSelected
{
    self.isSelected = YES;
  [self updateLabelUI];
  
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
