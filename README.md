
# InDependence

_InDependence_ is a Dependency Injection (DI) framework for iOS written in Objective-C. Key features are:

* Support for _child-to-parent_ and _sibling-to-sibling_ references. It makes integration of DI to old legacy code much easier.
* Extendable design of framework encourages writing custom extensions for adapting _InDependence_ to own needs.

## Features

* "Annotation" based Dependency Injection
* Powerful binding system
    * Class bindings
    * Protocol bindings
    * Instance bindings _(TODO)_
    * Custom factory blocks _(TODO)_
    * Custom _post-init_ blocks _(TODO)_
* Bindings may be grouped into modules _(TODO)_
* _Child-to-parent_ references
* _Sibling-to-sibling_ references _(TODO)_
* Initializer support
    * Default and custom arguments
* Singleton annotations
* Objects are notified when injection is complete
* Extensions for adding own features

## How to use InDependence

### Basic Usage
![][requirements]


### Fetching objects from injector

### Child-to-parent references
![][ancestors]

_InDependence_ can automatically fill in references to parents and ancestors. References must be declared as `weak`.

### Sibling-to-sibling references
![][siblings]


### Awaking from Injector
#### Example

### Modules
#### Class bindings
![][bindings]

#### Instance and protocol bindings



#### Recursive bindings
![][recursive2]

There may be binding rules for already binded classes (for example, in another module). _InDependence_ finds appropriate class by recursion.
```objective-c
-(void)configure{
    [self.injector bindClass:[Ford class] toClass:[Car class]];
    [self.injector bindClass:[FordFocus class] toClass:[Ford class]];
}
// ...
Car *car = [[InDependenceInjector sharedInjector] getObject:[Car class]];
NSLog(NSStringFromClass([car class])); // FordFocus
```

### Initializers
#### Default Arguments Example
####  Custom Arguments Example

### Singletons
![][singleton]


## Extensions
_(TODO)_

## Installation
Add sources from `InDependence` folder to your project. Enable ARC for them. Add `InDependence.h` to your project's `.pch` file:
    
    #import "InDependence.h"

## Requirements
* iOS 5.0 and later
* ARC

## License
MIT License.

## Acknowledgments
Some code and ideas derived from [Objection][Objection] by Justin DeWind.

[Objection]: https://github.com/atomicobject/objection
[requirements]: docs/img/b5b2f18b.png
[bindings2]: docs/img/ee66eff9.png
[bindings]: docs/img/e90379af.png
[ancestors]: docs/img/784aea66.png
[siblings]: docs/img/cbc7da6c.png
[recursive]: docs/img/47a78d9d.png
[recursive2]: docs/img/bf3f46b8.png
[singleton]: docs/img/5fd9b515.png
