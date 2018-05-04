# FBShareSandbox

[![CI Status](https://img.shields.io/travis/zhangxueyang/FBShareSandbox.svg?style=flat)](https://travis-ci.org/zhangxueyang/FBShareSandbox)
[![Version](https://img.shields.io/cocoapods/v/FBShareSandbox.svg?style=flat)](https://cocoapods.org/pods/FBShareSandbox)
[![License](https://img.shields.io/cocoapods/l/FBShareSandbox.svg?style=flat)](https://cocoapods.org/pods/FBShareSandbox)
[![Platform](https://img.shields.io/cocoapods/p/FBShareSandbox.svg?style=flat)](https://cocoapods.org/pods/FBShareSandbox)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

FBShareSandbox is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FBShareSandbox'
```
##How To Use
```
#ifdef DEBUG
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[FBShareSandbox sharedSandbox] swipSandboxPage];
        });
#endif
```

![Image text](https://github.com/zhangxueyang/FBShareSandbox/blob/master/Images/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202018-04-28%20at%2014.10.42.png)
![Image text](https://github.com/zhangxueyang/FBShareSandbox/blob/master/Images/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202018-04-28%20at%2014.11.04.png)
