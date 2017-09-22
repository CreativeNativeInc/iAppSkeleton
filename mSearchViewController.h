//
//  mSearchViewController.h
//  iAppSkeleton
//
//  Created by Jon Smith on 8/21/15.
//  Copyright (c) 2017 Jon Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mSearchViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *searchTypePicker;

@end
