# Julie's House Webshop

Order your favorite cakes from Julie's House in an iOS application. View the nearest Julie's House bakeries, and taste the best cakes of Belgium!
There is also an asdmin application available and a database connection based on Node.js and Express.

## Installing

1.  Open the backend directory in terminal and install the scripts with yarn

```
yarn
```

2.  Start the node.js server

```
node index.js
```

3.  Open JuliesHouse.xcworkspace in xcode and run the iOS app in a virtual machine.

4.  Open JuliesHouseAdmin.xcworkspace in xcode and run the iOS app in a virutal machine.

5.  You can now place / delete / change orders and they will automatically update in the admin / client app.

### Test on a real iOS device

In order to run the app on a real iOS device, you have to change the address of the server in the code.

For example: change 127.0.0.1:4000/orders to your IP address: 192.168.0.121:4000/orders

## Built With

* [Express](https://github.com/expressjs/express)
* [Node.js](https://github.com/nodejs)
* [Swift](https://github.com/apple/swift)
* [CocoaPods](https://guides.cocoapods.org/using/the-podfile.html) - Om Alamofire te installeren
* [Alamofire](https://github.com/Alamofire/Alamofire) - API / REST in Swift
