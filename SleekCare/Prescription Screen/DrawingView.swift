//
//  DrawingView.swift
//  SleekCare
//
//  Created by Nabeel on 28/01/24.
//

import UIKit
import MLKit

protocol DrawingViewDelegate: AnyObject {
    func drawingView(_ drawingView: DrawingView, didFinishRecognitionWithText candidates: [String], atFrame frame: CGRect)
}


class DrawingView: UIView {

    //delegate
    var candidatesArray = [String]()
    //    var printObj = PrintViewController()
    private var transcriptionView: TranscriptionView?
    weak var delegate: DrawingViewDelegate?
    var areaNo: CGFloat = 0.0
    private var isAreaNoAssigned = false
    var newAreaNo:CGFloat = 0.0
    var touchbegans = 0.0
    var width = 0.00
    var whereTouchedPreviouslyY:CGFloat = 0.00
    var whereTouchedY:CGFloat = 0.00
    var whereTouchedPreviouslyX:CGFloat = 0.00
    var whereTouchedX:CGFloat = 0.00
    var medsOnPrescription:[String] = [""]
    struct Path {
        let color: UIColor
        var strokePoints: [StrokePoint]
    }
    
    // Download the model for the language you want to recognize
    let modelManager = ModelManager.modelManager()
    let identifier = DigitalInkRecognitionModelIdentifier(forLanguageTag: "en-US")!
    let downloadConditions = ModelDownloadConditions(allowsCellularAccess: false, allowsBackgroundDownloading: true)
    /** Properties to track and manage the selected language and recognition model. */
    lazy var model: DigitalInkRecognitionModel? = {
        let identifier = DigitalInkRecognitionModelIdentifier(forLanguageTag: "en-US")
        return DigitalInkRecognitionModel(modelIdentifier: identifier!)
    }()
    
    //API
    var threeWord = "AUGM"
    var medName = [String()] ?? [""]
    
    // Horizontal Line
    let lineSpacing: CGFloat = 50.0
    
    //ML kit requirement
    var kMillisecondsPerTimeInterval = 1000.0
    var lastPoint = CGPoint.zero
    private var strokes: [Stroke] = []
    private var points: [StrokePoint] = []
    var recognizer: DigitalInkRecognizer! = nil
    
    
    // Track the paths for drawing
    private var paths: [UIBezierPath] = []
    private var currentPath: UIBezierPath?
    private var previousTouchPoint: CGPoint?
    
    // Initialize the view with a transparent background color
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    // Initialize the view from Interface Builder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }
    
