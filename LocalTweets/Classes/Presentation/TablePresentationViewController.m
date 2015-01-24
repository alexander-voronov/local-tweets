//
//  TablePresentationViewController.m
//  LocalTweets
//
//  Created by Alexander Voronov on 19/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "TablePresentationViewController.h"
#import "LocalTweetsDatasourceViewModel.h"

static NSString * const TweetTableReuseIdentifier = @"TwitterCell";


@interface TablePresentationViewController ()

@property (nonatomic, strong) TWTRTweetTableViewCell *prototypeCell;

@end


@implementation TablePresentationViewController

@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:TWTRTweetTableViewCell.class forCellReuseIdentifier:TweetTableReuseIdentifier];
    self.prototypeCell = [[TWTRTweetTableViewCell alloc] init];
    
    [RACObserve(self.viewModel, tweets) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.tweets count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWTRTweet *tweet = self.viewModel.tweets[indexPath.row];
    [self.prototypeCell configureWithTweet:tweet];
    return [self.prototypeCell calculatedHeightForWidth: CGRectGetWidth(self.view.bounds)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWTRTweet *tweet = self.viewModel.tweets[indexPath.row];
    TWTRTweetTableViewCell *cell = (TWTRTweetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TweetTableReuseIdentifier forIndexPath:indexPath];
    [cell configureWithTweet:tweet];
    cell.tweetView.delegate = self;
    return cell;
}

# pragma mark - TWTRTweetViewDelegate Methods

- (UIViewController *)viewControllerForPresentation {
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
