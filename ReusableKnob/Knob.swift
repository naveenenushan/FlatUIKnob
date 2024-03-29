/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class Knob: UIControl {
  /** Contains the minimum value of the receiver. */
  var minimumValue: Float = 0

  /** Contains the maximum value of the receiver. */
  var maximumValue: Float = 1

  /** Contains the receiver’s current value. */
  private (set) var value: Float = 0

  /** Sets the receiver’s current value, allowing you to animate the change visually. */
  func setValue(_ newValue: Float, animated: Bool = false) {
    value = min(maximumValue, max(minimumValue , newValue))
   

    //let angleRange = endAngle - startAngle
        let angleRange = endAngle - startAngle
    
    let valueRange = maximumValue - minimumValue
    let angleValue = CGFloat(value - minimumValue) / CGFloat(valueRange) * angleRange + startAngle
    renderer.setPointerAngle(angleValue, animated: animated)
    
    
    
    
    
  }
  
  
  func sample(setVal:Float) {
    
    let loadingProcess = LoadingProcess(minValue: Int(startAngle), maxValue: Int(setVal))
    
    loadingProcess.simulateLoading(toValue: 80, valueChanged: { currentValue in
     // self.renderer.setPointerAngle(CGFloat(currentValue), animated: false)
    })
    
    DispatchQueue.global(qos: .background).async {
      print("Start loading data")
      sleep(5)
      print("Data loaded")
     
      loadingProcess.finish(valueChanged: { currentValue in
         print(currentValue)
         self.renderer.setPointerAngle(CGFloat(currentValue), animated: false)
      }) { _ in
        print("end")
      }
    }
  }
  

  /** Contains a Boolean value indicating whether changes
   in the sliders value generate continuous update events. */
  var isContinuous = true

  private let renderer = KnobRenderer()

  /** Specifies the width in points of the knob control track. Defaults to 2 */
  var lineWidth: CGFloat {
    get { return renderer.lineWidth }
    set { renderer.lineWidth = newValue }
  }

  /** Specifies the angle of the start of the knob control track. Defaults to -11π/8 */
  var startAngle: CGFloat {
    get { return renderer.startAngle }
    set { renderer.startAngle = newValue }
  }

  /** Specifies the end angle of the knob control track. Defaults to 3π/8 */
  var endAngle: CGFloat {
    get { return renderer.endAngle }
    set { renderer.endAngle = newValue }
  }
  
  var angleValue: CGFloat {
    get { return renderer.angleValue }
    set { renderer.angleValue = newValue }
  }

  /** Specifies the length in points of the pointer on the knob. Defaults to 6 */
  var pointerLength: CGFloat {
    get { return renderer.pointerLength }
    set { renderer.pointerLength = newValue }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  private func commonInit() {
    renderer.updateBounds(bounds)
    renderer.color = tintColor
    renderer.setPointerAngle(renderer.startAngle)

    layer.addSublayer(renderer.trackLayer)
    layer.addSublayer(renderer.pointerLayer)
    //layer.addSublayer(renderer.realPointerLayer)

    let gestureRecognizer = RotationGestureRecognizer(target: self, action: #selector(Knob.handleGesture(_:)))
    addGestureRecognizer(gestureRecognizer)
  }

  @objc private func handleGesture(_ gesture: RotationGestureRecognizer) {
    // 1
    let midPointAngle = (2 * CGFloat(Double.pi) + startAngle - endAngle) / 2 + endAngle
    // 2
    var boundedAngle = gesture.touchAngle
    if boundedAngle > midPointAngle {
      boundedAngle += 2 * CGFloat(Double.pi)
      
      // -= chnage couse we use anti clockwise
    } else if boundedAngle < (midPointAngle - 2 * CGFloat(Double.pi)) {
      // -= chnage couse we use anti clockwise
      boundedAngle += 2 * CGFloat(Double.pi)
    }
print( boundedAngle )
    // 3
    boundedAngle = min(endAngle, max(startAngle, boundedAngle))

    // 4
    let angleRange = endAngle - startAngle
    let valueRange = maximumValue - minimumValue
    let angleValue = Float(boundedAngle - startAngle) / Float(angleRange) * valueRange + minimumValue

    // 5
    setValue(angleValue)

    if isContinuous {
      sendActions(for: .valueChanged)
    } else {
      if gesture.state == .ended || gesture.state == .cancelled {
        sendActions(for: .valueChanged)
      }
    }
  }
 
 
  func kiasdhfs(setValue:Float) ->  Int  {
    print(setValue*1000.0)
    var nextv =  setValue
    
    if nextv > 7.9600 {
      nextv = 7.96
    }
    print("nextv: \(nextv)")
    
    let loadingProcess = LoadingProcess(minValue: Int(startAngle*100.0), maxValue: Int(nextv*1000.0))
      print(Int(4.5*100.0))
    loadingProcess.simulateLoading(toValue: 80, valueChanged: { currentValue in
      //self.setPointerAngle(CGFloat(currentValue), animated: false)\
      print("Start init data")
      print(currentValue)
    })
  var vale = 2
    DispatchQueue.global(qos: .background).async {
      print("Start loading data")
      //sleep(5)
      print("Data loaded")
 
      loadingProcess.finish(valueChanged: { currentValue in
        print(currentValue)
        //
        
        self.value = min(self.maximumValue, max(self.minimumValue , Float(currentValue)))
        
       
        var adfcda = Float(currentValue/100)
        if adfcda > 7.9600 {
          adfcda = 7.955
        }
        
         print("nextv: \(adfcda)")
        self.renderer.setPointerAngle(CGFloat(adfcda), animated: false)
       // self.setValue(0.5)
       
        
      }) { _ in
        print("end")
      }
    }
    return vale
  }
  
}



//class end



private class KnobRenderer {
  var color: UIColor = .red {
    didSet {
      //trackLayer.strokeColor = color.cgColor
      pointerLayer.strokeColor = color.cgColor
    }
  }

  var lineWidth: CGFloat = 2 {
    didSet {
      //trackLayer.lineWidth = lineWidth
      pointerLayer.lineWidth = lineWidth
      updateTrackLayerPath()
      updatePointerLayerPath()
    }
  }

  var startAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8 {
    didSet {
      updateTrackLayerPath()
    }
  }

  var endAngle: CGFloat = CGFloat(Double.pi) * 3 / 8 {
    didSet {
      updateTrackLayerPath()
    }
  }
  
  var angleValue: CGFloat = CGFloat(Double.pi) * 3 / 8 {
    didSet {
      updateTrackLayerPath()
    }
  }

  var pointerLength: CGFloat = 6 {
    didSet {
      updateTrackLayerPath()
      updatePointerLayerPath()
    }
  }

  private (set) var pointerAngle: CGFloat = CGFloat(-Double.pi) * 11 / 1

  func setPointerAngle(_ newPointerAngle: CGFloat, animated: Bool = false) {
    CATransaction.begin()
    CATransaction.setDisableActions(true)

   // pointerLayer.transform = CATransform3DMakeRotation(newPointerAngle, 0, 0, 1)
    let bounds = trackLayer.bounds
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let offset = max(pointerLength, lineWidth  / 2)
    let radius = min(bounds.width, bounds.height) / 2 - offset * bounds.width/240
   
    
    var changeVal = newPointerAngle

//    let startPoint = CGPoint(x: self.rectangleFrame.midX, y: self.rectangleFrame.minY);
//    let endPoint = CGPoint(x: self.rectangleFrame.midX, y: self.rectangleFrame.maxY);
//
   // context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
    
    print("changeVal: \(changeVal)")
    print("angleValue: \(angleValue)")
    //context.restoreGState();
    if changeVal > startAngle {
     // changeVal = changeVal-1.11
    }
    
    if  changeVal < 1.932  {
      changeVal = 1.932
    }
    if changeVal > 7.96 {
      changeVal = 7.96
    }
    
    
    
    print(changeVal)
    let ring =  UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: changeVal, clockwise: false)
    //pointer.move(to: CGPoint(x: bounds.width - CGFloat(pointerLength) - CGFloat(lineWidth) / 2, y: bounds.midY))
    // pointer.addLine(to: CGPoint(x: bounds.width, y: bounds.midY))
    
    
   
    
    //self.view.layer.addSublayer(gradient)
    pointerLayer.path = ring.cgPath
    pointerLayer.strokeColor = UIColor(red: 59/255, green: 56/255, blue: 77/255, alpha: 1.0).cgColor
    
 
   
    
    //realPointerLayer.position = CGPoint(x: bounds2.width, y: bounds2.midY)
    
    
    //realPointerLayer.strokeColor = UIColor.red.cgColor
    
    if animated {
    //  let midAngleValue = (max(newPointerAngle, pointerAngle) - min(newPointerAngle, pointerAngle)) / 2 + min(newPointerAngle, pointerAngle)
      
      
      //sample()
      
      
      
//      let midAngleValue = (max(changeVal, startAngle) - min(changeVal, endAngle)) / 2 + min(changeVal, startAngle)
//      print("junction points are: \(midAngleValue)")
//
//      let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
//      animation.values = [startAngle, startAngle,startAngle]
//      animation.keyTimes = [0.0, 1.0, 2.0]
//      animation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
//      pointerLayer.add(animation, forKey: nil)
      
      
      
      
    }

    CATransaction.commit()

    pointerAngle = newPointerAngle
  }
  
  
  

  let trackLayer = CALayer()
  
  let pointerLayer = CAShapeLayer()
    let realPointerLayer = CALayer()

  init() {
      trackLayer.contents = UIImage(named: "back_image")?.cgImage
    trackLayer.masksToBounds = true
    
    pointerLayer.fillColor = UIColor.clear.cgColor
    realPointerLayer.contents = UIImage(named: "dot")?.cgImage
    
  }
  
  func animateValue(endVal:CGFloat){
  
    let loadingProcess = LoadingProcess(minValue: Int(startAngle*100.0), maxValue: Int(endVal*100.0))
    
    loadingProcess.simulateLoading(toValue: 80, valueChanged: { currentValue in
      //self.setPointerAngle(CGFloat(currentValue), animated: false)\
      print("Start init data")
      print(currentValue)
    })
    
    DispatchQueue.global(qos: .background).async {
      print("Start loading data")
      sleep(5)
      print("Data loaded")
      loadingProcess.finish(valueChanged: { currentValue in
        print(currentValue)
        //
        
        self.setPointerAngle(CGFloat(currentValue/100), animated: false)
      }) { _ in
        print("end")
      }
    
  }
  }

  private func updateTrackLayerPath() {
//    let bounds = trackLayer.bounds
//    let center = CGPoint(x: bounds.midX, y: bounds.midY)
//    let offset = max(pointerLength, lineWidth  / 2)
//    let radius = min(bounds.width, bounds.height) / 2 - offset
//
//    let ring = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    //trackLayer.path = ring.cgPath chek again
    
  }

  private func updatePointerLayerPath() {
    
    let bounds = trackLayer.bounds
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let offset = max(pointerLength, lineWidth  / 2) + 10
    let radius = min(bounds.width, bounds.height) / 2 - offset
     //endAngle = CGFloat(Double.pi) * offset / 8
    print( radius)
    let ring =  UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 4, clockwise: true)
    let pointer = UIBezierPath()
    pointer.move(to: CGPoint(x: bounds.width - CGFloat(pointerLength) - CGFloat(lineWidth) / 2, y: bounds.midY))
    pointer.addLine(to: CGPoint(x: bounds.width, y: bounds.midY))
     //pointerLayer.path = pointer.cgPath
    pointerLayer.path = ring.cgPath
    
    
    
    
  }

  func updateBounds(_ bounds: CGRect) {
    trackLayer.bounds = bounds
    trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    updateTrackLayerPath()

    pointerLayer.bounds = trackLayer.bounds
    pointerLayer.position = trackLayer.position
    
    realPointerLayer.bounds = pointerLayer.bounds
    
    
    
    updatePointerLayerPath()
  }
}

