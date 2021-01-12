//
// MLButtonConfig.h
// Pods
//
// Created by Cristian Leonel Gibert on 1/31/17.
//
//

#import <Foundation/Foundation.h>
#import "MLButtonConfigStyle.h"
#import "MLButtonStylesFactory.h"
#import "MLSpinner.h"

@interface MLButtonConfig : NSObject

@property (nonatomic, strong) MLButtonConfigStyle *defaultState;
@property (nonatomic, strong) MLButtonConfigStyle *highlightedState;
@property (nonatomic, strong) MLButtonConfigStyle *disableState;
@property (nonatomic, strong) MLButtonConfigStyle *loadingState;
@property (nonatomic, strong) MLSpinnerConfig *spinnerStyle;
@property (nonatomic, assign) MLButtonSize buttonSize;

@end
