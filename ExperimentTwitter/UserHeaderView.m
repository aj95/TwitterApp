//
//  UserHeaderView.m
//  ExperimentTwitter
//
//  Created by ayur.j on 18/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "UserHeaderView.h"
#import "User+Twitter.h"

@implementation UserHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:self options:nil];
        UIView *mainView = [subviewArray objectAtIndex:0];
        [self addSubview:mainView];
    }
    return self;
}
- (IBAction)onLogoutPress:(id)sender {
    [User logout];
}

@end