import UIKit.UIGestureRecognizerSubclass

private class RotationGestureRecognizer: UIPanGestureRecognizer {
  private(set) var touchAngle: CGFloat = 0

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesBegan(touches, with: event)
    updateAngle(with: touches)
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesMoved(touches, with: event)
    updateAngle(with: touches)
  }

  private func updateAngle(with touches: Set<UITouch>) {
    guard
      let touch = touches.first,
      let view = view
    else {
      return
    }
    let touchPoint = touch.location(in: view)
    touchAngle = angle(for: touchPoint, in: view)
    
      print("touchAngle: \(touchAngle)")
  }

  private func angle(for point: CGPoint, in view: UIView) -> CGFloat {
    let centerOffset = CGPoint(x: point.x - view.bounds.midX, y: point.y - view.bounds.midY)
    
 
    
    print("point.x: \(point.x)")
      print("view.bounds.midX: \(view.bounds.midX)")
     print(" point.y: \( point.y)")
         print(" view.bounds.midY: \( view.bounds.midY)")
    
    
    return atan2(centerOffset.y, centerOffset.x)
  }

  override init(target: Any?, action: Selector?) {
    super.init(target: target, action: action)

    maximumNumberOfTouches = 1
    minimumNumberOfTouches = 1
  }
}







class LoadingProcess {
  
