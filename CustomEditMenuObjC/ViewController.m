//
//  ViewController.m
//  CustomEditMenuObjC
//  Created by JingShao on 4/4/25.
//

#import "ViewController.h"

@interface ViewController () <UIEditMenuInteractionDelegate, UITextViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIEditMenuInteraction *editMenuInteraction;
@property (strong, nonatomic) UILabel *instructionsLabel;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    // Create custom title label
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = @"Custom Edit Menu Demo - #2";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:22.0];
    self.titleLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:181.0/255.0 blue:246.0/255.0 alpha:1.0]; // Light blue color
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    // Create text view
    self.textView = [[UITextView alloc] init];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:16.0];
    self.textView.text = @"Hi, I'm Jing Shao and this is my second sample for \"Secure Paste Custom Actions on iOS\".\n\nThis is a sample text with custom edit menu options.\n\nTry these examples:\n• https://apple.com\n• shao.jing1@northeastern.edu\n\nRight-click to see the custom menu options.";
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = [UIColor systemGrayColor].CGColor;
    self.textView.layer.cornerRadius = 8.0;
    self.textView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:192.0/255.0 blue:203.0/255.0 alpha:0.3];
    
    self.textView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.textView.linkTextAttributes = @{};
    
    [self.view addSubview:self.textView];
    
    UIImageView *infoIcon = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"info.circle.fill"]];
    infoIcon.translatesAutoresizingMaskIntoConstraints = NO;
    infoIcon.tintColor = [UIColor systemTealColor];
    [self.view addSubview:infoIcon];
    
    // Create instructions label
    self.instructionsLabel = [[UILabel alloc] init];
    self.instructionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.instructionsLabel.numberOfLines = 0;

    NSString *instructionsText = @"Instructions:\n1. Long press or right-click on the text to see the context menu\n2. The menu will include standard options plus custom ones\n3. Try selecting an email or URL to see context-specific options";
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:instructionsText];
    [attrText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0] range:[instructionsText rangeOfString:@"Instructions:"]];
    self.instructionsLabel.attributedText = attrText;
    
    [self.view addSubview:self.instructionsLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20.0],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:20.0],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-20.0],
        
        [self.textView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:20.0],
        [self.textView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:20.0],
        [self.textView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-20.0],
        [self.textView.heightAnchor constraintEqualToConstant:200.0],
        
        [infoIcon.topAnchor constraintEqualToAnchor:self.textView.bottomAnchor constant:26.0],
        [infoIcon.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:20.0],
        [infoIcon.widthAnchor constraintEqualToConstant:20.0],
        [infoIcon.heightAnchor constraintEqualToConstant:20.0],

        [self.instructionsLabel.topAnchor constraintEqualToAnchor:self.textView.bottomAnchor constant:20.0],
        [self.instructionsLabel.leadingAnchor constraintEqualToAnchor:infoIcon.trailingAnchor constant:12.0], // More spacing
        [self.instructionsLabel.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-20.0]
    ]];
    
    [self setupEditMenuInteraction];
}

- (void)setupEditMenuInteraction {
    // Create the edit menu interaction
    self.editMenuInteraction = [[UIEditMenuInteraction alloc] initWithDelegate:self];
    
    // Add the interaction to the text view
    [self.textView addInteraction:self.editMenuInteraction];
    
    // Create a long press gesture
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPress:)];
    longPress.allowedTouchTypes = @[@(UITouchTypeDirect)];
    
    [self.textView addGestureRecognizer:longPress];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // Get the location of the long press
        CGPoint location = [recognizer locationInView:self.textView];
        
        NSLog(@"Long press detected at location: %@", NSStringFromCGPoint(location));
        
        // Create a configuration for the edit menu
        UIEditMenuConfiguration *configuration = [UIEditMenuConfiguration
                                                 configurationWithIdentifier:nil
                                                 sourcePoint:location];
        
        [self.editMenuInteraction presentEditMenuWithConfiguration:configuration];
    }
}

#pragma mark - UIEditMenuInteractionDelegate

