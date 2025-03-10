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
@property (nonatomic, strong) NSMutableArray *cachedHeights;

@end


@implementation TablePresentationViewController

@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.prototypeCell = [TWTRTweetTableViewCell new];
    self.cachedHeights = [NSMutableArray array];

    [RACObserve(self.viewModel, tweets) subscribeNext:^(id x) {
        [self.cachedHeights removeAllObjects];
        for (int i = 0; i < self.viewModel.tweets.count; i++) {
            [self.cachedHeights addObject:[NSNull null]];
        }
        [self.tableView reloadData];
    }];
}

- (void)setupTableView {
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:TWTRTweetTableViewCell.class forCellReuseIdentifier:TweetTableReuseIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.tweets count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Improve perfomance of counting dynamic cell height
    NSUInteger ix = indexPath.row;
    if ([self.cachedHeights[ix] isEqual:[NSNull null]]) {
        TWTRTweet *tweet = self.viewModel.tweets[indexPath.row];
        [self.prototypeCell configureWithTweet:tweet];
        self.cachedHeights[ix] = @([self.prototypeCell calculatedHeightForWidth: CGRectGetWidth(self.view.bounds)]);
    }
    return [self.cachedHeights[ix] floatValue];
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

- (void)tweetView:(TWTRTweetView *)tweetView didSelectTweet:(TWTRTweet *)tweet {
    [self.parentViewController performSegueWithIdentifier:@"showTableTweetDetailsSegue" sender:tweet];
}

@end