  let minValue: Int
  let maxValue: Int
  var currentValue: Int
  
  private let progressQueue = DispatchQueue(label: "ProgressView")
  private let semaphore = DispatchSemaphore(value: 1)
  
  init (minValue: Int, maxValue: Int) {
    self.minValue = minValue
    self.currentValue = minValue
    self.maxValue = maxValue
  }
  
  private func delay(stepDelayUsec: useconds_t, completion: @escaping ()->()) {
    usleep(stepDelayUsec)
    DispatchQueue.main.async {
      completion()
    }
  }
  
  func simulateLoading(toValue: Int, step: Int = 1, stepDelayUsec: useconds_t? = 10_000,
                       valueChanged: @escaping (_ currentValue: Int)->(),
                       completion: ((_ currentValue: Int)->())? = nil) {
    
    semaphore.wait()
    progressQueue.sync {
      if currentValue <= toValue && currentValue <= maxValue {
        usleep(stepDelayUsec!)
        DispatchQueue.main.async {
          valueChanged(self.currentValue)
          self.currentValue += step
          self.semaphore.signal()
          self.simulateLoading(toValue: toValue, step: step, stepDelayUsec: stepDelayUsec, valueChanged: valueChanged, completion: completion)
        }
        
      } else {
        self.semaphore.signal()
        completion?(currentValue)
      }
    }
  }
  
  func finish(step: Int = 1, stepDelayUsec: useconds_t? = 10_0,
              valueChanged: @escaping (_ currentValue: Int)->(),
              completion: ((_ currentValue: Int)->())? = nil) {
    simulateLoading(toValue: maxValue, step: step, stepDelayUsec: stepDelayUsec, valueChanged: valueChanged, completion: completion)
  }
}

