/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import React

class MixerReactModule: NSObject {
  var bridge: RCTBridge?
  static let sharedInstance = MixerReactModule()
  
  
  func createBridgeIfNeeded() -> RCTBridge {
    if bridge == nil {
      bridge = RCTBridge.init(delegate: self, launchOptions: nil)
    }
    return bridge!
  }
  
  func viewForModule(_ moduleName: String, initialProperties: [String : Any]?) -> RCTRootView {
    let viewBridge = createBridgeIfNeeded()
    let rootView: RCTRootView = RCTRootView(
      bridge: viewBridge,
      moduleName: moduleName,
      initialProperties: initialProperties)
    return rootView
  }
}

extension MixerReactModule: RCTBridgeDelegate {
  func sourceURL(for bridge: RCTBridge!) -> URL! {
    // Return URL below during development
   // return URL(string: "http://localhost:8081/index.ios.bundle?platform=ios")
    
    
    return URL(string: "http://192.168.1.6:8081/index.ios.bundle?platform=ios")
    
    //this is my hot spot
    
    return URL(string: "http://172.20.10.6:8081/index.ios.bundle?platform=ios")
    
    
    return URL(string: "http://192.168.1.1:8081/index.ios.bundle?platform=ios")
    
    
    //this is my school
    //    return URL(string: "http://10.102.68.163:8081/index.ios.bundle?platform=ios")
    
    //
    // Return bundle below if using a pre-bundled file on disk
    //return Bundle.main.url(forResource: "main", withExtension: "jsbundle")
  }
}
