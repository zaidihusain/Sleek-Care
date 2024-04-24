//
//  PrescriptionView.swift
//  SleekCare
//
//  Created by Nabeel on 28/01/24.
//

import UIKit

import FirebaseAuth
//import FirebaseFirestore
import MLKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


class PrescriptionViewController: UIViewController, DrawingViewDelegate {
    
    
    
    var medicineName : [String] = [""]

    @IBAction func clearrButton(_ sender: Any) {
       
   
                                      drawingView.clear()

               // Remove additional subviews
        for transcriptionView in transcriptionViews {
            transcriptionView.removeFromSuperview()
            
        }
        transcriptionViews.removeAll()
               // Create a new TranscriptionView
//               setupTranscriptionView()
                
        }
    
    
    @IBOutlet private weak var editorContainerView: UIView!

    private var drawingView: DrawingView!
     var transcriptionViews: [TranscriptionView] = []// Maintain a collection of TrancriptionView instances
//    var printObject = PrintViewController()
 
 
    var prescriptionArray: [String] {
        get {
            return PrescriptionDataManager.shared.prescriptionArray
        }
        set {
            PrescriptionDataManager.shared.prescriptionArray = newValue
        }
    }
    func navbar(){
//resizing print button
        let image = UIImage(named: "Staff")
        let resizedImage = image?.resized(to: CGSize(width: 35, height: 35))
        
        
        let navBarBackgroundView = UIView(frame: CGRect(x: 0, y: -UIApplication.shared.statusBarFrame.height, width: view.frame.size.width, height: 80 + UIApplication.shared.statusBarFrame.height))
                navBarBackgroundView.backgroundColor = UIColor(named: "NavigationBarColor")
        print(80 + UIApplication.shared.statusBarFrame.height)

        
        navigationController?.navigationBar.addSubview(navBarBackgroundView)
                navigationController?.navigationBar.sendSubviewToBack(navBarBackgroundView)

        navigationController?.navigationBar.barTintColor = UIColor.white // Set to clear, as the custom background view will provide the color
                navigationController?.navigationBar.tintColor = .white // Set the color for back button, title, and other items.
                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

//
        
     
//        let customNavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 74))
//        customNavigationBar.barTintColor = UIColor.cyan
        navBarBackgroundView.tintColor = .white // Set the color for back button, title, and other items.
//              customNavigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//
//              // Add the custom navigation bar to the view
              view.addSubview(navBarBackgroundView)
              

         // Create your three buttons
         let penButton = UIBarButtonItem(image: UIImage(named: "pen"), style: .plain, target: self, action: #selector(buttonTapped(_:)))
         let eraserButton = UIBarButtonItem(image: UIImage(named: "eraser"), style: .plain, target: self, action: #selector(buttonTapped(_:)))
         let printButton = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(buttonTapped(_:)))
        let backButton = UIBarButtonItem(image: UIImage(named: "Vector"), style: .plain, target: self, action: #selector(buttonTapped(_:)))
        let button5 = UIBarButtonItem(title: "JON SNOW", style: .plain, target: self, action: #selector(buttonTapped(_:)))

        
    
        // Create an attributed string for the button's title with bold font
        let attributes: [NSAttributedString.Key: Any] = [
                  .font: UIFont.boldSystemFont(ofSize: 25), // Adjust the font size as needed
                  .foregroundColor: UIColor.white
              ]
        button5.setTitleTextAttributes(attributes, for: .normal)

        
         //UILabel
        let titleLabel = UILabel()
                titleLabel.text = "Title"
                titleLabel.textColor = .white

        
         // Set the tag for each button to identify them
        
         penButton.tag = 1
         eraserButton.tag = 2
         printButton.tag = 3
        backButton.tag = 4
         
         // Set the buttons as the right bar button items
         navigationItem.rightBarButtonItems = [printButton, eraserButton, penButton]
        navigationItem.leftBarButtonItems = [backButton,button5]
     }
     
     @objc func buttonTapped(_ sender: UIBarButtonItem) {
         switch sender.tag {
         case 1:
             // Handle Button 1 tap event here
             print("Button 1 tapped!")
         case 2:
             // Handle Button 2 tap event here
             print("Button 2 tapped!")
             
                                                drawingView.clear()

                         // Remove additional subviews
                  for transcriptionView in transcriptionViews {
                      transcriptionView.removeFromSuperview()
                      
                  }
                  transcriptionViews.removeAll()
             PrescriptionDataManager.shared.prescriptionArray = [""] 
             
                         // Create a new TranscriptionView
          //               setupTranscriptionView()
         case 3:
             // Handle Button 3 tap event here
     
             
             let labelTexts = drawingView.getAllLabelTexts(from: self.view)
          
             for i in labelTexts {
                 prescriptionArray.append(i)
             }
             
           
//             delegate?.arrayDidChange(array: medicineName)
             print(prescriptionArray)
             
//             printObject.changeLabel()
//             print(printObject.showMedName.count, "AZAA")
             
             
//             if drawingView.showMedName.count == 5 {
//                 printObject.med1.text = drawingView.showMedName[1] ?? "Agumentin 375"
//                 printObject.med2.text = drawingView.showMedName[2] ?? "Avil Tablet"
//                 printObject.med3.text = drawingView.showMedName[3] ?? "z"
//                 printObject.med4.text = drawingView.showMedName[4] ?? "x"
//             } else if drawingView.showMedName.count == 4 {
//                 printObject.med1.text = drawingView.showMedName[1] ?? "z"
//                 printObject.med2.text = drawingView.showMedName[2] ?? "x"
//                 printObject.med3.text = drawingView.showMedName[3] ?? "m"
//             } else if drawingView.showMedName.count == 3 {
//                 printObject.med1.text = drawingView.showMedName[1] ?? "w"
//                 printObject.med2.text = drawingView.showMedName[2] ?? "q"
//             } else if drawingView.showMedName.count == 2 {
//                 printObject.med1.text = drawingView.showMedName[1] ?? "n"
//             }


   
             navigateToViewControllerB()
         case 4:
             _ = navigationController?.popViewController(animated: true)
             print("button 4 tapped")

         default:
             break
         }
     

    }
    func navigateToViewControllerB() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewControllerBID") as! PrescriptionWindow
        self.navigationController?.pushViewController(nextViewController, animated: true)
     }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize and configure the DrawingView
        drawingView = DrawingView(frame: editorContainerView.bounds)
        drawingView.delegate = self
        drawingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
   
//        printObject.med1.text = "Augmentin 375"
//        printObject.med2.text = "Azel 80 capsule"
//        printObject.med3.text = "Azithral 500 Tablet"
//        printObject.med4.text = "Aricep 5 Tablet"
        
        // Add the DrawingView to the editorContainerView
        editorContainerView.addSubview(drawingView)
        drawingView.isLanguageDownloaded(languageTag: "en-GB")
        drawingView.downloadModel()
        
         //whatever height you want to add to the existing height
        navbar()
        
    }
    
    //to expose the array
    
    // Delegate method called when recognition finishes with candidates
    func drawingView(_ drawingView: DrawingView, didFinishRecognitionWithText candidates: [String], atFrame frame: CGRect) {
        // Calculate the y position based on the line number
        let yPosition = drawingView.newAreaNo * drawingView.lineSpacing + 770
        
        
        
        // Check if a TranscriptionView already exists for this line
        if let transcriptionView = transcriptionViews.first(where: { $0.frame.origin.y == yPosition }) {
            
            // Append the recognized text to the existing TranscriptionView
            if let firstNonEmptyCandidate = candidates.first(where: { !$0.isEmpty }) {
                transcriptionView.label.text = firstNonEmptyCandidate
                if firstNonEmptyCandidate.count > 2 {
                    transcriptionView.label.text = firstNonEmptyCandidate

                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        if let medNameAtIndex1 = drawingView.medName.indices.contains(1) ? drawingView.medName[1] : nil {
//                            self.printObject.showMedName.append(medNameAtIndex1)

                            transcriptionView.label.text = medNameAtIndex1
                            transcriptionView.candidates = Array(drawingView.medName[1...min(6, drawingView.medName.count - 1)])
                            
                        } else {
                            print("medNameAtIndex1 is nil")
                        }
                    }
                } else {
                    transcriptionView.label.text = firstNonEmptyCandidate
                    print(firstNonEmptyCandidate.count)
                }

                transcriptionView.candidates = candidates

                print(drawingView.newAreaNo, drawingView.areaNo)
            }

            
            
            
            
        } else {
            // Create a new TranscriptionView for the transcription
            let transcriptionViewFrame = CGRect(x: drawingView.touchbegans, y: yPosition, width: Double(drawingView.width), height: drawingView.lineSpacing)
            
            let transcriptionView = TranscriptionView(text: "" , frame: transcriptionViewFrame)
            transcriptionView.label.sizeToFit()
            transcriptionView.label.numberOfLines = 0
            transcriptionView.label.textAlignment = .left
            transcriptionView.candidates = candidates
            self.view.addSubview(transcriptionView)
            transcriptionViews.append(transcriptionView)  // Add the new TranscriptionView to the collection
            
            
            // Set the text of the new TranscriptionView
            if let firstNonEmptyCandidate = candidates.first(where: { !$0.isEmpty }) {
                if firstNonEmptyCandidate.count > 2 {
                    transcriptionView.label.text = firstNonEmptyCandidate
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        do {
                            if let medNameAtIndex1 = drawingView.medName.indices.contains(1) ? drawingView.medName[1] : nil {
                                transcriptionView.label.text = medNameAtIndex1
                                print("mymed: ", medNameAtIndex1)
                                transcriptionView.candidates = Array(drawingView.medName[1...min(6, drawingView.medName.count-1)])
                            } else {
                                // Handle the case when medNameAtIndex1 is nil
                                print("medNameAtIndex1 is nil")
                                transcriptionView.label.text = firstNonEmptyCandidate
                                
                            }
                        } catch {
                            print("Indexing error occurred: \(error)")
                            transcriptionView.label.text = firstNonEmptyCandidate
                        }
                    }
                }
            }
            else {
                transcriptionView.label.text = ""
            }
            
            // Reset the recognizer
            //            drawingView.resetRecognizer()
        }
//        func pushToFirebase(medicine : [String]) {
//            
//                    
//                    // Ensure the user is authenticated
//                    guard let user = Auth.auth().currentUser else {
//                        print("User not authenticated")
//                        return
//                    }
//                    
//                    // Get a reference to the database
//                    let ref = Database.database().reference()
//                    
//                    // Create a node for the current user if it doesn't exist or select it if it does
//                    let userRef = ref.child("userData").child(user.uid)
//                    
//                    // Push the array of strings to this user's node
//                    // You might want to structure your data according to your needs. Here we're setting a child node named "userStrings"
//                    userRef.child("Medicine").setValue(medicine) { (error, reference) in
//                        if let error = error {
//                            print("Data could not be saved: \(error).")
//                        } else {
//                            print("Data saved successfully!")
//                        }
//                    }
//        }
    }
    
    func getMedicineNames() -> [String] {
         return medicineName
     }
    
    func populateMedicineNames() {
        if let drawingView = drawingView {
            let labelTexts = drawingView.getAllLabelTexts(from: self.view)
            for i in labelTexts {
                medicineName.append(i)
            }
        } else {
            print("drawingView is nil")
        }
    }
    