    // Set up initial drawing settings
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.isMultipleTouchEnabled = false
        
        
        
        
    }
    
    // Start tracking a new touch event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.points = []
        
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        previousTouchPoint = touchPoint
        currentPath = UIBezierPath()
        currentPath?.lineWidth = 3.0
        currentPath?.lineCapStyle = .round
        currentPath?.move(to: touchPoint)
        lastPoint = touch.location(in: self)
        touchbegans = touch.location(in: self).x
        whereTouchedY = touch.location(in: self).y
        whereTouchedX = touch.location(in: self).x
        let t = touch.timestamp
        points = [StrokePoint.init(x: Float(lastPoint.x),
                                   y: Float(lastPoint.y),
                                   t: Int(t * kMillisecondsPerTimeInterval))]
        
        //because array append every time you draw so it resets it
        candidatesArray.removeAll()
        
        setNeedsDisplay()
        // Changes and check the value of NewAREA and oldAREA
        newAreaNo = floor((touch.location(in: self).y) / lineSpacing)
        
        if !isAreaNoAssigned {
            areaNo = newAreaNo
            isAreaNoAssigned = true
        } else {
            
            print("yo")
            
            print(newAreaNo,areaNo, "ASSS")
            
        }
        let currentAreaNo = floor(((touch.location(in: self).y)) / lineSpacing)
        let NewcurrentAreaNo = floor(((touch.location(in: self).y)-386) / lineSpacing)
        //
        //          If this is the first stroke or the stroke is in the same area as the previous stroke
        if !isAreaNoAssigned || NewcurrentAreaNo == areaNo  {
            newAreaNo = NewcurrentAreaNo
            isAreaNoAssigned = true
        } else {
            // If the stroke is in a different area
            resetRecognizer()
            medName.append(medName[0])
            newAreaNo = NewcurrentAreaNo
            areaNo = newAreaNo
        }
        
        
        //        if ((whereTouchedY < (whereTouchedPreviouslyY+50)) || ((whereTouchedPreviouslyY-50) > (whereTouchedY))) {
        //            whereTouchedPreviouslyY = whereTouchedY
        //            whereTouchedPreviouslyX = whereTouchedX
        //            print(whereTouchedPreviouslyY,whereTouchedY,"not reset")
        //
        //
        //        }else{
        //            resetRecognizer()
        //
        //            print(whereTouchedPreviouslyY,whereTouchedY, "reset")
        //            whereTouchedPreviouslyY = whereTouchedY
        //        }
        //        if (newAreaNo == areaNo)||((newAreaNo)==areaNo+1.0){
        //            isAreaNoAssigned = true
        //            areaNo = newAreaNo
        //
        //        }else{
        //            resetRecognizer()
        //          areaNo = newAreaNo
        //
        //
        //        }
        
        
    }
    
    // Track touch movement and draw a line
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let currentPath = currentPath else { return }
        let touchPoint = touch.location(in: self)
        currentPath.addQuadCurve(to: touchPoint, controlPoint: previousTouchPoint ?? touchPoint)
        previousTouchPoint = touchPoint
        
        let currentPoint = touch.location(in: self)
        let t = touch.timestamp
        let strokePoint = StrokePoint(x: Float(currentPoint.x), y: Float(currentPoint.y), t: Int(t * kMillisecondsPerTimeInterval))
        points.append(strokePoint)
        lastPoint = currentPoint
        addPointToCurrentStroke(currentPoint)
        //
        setNeedsDisplay()
    }
    
    // Finish drawing when touch ends
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentPath = currentPath else { return }
        paths.append(currentPath)
        self.currentPath = nil
        guard let touch = touches.first else {
            return
        }
        let currentPoint = touch.location(in: self)
        let t = touch.timestamp
        points.append(StrokePoint.init(x: Float(currentPoint.x),
                                       y: Float(currentPoint.y),
                                       t: Int(t * kMillisecondsPerTimeInterval)))
        lastPoint = currentPoint
        // Add the current stroke to the list of strokes
        strokes.append(Stroke.init(points: points))
        // Clear the points of the current stroke
        width = (touch.location(in: self).x - touchbegans + 350)
        // Request the system to redraw the view
        setNeedsDisplay()
        // Call the recognition function (not defined in this snippet)
        doRecognition()
        
    }
    
    
    private func addPointToCurrentStroke(_ point: CGPoint) {
        let timestamp = Date().timeIntervalSince1970 * 1000
        let inkPoint = StrokePoint(x: Float(point.x), y: Float(point.y), t: Int((timestamp)))
        points.append(inkPoint)
    }
    /**
     * Given a language tag, looks up the cooresponding model identifier and initializes the model. Note
     * that this doesn't actually download the model, which is triggered manually by the user for the
     * purposes of this demo app.
     */
    func selectLanguage(languageTag: String) {
        let identifier = DigitalInkRecognitionModelIdentifier(forLanguageTag: "en-US")
        model = DigitalInkRecognitionModel.init(modelIdentifier: identifier!)
        recognizer = nil
        
    }
    
    
    // Draw the path
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        for path in paths {
            UIColor.black.setStroke()
            path.stroke()
        }
        currentPath?.stroke()
        
        // Adding Vertical Lines
        guard let context = UIGraphicsGetCurrentContext() else { return }
        // Set the drawing parameters
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(0.50)
        context.setStrokeColor(UIColor.black.cgColor)
        
        for stroke in strokes {
            for i in 0..<stroke.points.count - 1 {
                let fromPoint = CGPoint(x: CGFloat(stroke.points[i].x), y: CGFloat(stroke.points[i].y))
                let toPoint = CGPoint(x: CGFloat(stroke.points[i+1].x), y: CGFloat(stroke.points[i+1].y))
                context.move(to: fromPoint)
                context.addLine(to: toPoint)
            }
        }
        context.strokePath()
        // Set the line properties
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(1.0)
        
        
        //         Draw horizontal lines lines
        let lineCount = Int(bounds.width / lineSpacing)
        let lineColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        let paddingLeft: CGFloat = 30.0
        let paddingRight: CGFloat = 20.0
        let totalLinesWidth = CGFloat(lineCount - 1) * lineSpacing
        let totalWidthWithPadding = totalLinesWidth + paddingLeft + paddingRight
        let centerX = (bounds.width - totalWidthWithPadding) / 2.0
        
        
        for i in 1..<lineCount {
            let y = CGFloat(i) * lineSpacing - 20.00
            context.setStrokeColor(lineColor)
            context.move(to: CGPoint(x: centerX, y: y))
            context.addLine(to: CGPoint(x: centerX + paddingLeft + totalLinesWidth, y: y))
            
            context.setStrokeColor(lineColor)
            context.strokePath()
        }
    }
    
    func downloadModel() {
        if modelManager.isModelDownloaded(model!) == true{
            print("Model is already downloaded")
            return
        }else{
            print("Starting download")      // The Progress object returned by `downloadModel` currently only takes on the values 0% or 100%
            // so is not very useful. Instead we'll rely on the outcome listeners in the initializer to
            // inform the user if a download succeeds or fails.
            modelManager.download(
                model!,
                conditions: ModelDownloadConditions.init(
                    allowsCellularAccess: true, allowsBackgroundDownloading: true)
                
            )
            print("start downloading")
        }
    }
    // Check whether the model for the given language tag is downloaded
    func isLanguageDownloaded(languageTag: String) -> Bool {
        let identifier = DigitalInkRecognitionModelIdentifier(forLanguageTag: "en-GB")
        let model = DigitalInkRecognitionModel.init(modelIdentifier: identifier!)
        return modelManager.isModelDownloaded(model)
        
    }
    
    func doRecognition() {
        // Get a recognizer for the language
        let options: DigitalInkRecognizerOptions = DigitalInkRecognizerOptions.init(model: model!)
        recognizer = DigitalInkRecognizer.digitalInkRecognizer(options: options)
        let ink = Ink.init(strokes: strokes)
        //            var candidatesArray = [String]()
        if recognizer != nil {
            recognizer.recognize(
                ink: ink,
                completion: {
                    [unowned self]
                    (result: DigitalInkRecognitionResult?, error: Error?) in
                    var alertTitle = ""
                    var alertText = ""
                    if let result = result, let candidate = result.candidates.first {
                        alertTitle = "I recognized this:"
                        alertText = candidate.text
                        
                        for x in 0...4{
                            
                            candidatesArray.append(result.candidates[x].text)
                            
                        }
                        
                        // After recognition:
                        if let error = error {
                            print("Recognition failed with error: \(error.localizedDescription)")
                        } else {
                            
                            if let candidate = result.candidates.first {
                                let recognizedText = candidate.text
                                let frame = CGRect(x: lastPoint.x, y: newAreaNo*lineSpacing, width: self.bounds.width, height: lineSpacing)
                                
                                //call the function from MVC and pass the array_name
                                delegate?.drawingView(self, didFinishRecognitionWithText: candidatesArray, atFrame: frame)
                                //Updating three words
                                threeWord = recognizedText
                                print(threeWord)
                                medName = [""]
                                if recognizedText.count > 2{
                                    
                                    fetchDataFromAPI(letters: threeWord)
                                    
                                }
                                
                                
                            } else {
                                print("Recognition completed but no results were found.")
                            }
                            
                            
                        }
                        
                    } else {
                        alertTitle = "I hit an error:"
                        alertText = error!.localizedDescription
                    }
                    let alert = UIAlertController(title: alertTitle,
                                                  message: alertText,
                                                  preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK",
                                                  style: UIAlertAction.Style.default,
                                                  handler: nil))
                    //          self.present(alert, animated: true, completion: nil)
                }
                
                
            )}else {
                print("recognizers nil")
            }
        
    }
    
    
    func clear() {
        // Clear the current path and all previous paths
        currentPath = nil
        paths.removeAll()
        
        // Clear the strokes and points used for recognition
        strokes.removeAll()
        points.removeAll()
        
        // Clear the recognizer
        recognizer = nil
        candidatesArray = [String()]
        
        
        // Request the system to redraw the view
        setNeedsDisplay()
    }
    func resetRecognizer(){
        // Clear the recognizer
        strokes.removeAll()
        points.removeAll()
        
        recognizer = nil
        candidatesArray = [String()]
        
        
    }
    
    func replaceSpacesWithUnderScores(input:String) -> String{
        return input.replacingOccurrences(of: " ", with: "")
    }
    
    
    func fetchDataFromAPI(letters:String) {
        
        struct APIResponse: Codable {
            let matched_words: [String]
            
            
        }
        // URL of the API you want to access
        let apiUrlString = "http://vrushali.pythonanywhere.com/autocomplete?med_name=\(letters)"
        let ModiefiedString = replaceSpacesWithUnderScores(input: apiUrlString)
        
        
        // Create a URL from the API URL string
        guard let url = URL(string: ModiefiedString) else {
            print("Invalid URL")
            return
        }
        
        // Create a URLSession configuration (optional, usually you can use the default one)
        let sessionConfig = URLSessionConfiguration.default
        
        // Create a URLSession instance
        let session = URLSession(configuration: sessionConfig)
        
        // Create a data task using the URL and session
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            // Check for errors
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // Check if we received any data
            guard let data = data else {
                print("No data received")
                return
            }
            let apiResponseData: Data = data
            
            //
            do {
                // Decode the JSON data using JSONDecoder
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(APIResponse.self, from: apiResponseData)
                
                // Access the first element in the "matched_words" array
                if let firstElement = apiResponse.matched_words.first {
                    // Output: "Augmexin Gel"
                    for x in apiResponse.matched_words {
                        self.medName.append(x)
                        
                        
                        //                        if self.printObj.med1.text == nil{
                        //                            self.printObj.med1.text = self.medName[0]
                        //                        } else if self.printObj.med2.text == nil{
                        //                            self.printObj.med2.text = self.medName[0]
                        //                        }else if self.printObj.med3.text == nil{
                        //                            self.printObj.med3.text = self.medName[0]
                        //
                        //                        }else if self.printObj.med4.text == nil{
                        //                            self.printObj.med4.text = self.medName[0]
                        //
                        //                        }
                        
                        
                        
                    }
                    //                    self.printObj.showMedName.append(self.medName[0])
                    print("ass: " ,self.medName[1])
                    
                } else {
                    print("No matched words found.")
                }
            } catch {
                print("Error decoding API response: \(error)")
            }
            
            
            DispatchQueue.main.async {
                // Update your UI or process the data here
            }
        }
        
        // Start the data task (this is what actually makes the API call)
        dataTask.resume()
    }
    func getAllLabelTexts(from view: UIView) -> [String] {
           var allTexts = [String]()

           for subview in view.subviews {
               if let label = subview as? UILabel {
                   if let text = label.text {
                       allTexts.append(text)
                   }
               } else {
                   // If the subview is not a UILabel, continue the search recursively in its subviews
                   allTexts.append(contentsOf: getAllLabelTexts(from: subview))
               }
           }

           return allTexts
       }
    
    
}

