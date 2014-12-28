//
//  TCCardboardMagneticSensor.m
//  VR-Experiment
//
//  Created by Tim Carlson on 12/24/14.
//  Copyright (c) 2014 Tim Carlson. All rights reserved.
//
//  Acknowledgements: This code was inspired by Andrew Whyte from Secret Ingredient Games,
//  which was originally writing in C# for Unity.
//

#import "TCCardboardMagneticSensor.h"

// Finite Impulse Response filters
static const NSInteger TCSlowFIR = 25;
static const NSInteger TCFastFIR = 3;

@interface TCCardboardMagneticSensor ()

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic) CGFloat magnetBaseLine;

@property (nonatomic) CGFloat magnetMagn;

@property (nonatomic) CGFloat threshold;

@property (nonatomic) BOOL click;
@property (nonatomic) BOOL clickReported;

@property (nonatomic) BOOL initialHeading;
@property (nonatomic) BOOL initial;

@end

@implementation TCCardboardMagneticSensor


- (instancetype)init {
    if (self = [super init]) {
        _magnetBaseLine = 0.f;
        _magnetMagn = 0.f;

        _click = NO;
        _clickReported = NO;
        
        _initialHeading = YES;
        
        _locationManager = [[CLLocationManager alloc] init];
        if ([CLLocationManager headingAvailable] == NO) {
            // No compass is available. This application cannot completely function without a compass.
            self.locationManager = nil;
            UIAlertView *noCompassAlert = [[UIAlertView alloc] initWithTitle:@"No Compass!"
                                                                     message:@"This device cannot use the magnet sensor to toggle input. Some features may not be available without using the touch screen."
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
            [noCompassAlert show];
        } else {
            // heading service configuration
            self.locationManager.headingFilter = kCLHeadingFilterNone;
            // setup delegate callbacks
            self.locationManager.delegate = self;
            // start the compass
            [self.locationManager startUpdatingHeading];
        }
    }
    
    return self;
}


#pragma mark - CLLocationManagerDelegate

// This delegate method is invoked when the location manager has heading data.
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    // Compute the magnitude (size or strength) of the vector.
    //      magnitude = sqrt(x^2 + y^2 + z^2)
    CGFloat magnitude = sqrt(heading.x*heading.x + heading.y*heading.y + heading.z*heading.z);
    
    if (_initialHeading) {
        // Initialize heading data.
        _magnetMagn = magnitude;
        _magnetBaseLine = magnitude;
        _initialHeading = NO;
    } else {
        // Update the compass fast values
        _magnetMagn = ((TCFastFIR - 1) * _magnetMagn + magnitude) / TCFastFIR;
        
        // Update the slow values
        _magnetBaseLine = ((TCSlowFIR - 1) * _magnetBaseLine + magnitude) / TCSlowFIR;
        
        // Determine if the magnet was clicked
        if ((_magnetMagn / _magnetBaseLine) > 1.1) {
            if (!_clickReported) {
                _click = YES;
                // Single Click
                if ([self.delegate respondsToSelector:@selector(onCardboardTrigger)]) {
                    [self.delegate onCardboardTrigger];
                } 
            }
            _clickReported = YES;
        } else {
            _clickReported = NO;
        }
    }
}

// This delegate method is invoked when the location managed encounters an error condition.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        // This error indicates that the user has denied the application's request to use location services.
        [manager stopUpdatingHeading];
    } else if ([error code] == kCLErrorHeadingFailure) {
        // This error indicates that the heading could not be determined, most likely because of strong magnetic interference.
    }
}

@end
