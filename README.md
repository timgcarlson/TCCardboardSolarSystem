TCCardboardSolarSystem
======================

A demo project showing how to create Google Cardboard virtual reality experiences with iOS and SceneKit.

https://www.google.com/get/cardboard/

Even supports the magnetic trigger using a delegate protocol `TCCardboardMagneticSensorDelegate`. See below.

The project uses two custom classes that give you basic VR support for iOS (`TCCardboardCameraNode` and `TCCardboardMagneticSensor`).

## TCCardboardCameraNode

Before creating a `TCCardboardCameraNode`, you will have to create a mirror image of two scenes. This project does this in the storyboard. Create the `TCCardboardCameraNode` and assign it's `leftCameraNode` to the left scene's `pointOfView` and the `rightCameraNode` to the right scene's `pointOfView`. This is now your camera that will handle all head tracking motion for you.


## TCCardboardMagneticSensor

Google Cardboard has a magnetic trigger on the left side. The ability to use this isn't unique to Android devices, as you just need to detect the disruption to the magnetic field around the device's compass. That is exatly what `TCCardboardMagneticSensor` handles for you. Simply inherit the `TCCardboardMagneticSensorDelegate` and create the method `onCardboardTrigger`, and you have yourself a basic input for your applicaiton.

## Coming Soon

I plan on wrapping up my VR classes into a separate project soon. In the meantime, feel free to take the two main classes above and use in your own projects.