//    
//    func loadMed(){
//        let labelTexts = drawingView.getAllLabelTexts(from: self.view)
//     
//        for i in labelTexts {
//            medicineName.append(i)
//        }
//    }
//    var exposeArray: [String] {
//        return medicineName
//    }
//    var completionHandler: (() -> Void)?
//
//    @objc func buttonTapped(_ sender: UIBarButtonItem) {
//        let labelTexts = drawingView.getAllLabelTexts(from: self.view)
//        for i in labelTexts {
//            medicineName.append(i)
//        }
//        
//        // Call the completion handler after populating the array
//        completionHandler?()
//    }
//
//    func uploadImageToFirebaseStorage(image: UIImage) {
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
//            print("Failed to convert image to data.")
//            return
//        }
//
//        let storageRef = Storage.storage().reference()
//        let imageRef = storageRef.child("images").child("Prescription.png")
//
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/png"
//
//        imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
//            guard let metadata = metadata else {
//                print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//
//            print("Image uploaded successfully. Download URL: \(metadata.downloadURL?.absoluteString ?? "")")
//        }
//    }
    
    //For mlmodel
//    let segueIdentifier = "YourSegueIdentifier"
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == segueIdentifier {
//            // Perform any necessary data preparation here
//        }
//    }
    
    
}



