// Copyright 2020-present the Material Components for iOS authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <UIKit/UIKit.h>

#import "MaterialSnapshot.h"

#import "MaterialDialogs.h"
#import "MDCAlertController+Testing.h"
#import "MaterialDialogs+Theming.h"
#import "MaterialTextFields.h"
#import "MaterialContainerScheme.h"

static NSString *const kCellId = @"cellId";

@interface MDCAlertControllerAccessoryTests : MDCSnapshotTestCase <UICollectionViewDataSource>
@property(nonatomic, strong) MDCAlertController *alert;
@property(nonatomic, strong) MDCContainerScheme *containerScheme;
@end

@implementation MDCAlertControllerAccessoryTests

- (void)setUp {
  [super setUp];

  // Uncomment below to recreate all the goldens (or add the following line to the specific
  // test you wish to recreate the golden for).
  //  self.recordMode = YES;

  self.alert = [MDCAlertController alertControllerWithTitle:@"Title" message:nil];
  [self addOutlinedActionWithTitle:@"OK"];

  self.containerScheme = [[MDCContainerScheme alloc] init];
  self.containerScheme.colorScheme =
      [[MDCSemanticColorScheme alloc] initWithDefaults:MDCColorSchemeDefaultsMaterial201907];
  self.containerScheme.typographyScheme =
      [[MDCTypographyScheme alloc] initWithDefaults:MDCTypographySchemeDefaultsMaterial201902];
}

- (void)tearDown {
  self.alert = nil;
  self.containerScheme = nil;

  [super tearDown];
}

#pragma mark - Helpers

- (void)addOutlinedActionWithTitle:(NSString *)actionTitle {
  [self.alert addAction:[MDCAlertAction actionWithTitle:actionTitle
                                               emphasis:MDCActionEmphasisMedium
                                                handler:nil]];
}

- (void)generateSizedSnapshotAndVerifyForAlert:(MDCAlertController *)alert {
  [alert sizeToFitContentInBounds:CGSizeMake(300.0f, 300.0f)];
  [alert highlightAlertPanels];
  [self generateSnapshotAndVerifyForView:alert.view];
}

- (void)generateSnapshotAndVerifyForView:(UIView *)view {
  [view layoutIfNeeded];

  UIView *snapshotView = [view mdc_addToBackgroundView];
  [self snapshotVerifyView:snapshotView];
}

- (void)changeToRTL:(MDCAlertController *)alert {
  [self changeViewToRTL:alert.view];
}

#pragma mark - Tests

- (void)testAlertHasTextFieldAccessory {
  // Given
  MDCTextField *textField = [[MDCTextField alloc] init];
  textField.placeholder = @"A TextField with a placeholder.";
  [self.alert applyThemeWithScheme:self.containerScheme];

  // When
  self.alert.accessoryView = textField;

  // Then
  [self generateSizedSnapshotAndVerifyForAlert:self.alert];
}

- (void)testAlertHasCollectionViewAccessory {
  // Given
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  CGRect frame = CGRectMake(0.0f, 0.0f, 320.0f, 160.0f);
  layout.itemSize = CGSizeMake(frame.size.width, frame.size.height / 4.0f);
  layout.minimumLineSpacing = 0.0f;
  UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame
                                                        collectionViewLayout:layout];
  collectionView.dataSource = self;
  [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellId];
  collectionView.backgroundColor = [UIColor whiteColor];
  [self.alert applyThemeWithScheme:self.containerScheme];
  [collectionView reloadData];

  // When
  self.alert.accessoryView = collectionView;

  // Then
  [self generateSizedSnapshotAndVerifyForAlert:self.alert];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId
                                                                         forIndexPath:indexPath];
  [cell setBackgroundColor:[[UIColor purpleColor]
                               colorWithAlphaComponent:0.1f * (indexPath.item + 1)]];
  return cell;
}

@end
