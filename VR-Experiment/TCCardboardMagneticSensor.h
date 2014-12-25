//
//  TCCardboardMagneticSensor.h
//  VR-Experiment
//
//  Created by Tim Carlson on 12/24/14.
//  Copyright (c) 2014 Tim Carlson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <SceneKit/SceneKit.h>

/** This protocol defines delegate methods for TCCardboardMagneticSensor objects. */
@protocol TCCardboardMagneticSensorDelegate <NSObject>

/** Called when the cardboard magnetic trigger button is clicked.
 @abstract The Google Cardboard has a magnet on the left side of the design. This magnet is detected by the device's compass, which is located at the top of the device. The change in magnetic field is detected by TCCardboardMagneticSensor.
 */
- (void)onCardboardTrigger;

@end


/** A magnetic sensor object to detect when the Cardboard VR headset's magnet is "clicked".
 */
@interface TCCardboardMagneticSensor : NSObject <CLLocationManagerDelegate>

/** The cardboard magnetic sensor's delegate.
 */
@property (weak) id <TCCardboardMagneticSensorDelegate> delegate;

@end
