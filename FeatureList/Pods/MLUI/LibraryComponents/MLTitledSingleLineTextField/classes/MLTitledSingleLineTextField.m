//
// MLTextFieldWithLabel.m
// MLUI
//
// Created by Juan Andres Gebhard on 5/5/16.
// Copyright © 2016 MercadoLibre. All rights reserved.
//

#import "MLTitledSingleLineTextField.h"
#import "UIFont+MLFonts.h"
#import "MLUIBundle.h"
#import "MLStyleSheetManager.h"
#import "MLTitledSingleLineStringProvider.h"
#import "MLUITextField.h"

static const CGFloat kMLTextFieldThinLine = 1;
static const CGFloat kMLTextFieldThickLine = 2;

@interface MLTitledSingleLineTextField () <UITextFieldDelegate, MLUITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *helperDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIView *textInputContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;
@property (weak, nonatomic) IBOutlet UIView *accessoryViewContainer;

@property (strong, nonatomic) MLUITextField *textField;
@property (copy, nonatomic) NSString *textCache;

@property (weak, nonatomic) UIView *prefixContainer;
@property (weak, nonatomic) UILabel *prefixLabel;
@property (weak, nonatomic) NSLayoutConstraint *prefixToTextContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeholderLeadingConstraint;

@end

@implementation MLTitledSingleLineTextField

@dynamic prefix;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit
{
	[self loadFromNib];
	[self addTextInput];
	[self style];
	[self updateCharacterCount];
	[self observeText];
}

- (void)loadFromNib
{
	NSString *nibName = @"MLTitledLineTextField";
	NSArray *nibArray = [[MLUIBundle mluiBundle] loadNibNamed:nibName
	                                                    owner:self
	                                                  options:nil];
	UIView *view = nibArray.firstObject;
	view.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:view];

	NSDictionary *views = @{@"view" : view};
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|"
	                                                             options:0
	                                                             metrics:nil
	                                                               views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
	                                                             options:0
	                                                             metrics:nil
	                                                               views:views]];
}

- (void)addTextInput
{
	UIView *textInput = self.textInputControl;
	if (!textInput) {
		return;
	}

	textInput.translatesAutoresizingMaskIntoConstraints = NO;
	[self.textInputContainer addSubview:textInput];

	NSDictionary *views = @{@"view" : textInput};
	[self.textInputContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|"
	                                                                                options:0
	                                                                                metrics:nil
	                                                                                  views:views]];
	[self.textInputContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
	                                                                                options:0
	                                                                                metrics:nil
	                                                                                  views:views]];
}

- (void)style
{
	self.textField.font = [UIFont ml_regularSystemFontOfSize:kMLFontsSizeMedium];
	self.titleLabel.font = [UIFont ml_regularSystemFontOfSize:kMLFontsSizeXSmall];
	self.titleLabel.textColor = MLStyleSheetManager.styleSheet.greyColor;
	self.helperDescriptionLabel.font = [UIFont ml_regularSystemFontOfSize:kMLFontsSizeXSmall];
	self.counterLabel.font = [UIFont ml_regularSystemFontOfSize:kMLFontsSizeXSmall];
	self.placeholderLabel.font = [UIFont ml_regularSystemFontOfSize:kMLFontsSizeMedium];
	self.placeholderLabel.textColor = MLStyleSheetManager.styleSheet.greyColor;
	[self stateDependantStyle];
}

- (void)stateDependantStyle
{
	UIColor *textColor = MLStyleSheetManager.styleSheet.blackColor;
	UIColor *lineColor = MLStyleSheetManager.styleSheet.midGreyColor;
	UIColor *labelColor = MLStyleSheetManager.styleSheet.greyColor;
	UIColor *helperDescriptionLabelColor = MLStyleSheetManager.styleSheet.darkGreyColor;
	UIColor *counterLabelColor = MLStyleSheetManager.styleSheet.darkGreyColor;
	CGFloat lineHeight = kMLTextFieldThinLine;

	switch (self.state) {
		case MLTitledTextFieldStateDisabled: {
			textColor = MLStyleSheetManager.styleSheet.midGreyColor;
			labelColor = MLStyleSheetManager.styleSheet.midGreyColor;
			break;
		}

		case MLTitledTextFieldStateEditing: {
			lineColor = MLStyleSheetManager.styleSheet.secondaryColor;
			lineHeight = kMLTextFieldThickLine;
			break;
		}

		case MLTitledTextFieldStateError: {
			lineColor = helperDescriptionLabelColor = MLStyleSheetManager.styleSheet.errorColor;
			lineHeight = kMLTextFieldThickLine;
			break;
		}

		default: {
			lineColor = MLStyleSheetManager.styleSheet.midGreyColor;
			break;
		}
	}

	__weak typeof(self) weakSelf = self;

	[UIView animateWithDuration:.25f animations: ^{
	    weakSelf.placeholderLabel.alpha = weakSelf.text.length ? 0 : 1;
	}];

	[UIView animateWithDuration:.5f animations: ^{
	    weakSelf.textField.textColor = textColor;
	    weakSelf.titleLabel.textColor = labelColor;
	    weakSelf.prefixLabel.textColor = labelColor;
	    weakSelf.lineView.backgroundColor = lineColor;
	    weakSelf.textField.tintColor = lineColor;
	    weakSelf.lineViewHeight.constant = lineHeight;
	    weakSelf.helperDescriptionLabel.textColor = helperDescriptionLabelColor;
	    weakSelf.counterLabel.textColor = counterLabelColor;
	}];
}

