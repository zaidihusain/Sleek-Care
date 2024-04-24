//
//  DashboardViewController.swift
//  SleekCare
//
//  Created by Nabeel on 28/01/24.
//

import UIKit

class DashboardViewController: UIViewController{
    
    // MARK: - Outlets
    //        @IBOutlet weak var historyButton: UIButton!
    //        @IBOutlet weak var writePrescriptionButton: UIButton!
    @IBOutlet weak var phoneNo: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var doctorName: UILabel!
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    ConstrainForProfilePic()
        
        
        
        
        
// Additional setup if needed

    }
    
    // MARK: - Actions
    @IBAction func historyButtonTapped(_ sender: UIButton) {
  
    }
    
    @IBAction func writePrescriptionButtonTapped(_ sender: UIButton) {
        // Navigate to PrescriptionViewController
        //            navigateToPrescription()
    }
    
    
    
    func ConstrainsForDoctorName(){
        // Creating the doctorName label
        
           doctorName.textColor = UIColor(red: 0.039, green: 0.039, blue: 0.039, alpha: 1)
           doctorName.font = UIFont(name: "Poppins-Medium", size: 18)
           doctorName.text = "Amber Hania"

           // Adding doctorName to the view hierarchy
           view.addSubview(doctorName)

           // Setting up AutoLayout constraints for horizontally centering the label
           doctorName.translatesAutoresizingMaskIntoConstraints = false
           doctorName.widthAnchor.constraint(equalToConstant: 120).isActive = true
           doctorName.heightAnchor.constraint(equalToConstant: 27).isActive = true
           doctorName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           doctorName.topAnchor.constraint(equalTo: view.topAnchor, constant: 109).isActive = true
        


    }
    
    
    func ConstrainForProfilePic(){
        
         profileImage.layer.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
         
         // Make profileImage circular
         profileImage.layer.cornerRadius = profileImage.frame.width / 2
         profileImage.clipsToBounds = true

         
   
    }
    
    //        // MARK: - Navigation
    //        private func navigateToHistory() {
    //            guard let historyVC = storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController else {
    //                return
    //            }
    //            navigationController?.pushViewController(historyVC, animated: true)
    //        }
    //
            private func navigateToPrescription() {
                guard let prescriptionVC = storyboard?.instantiateViewController(withIdentifier: "PrescriptionViewController") as? PrescriptionViewController else {
                    return
                }
                navigationController?.pushViewController(prescriptionVC, animated: true)
            }
        
    
}

