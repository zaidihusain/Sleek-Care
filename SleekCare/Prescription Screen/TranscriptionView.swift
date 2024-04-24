//
//  TranscriptionView.swift
//  SleekCare
//
//  Created by Nabeel on 28/01/24.
//

import UIKit

class TranscriptionView: UIView {
    weak var viewController: UIViewController?
    let label: UILabel
    var candidates: [String] = []
    var myMedArr: [String] = []
    //Code initializes when Transcription View is initialized
    init(text: String, frame: CGRect) {
        // Create and configure the label
        label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .center
//        label.layer.borderColor = UIColor(cgColor:.init(red: 10.00, green: 20.00, blue: 5.00, alpha: 6.00))
        // Call the superclass's initializer
        super.init(frame: frame)
        
        // Add the label to the view hierarchy
        addSubview(label)
        
        // Turn off autoresizing mask translation
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints to position and size the label
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        // Setup tap gesture
        setupTapGesture()
    }
   
        

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: "Select a Candidate", preferredStyle: .actionSheet)
        
        for candidate in candidates {
            let action = UIAlertAction(title: candidate, style: .default) { [weak self] _ in  // candidate -> Array(DrawingView().medName.prefix(5)
                self?.label.text = candidate
                self?.myMedArr.append(candidate)
            }
            alert.addAction(action)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self
            popoverController.sourceRect = CGRect(x: self.bounds.midX, y: self.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        if let viewController = self.window?.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateCandidates(candidates: [String]) {
        self.candidates = candidates
    }
    
    
    

}