- (void)setupInnerTextWithAlignment:(NSTextAlignment)textAlignment
{
	self.placeholderLabel.textAlignment = textAlignment;
	self.titleLabel.textAlignment = textAlignment;
	self.textField.textAlignment = textAlignment;
	self.helperDescriptionLabel.textAlignment = textAlignment;
}

- (void)updateCharacterCount
{
	if (!self.charactersCountVisible) {
		return;
	}

	NSString *countString;
	if (self.maxCharacters) {
		NSString *format = [MLTitledSingleLineStringProvider localizedString:@"CHARACTER_COUNT_FORMAT"];
		countString = [NSString stringWithFormat:format, (unsigned long)self.text.length, (unsigned long)self.maxCharacters];
	} else {
		countString = [NSString stringWithFormat:@"%lu", (unsigned long)self.text.length];
	}

	self.counter = countString;
}

- (void)observeText
{
	[self addObserver:self
	       forKeyPath:NSStringFromSelector(@selector(text))
	          options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
	          context:nil];
}

#pragma mark Custom Setters

- (void)setText:(NSString *)text
{
	if (![self validateLength:text]) {
		return;
	}
	self.textCache = text;
	self.textField.text = text;
	[self style];
}

- (void)setTitle:(NSString *)title
{
	_title = title.copy;
	self.titleLabel.text = title;
	if (![self accessibilityIdentifier]) {
		[self setAccessibilityIdentifier:title];
	}
}

- (void)setHelperDescription:(NSString *)helperDescription
{
	if (self.errorDescription) {
		return;
	}

	_helperDescription = helperDescription;
	self.helperDescriptionLabel.text = _helperDescription;
}

- (void)setCounter:(NSString *)counter
{
	self.counterLabel.text = counter;
}

- (void)setErrorDescription:(nullable NSString *)errorDescription
{
	[self setErrorDescription:errorDescription animated:YES];
}

- (void)setAccessibilityIdentifier:(nullable NSString *)accessibilityIdentifier
{
	[self.textField setAccessibilityIdentifier:accessibilityIdentifier];
}

- (NSString *)accessibilityIdentifier
{
	return self.textField.accessibilityIdentifier;
}

- (void)setErrorDescription:(nullable NSString *)errorDescription animated:(BOOL)animated
{
	if (errorDescription == _errorDescription
	    || [errorDescription isEqualToString:_errorDescription]) {
		return;
	}

	_errorDescription = errorDescription.copy;
	__weak typeof(self) weakSelf = self;

	if (!_errorDescription && self.helperDescription.length) {
		[self updateCharacterCount];
		self.helperDescriptionLabel.text = self.helperDescription;
		return;
	}

	if (!animated) {
		weakSelf.helperDescriptionLabel.text = errorDescription;
	} else {
		[UIView animateWithDuration:0.3 animations: ^{
		    weakSelf.helperDescriptionLabel.text = errorDescription;
		    [weakSelf.helperDescriptionLabel invalidateIntrinsicContentSize];
		    [weakSelf setNeedsLayout];
		    [weakSelf layoutIfNeeded];
		}];
	}

	[self style];
}

- (void)setPlaceholder:(NSString *)placeholder
{
	self.placeholderLabel.text = placeholder;
}

- (void)setEnabled:(BOOL)enabled
{
	[super setEnabled:enabled];
	self.textField.userInteractionEnabled = enabled;
	[self style];
}

