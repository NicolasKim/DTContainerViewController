# DTContainerViewController

[![CI Status](http://img.shields.io/travis/NicolasKim/DTContainerViewController.svg?style=flat)](https://travis-ci.org/NicolasKim/DTContainerViewController)
[![Version](https://img.shields.io/cocoapods/v/DTContainerViewController.svg?style=flat)](http://cocoapods.org/pods/DTContainerViewController)
[![License](https://img.shields.io/cocoapods/l/DTContainerViewController.svg?style=flat)](http://cocoapods.org/pods/DTContainerViewController)
[![Platform](https://img.shields.io/cocoapods/p/DTContainerViewController.svg?style=flat)](http://cocoapods.org/pods/DTContainerViewController)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

DTContainerViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DTContainerViewController"
```

## Usage

Inherit  or addChildViewController and set the delegate.

implement ```DTContainerViewControllerDataSource``` protocol method like

```objective-c
-(UIViewController *)viewControllerAtIndex:(NSUInteger)index{
    return self.vcArr[index];
}

-(NSUInteger)numberOfChildViewController{
    return 11;
}
```

implement ```DTContainerViewControllerDelegate```  protocol method for observe the transition progress



The DTScrollTitleBar is bonus!! You're welcome!!

And the guide of making container viewcontroller,you just need to look at [my blog](http://www.jianshu.com/p/188641f3563d)



## Demo

![gif](https://github.com/NicolasKim/DTContainerViewController/blob/1.0.2/DTContainerViewController.gif)

## Author

NicolasKim, jinqiucheng1006@live.cn

## License

DTContainerViewController is available under the MIT license. See the LICENSE file for more info.