- (UIMenu *)editMenuInteraction:(UIEditMenuInteraction *)interaction menuForConfiguration:(UIEditMenuConfiguration *)configuration suggestedActions:(NSArray<UIMenuElement *> *)suggestedActions {
    
    // Get the selected text
    NSString *selectedText = [self.textView.text substringWithRange:self.textView.selectedRange];

    NSLog(@"Selected text: '%@'", selectedText);
    NSLog(@"Suggested actions count: %lu", (unsigned long)suggestedActions.count);
    
    // If no text is selected, return the suggested actions only
    if (selectedText.length == 0) {
        return [UIMenu menuWithChildren:suggestedActions];
    }
    
    NSMutableArray<UIMenuElement *> *customMenuItems = [NSMutableArray array];
    
    // Add "Search Web" action for any selected text
    UIAction *searchAction = [UIAction actionWithTitle:@"Search Web"
                                                 image:[UIImage systemImageNamed:@"magnifyingglass"]
                                            identifier:nil
                                               handler:^(__kindof UIAction * _Nonnull action) {
        [self searchWeb:selectedText];
    }];
    [customMenuItems addObject:searchAction];
    
    // Check if the selected text is an email
    if ([self isValidEmail:selectedText]) {
        UIAction *emailAction = [UIAction actionWithTitle:@"Send Email"
                                                   image:[UIImage systemImageNamed:@"envelope"]
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
            [self sendEmail:selectedText];
        }];
        
        emailAction.attributes = UIMenuElementAttributesDestructive;
        [customMenuItems addObject:emailAction];
    }
    
    // Check if the selected text is a URL
    if ([self isValidURL:selectedText]) {
        UIAction *urlAction = [UIAction actionWithTitle:@"Open Link"
                                                 image:[UIImage systemImageNamed:@"link"]
                                            identifier:nil
                                               handler:^(__kindof UIAction * _Nonnull action) {
            [self openLink:selectedText];
        }];
        [customMenuItems addObject:urlAction];
    }
    
    // Filter the suggested actions to remove any that might conflict with our custom ones
    NSMutableArray<UIMenuElement *> *filteredSuggestedActions = [NSMutableArray array];
    for (UIMenuElement *action in suggestedActions) {
        if ([action isKindOfClass:[UIAction class]]) {
            UIAction *uiAction = (UIAction *)action;
            NSLog(@"Suggested action title: %@", uiAction.title);
            
            // Skip actions with titles that conflict with our custom ones
            if (![uiAction.title isEqualToString:@"New Mail Message"] &&
                ![uiAction.title isEqualToString:@"Open Link"] &&
                ![uiAction.title containsString:@"Mail"]) {
                [filteredSuggestedActions addObject:action];
            }
        } else {
            [filteredSuggestedActions addObject:action];
        }
    }
    
    NSMutableArray<UIMenuElement *> *allItems = [NSMutableArray arrayWithArray:customMenuItems];
    [allItems addObjectsFromArray:filteredSuggestedActions];
    
    // Create and return menu with all actions
    return [UIMenu menuWithChildren:allItems];
}

#pragma mark - UITextViewDelegate

// Key method to block default menu for links and email addresses
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    NSLog(@"shouldInteractWithURL called with interaction: %ld", (long)interaction);
    
    if (interaction == UITextItemInteractionPresentActions ||
        interaction == UITextItemInteractionInvokeDefaultAction) {
        textView.selectedRange = characterRange;
        return NO;
    }
    return YES;
}

// Also block the default menu for text attachments
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    NSLog(@"shouldInteractWithTextAttachment called with interaction: %ld", (long)interaction);
    
    if (interaction == UITextItemInteractionPresentActions ||
        interaction == UITextItemInteractionInvokeDefaultAction) {
        textView.selectedRange = characterRange;
        return NO;
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSString *selectedText = [textView.text substringWithRange:textView.selectedRange];
    NSLog(@"Selection changed to: '%@'", selectedText);
}

#pragma mark - Helper Methods

- (BOOL)isValidEmail:(NSString *)text {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isEmail = [emailTest evaluateWithObject:text];
    NSLog(@"Email validation for '%@': %@", text, isEmail ? @"YES" : @"NO");
    return isEmail;
}

- (BOOL)isValidURL:(NSString *)text {
    NSString *urlRegex = @"(https?|ftp)://(-\\.)?([^\\s/?\\.#-]+\\.?)+(/[^\\s]*)?";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    BOOL isURL = [urlTest evaluateWithObject:text];
    NSLog(@"URL validation for '%@': %@", text, isURL ? @"YES" : @"NO");
    return isURL;
}

- (void)searchWeb:(NSString *)query {
    NSLog(@"Search web called with query: %@", query);
    
    // Open the search in Safari
    NSString *searchString = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *searchURLString = [NSString stringWithFormat:@"https://www.google.com/search?q=%@", searchString];
    NSURL *searchURL = [NSURL URLWithString:searchURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:searchURL]) {
        [[UIApplication sharedApplication] openURL:searchURL options:@{} completionHandler:^(BOOL success) {
            NSLog(@"Opened search URL: %@", success ? @"Yes" : @"No");
        }];
    } else {
        [self showAlertWithTitle:@"Search Web" message:[NSString stringWithFormat:@"Searching for: %@", query]];
    }
}

- (void)sendEmail:(NSString *)email {
    NSLog(@"Send email called with address: %@", email);
    
    // Clean email address
    NSString *cleanEmail = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *mailtoString = [NSString stringWithFormat:@"mailto:%@", cleanEmail];
    NSURL *mailtoURL = [NSURL URLWithString:mailtoString];
    
    if ([[UIApplication sharedApplication] canOpenURL:mailtoURL]) {
        [[UIApplication sharedApplication] openURL:mailtoURL options:@{} completionHandler:^(BOOL success) {
            NSLog(@"Opened mail URL: %@", success ? @"Success" : @"Failed");
        }];
    } else {
        NSLog(@"Cannot open mailto URL: %@", mailtoString);
        [self showAlertWithTitle:@"Send Email" message:[NSString stringWithFormat:@"Sending email to: %@", cleanEmail]];
    }
}

- (void)openLink:(NSString *)urlString {
    NSLog(@"Open link called with URL: %@", urlString);
    
    // Ensure URL has a scheme
    if (![urlString hasPrefix:@"http://"] && ![urlString hasPrefix:@"https://"]) {
        urlString = [@"https://" stringByAppendingString:urlString];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            NSLog(@"Opened URL: %@", success ? @"Success" : @"Failed");
        }];
    } else {
        NSLog(@"Cannot open URL: %@", urlString);
        [self showAlertWithTitle:@"Open Link" message:[NSString stringWithFormat:@"Opening link: %@", urlString]];
    }
}

// Helper method to show alerts
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