- (void)setMaxCharacters:(NSUInteger)maxCharacters
{
	_maxCharacters = maxCharacters;
	[self updateCharacterCount];
}

- (void)setMinCharacters:(NSUInteger)minCharacters
{
	_minCharacters = minCharacters;
}

- (void)setCharactersCountVisible:(BOOL)charactersCountVisible
{
	_charactersCountVisible = charactersCountVisible;
	[self updateCharacterCount];
}

- (void)setAccessoryView:(UIView *)accessoryView
{
	[self.accessoryView removeFromSuperview];
	[accessoryView removeFromSuperview];

	UIView *container = self.accessoryViewContainer;
	_accessoryView = accessoryView;

	if (!accessoryView) {
		return;
	}

	accessoryView.translatesAutoresizingMaskIntoConstraints = NO;

	UILayoutConstraintAxis axis = UILayoutConstraintAxisHorizontal;
	CGFloat contentHugging = [container contentHuggingPriorityForAxis:axis];
	[accessoryView setContentHuggingPriority:contentHugging forAxis:axis];
	CGFloat compressionResistance = [container contentCompressionResistancePriorityForAxis:axis];
	[accessoryView setContentCompressionResistancePriority:compressionResistance forAxis:axis];
	[container addSubview:accessoryView];

	NSDictionary *views = @{@"view" : accessoryView};
	[container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|"
	                                                                  options:0
	                                                                  metrics:nil
	                                                                    views:views]];
	[container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
	                                                                  options:0
	                                                                  metrics:nil
	                                                                    views:views]];
	[self setNeedsLayout];
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
	self.textField.keyboardType = keyboardType;
}

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType
{
	self.textField.autocapitalizationType = autocapitalizationType;
}

- (void)setAutocorrectionType:(UITextAutocorrectionType)autocorrectionType
{
	self.textField.autocorrectionType = autocorrectionType;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
	_secureTextEntry = secureTextEntry;

	self.textField.secureTextEntry = secureTextEntry;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self updatePrefixConstraints];
}

#pragma mark Custom getters

- (NSString *)text
{
	return self.textCache ? : @"";
}

- (UIView <UITextInputTraits, UITextInput> *)textInputControl
{
	if (!self.textField) {
		self.textField = [[MLUITextField alloc] init];
		self.textField.delegate = self;
		self.textField.textFieldDelegate = self;
		[self.textField addTarget:self
		                   action:@selector(textFieldDidChange:)
		         forControlEvents:UIControlEventEditingChanged];
	}
	return self.textField;
}

- (NSString *)placeholder
{
	return self.placeholderLabel.text;
}

- (UIKeyboardType)keyboardType
{
	return self.textField.keyboardType;
}

- (UITextAutocapitalizationType)autocapitalizationType
{
	return self.textField.autocapitalizationType;
}

- (UITextAutocorrectionType)autocorrectionType
{
	return self.textField.autocorrectionType;
}

#pragma mark State handling

- (MLTitledTextFieldState)state
{
	if (!self.isEnabled) {
		return MLTitledTextFieldStateDisabled;
	}
	if (self.errorDescription.length) {
		return MLTitledTextFieldStateError;
	}
	if (self.isFirstResponder) {
		return MLTitledTextFieldStateEditing;
	}
	return MLTitledTextFieldStateNormal;
}

#pragma mark TextViewDelegate

