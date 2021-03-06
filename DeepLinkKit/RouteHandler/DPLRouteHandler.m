#import "DPLRouteHandler.h"

@implementation DPLRouteHandler

- (BOOL)shouldHandleDeepLink:(DPLDeepLink *)deepLink {
    return YES;
}


- (BOOL)preferModalPresentation {
    return NO;
}


- (UIViewController *)viewControllerForPresentingDeepLink:(DPLDeepLink *)deepLink {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

- (Class<DPLTargetViewController>)targetViewControllerClassForDeepLink:(DPLDeepLink *)deepLink {
    return nil;
}

- (UIViewController<DPLTargetViewController> *)targetViewControllerForDeepLink:(DPLDeepLink *)deepLink {
    Class targetVCClass = [self targetViewControllerClassForDeepLink:deepLink];
    return [targetVCClass new];
}

- (void)presentTargetViewController:(UIViewController <DPLTargetViewController> *)targetViewController
                   inViewController:(UIViewController *)presentingViewController {
    
    if ([self preferModalPresentation] ||
        ![presentingViewController isKindOfClass:[UINavigationController class]]) {
        
        [presentingViewController presentViewController:targetViewController animated:NO completion:NULL];
    }
    else if ([presentingViewController isKindOfClass:[UINavigationController class]]) {
        
        [self placeTargetViewController:targetViewController
                 inNavigationController:(UINavigationController *)presentingViewController];
    }
}


#pragma mark - Private

- (void)placeTargetViewController:(UIViewController *)targetViewController
           inNavigationController:(UINavigationController *)navigationController {
    
    if ([navigationController.viewControllers containsObject:targetViewController]) {
        [navigationController popToViewController:targetViewController animated:NO];
    }
    else {
        
        for (UIViewController *controller in navigationController.viewControllers) {
            if ([controller isMemberOfClass:[targetViewController class]]) {
                
                [navigationController popToViewController:controller animated:NO];
                [navigationController popViewControllerAnimated:NO];
                
                if ([controller isEqual:navigationController.topViewController]) {
                    [navigationController setViewControllers:@[targetViewController] animated:NO];
                }
                
                break;
            }
        }
        
        if (![navigationController.topViewController isEqual:targetViewController]) {
            [navigationController pushViewController:targetViewController animated:NO];
        }
    }
}

@end


@implementation DPLRouteHandler (Deprecated)

- (UIViewController <DPLTargetViewController> *)targetViewController {
    return nil;
}

@end