- (void)textFieldDidChange:(UITextField *)textField
{
	self.textCache = textField.text;
	[self sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidBeginEditing:(UITextField *)textView
{
	[self style];
	if ([self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
		[self.delegate textFieldDidBeginEditing:self];
	}
	[self sendActionsForControlEvents:UIControlEventEditingDidBegin];
}

- (void)textFieldDidEndEditing:(UITextField *)textView
{
	[self style];
	if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
		[self.delegate textFieldDidEndEditing:self];
	}
	[self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	BOOL shouldChange = YES;
	NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
	if (![self validateLength:finalString]) {
		shouldChange = NO;
	}

	if (shouldChange && [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
		shouldChange = [self.delegate textField:self shouldChangeCharactersInRange:range replacementString:string];
	}

	if (shouldChange) {
		self.textCache = finalString;
	}

	if ([self.delegate respondsToSelector:@selector(textField:hasMinCharacters:)] && _minCharacters) {
		if ((textField.text.length + (string.length == 0 ? (range.length == 1 ? -1 : -range.length) : string.length)) < self.minCharacters) {
			[self.delegate textField:self hasMinCharacters:NO];
		} else {
			[self.delegate textField:self hasMinCharacters:YES];
		}
	}

	return shouldChange;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	if ([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
		return [self.delegate textFieldShouldBeginEditing:self];
	}
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	if ([self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
		return [self.delegate textFieldShouldEndEditing:self];
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ([self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
		return [self.delegate textFieldShouldReturn:self];
	}
	return YES;
}

#pragma mark MLUITextFieldDelegate

- (void)textFieldDidPressDeleteKey:(MLUITextField *)textField
{
	if ([self.delegate respondsToSelector:@selector(textFieldDidPressDeleteKey:)]) {
		[self.delegate textFieldDidPressDeleteKey:self];
	}
}

#pragma mark UIResponder

- (BOOL)isFirstResponder
{
	return self.textField.isFirstResponder;
}

- (BOOL)becomeFirstResponder
{
	return self.textField.becomeFirstResponder;
}

- (BOOL)canBecomeFirstResponder
{
	return self.textField.canBecomeFirstResponder;
}

- (BOOL)resignFirstResponder
{
	return self.textField.resignFirstResponder;
}

- (BOOL)canResignFirstResponder
{
	return self.textField.canResignFirstResponder;
}

#pragma mark Validations

- (BOOL)validateLength:(NSString *)string
{
	return !(self.maxCharacters && string.length > self.maxCharacters);
}

#pragma mark Prefix

- (NSString *)prefix {
	return self.prefixLabel.text;
}

- (void)setPrefix:(NSString *)prefix {
	if (prefix.length == 0) {
		self.textField.leftView = nil;
		self.textField.leftViewMode = UITextFieldViewModeNever;
		return;
	}

	if (self.prefixContainer) {
		self.prefixLabel.text = prefix;
		[self updatePrefixConstraints];
		return;
	}

	[self initializePrefixContainerWithText:prefix];
}

- (void)initializePrefixContainerWithText:(NSString *)prefix {
	UIView *prefixContainer = [[UIView alloc] init];
	self.prefixContainer = prefixContainer;
	self.prefixContainer.translatesAutoresizingMaskIntoConstraints = NO;

	UILabel *prefixLabel = [[UILabel alloc] init];
	self.prefixLabel = prefixLabel;
	self.prefixLabel.text = prefix;
	self.prefixLabel.font = [UIFont ml_regularSystemFontOfSize:kMLFontsSizeMedium];
	self.prefixLabel.textColor = self.titleLabel.textColor;

	self.prefixLabel.translatesAutoresizingMaskIntoConstraints = NO;

	[self.prefixContainer addSubview:self.prefixLabel];

	NSDictionary *views = @{@"view" : self.prefixLabel};
	self.prefixToTextContraint = [NSLayoutConstraint constraintWithItem:self.prefixContainer
	                                                          attribute:NSLayoutAttributeTrailing
	                                                          relatedBy:NSLayoutRelationEqual
	                                                             toItem:self.prefixLabel
	                                                          attribute:NSLayoutAttributeTrailing
	                                                         multiplier:1
	                                                           constant:0];
	[self.prefixContainer addConstraint:self.prefixToTextContraint];
	[self.prefixContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|"
	                                                                             options:0
	                                                                             metrics:nil
	                                                                               views:views]];
	[self.prefixContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]"
	                                                                             options:0
	                                                                             metrics:nil
	                                                                               views:views]];
	self.textField.leftView = self.prefixContainer;
	self.textField.leftViewMode = UITextFieldViewModeAlways;

	[self updatePrefixConstraints];
}

- (void)updatePrefixConstraints {
	CGFloat defaultHorizontalMargin = 4;

	BOOL isPrefixBlank = (self.prefixLabel.text.length == 0);
	self.prefixToTextContraint.constant = isPrefixBlank ? 0 : defaultHorizontalMargin;

	[self.prefixContainer setNeedsLayout];
	[self.prefixContainer layoutIfNeeded];

	CGRect prefixFrame = self.prefixContainer.frame;
	self.placeholderLeadingConstraint.constant = prefixFrame.size.width;
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary <NSString *, id> *)change context:(void *)context
{
	if ([keyPath isEqualToString:NSStringFromSelector(@selector(text))]) {
		[self updateCharacterCount];
		self.errorDescription = nil;
		[self style];
	}
}

- (void)dealloc
{
	[self removeObserver:self forKeyPath:NSStringFromSelector(@selector(text))];
}

+ (NSSet *)keyPathsForValuesAffectingText
{
	return [NSSet setWithObject:@"textCache"];
}

@end
