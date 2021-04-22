//
//  ComentViewController.swift
//  Instagram
//
//  Created by 田尾　早和美 on 2021/04/21.
//

import UIKit
import Firebase

import SVProgressHUD


class ComentViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    var content_id:Int = 0 
    override func viewDidLoad() {
        super.viewDidLoad()
       

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func button(_ sender: Any) {
        
        let HomeViewController = self.storyboard?.instantiateViewController(withIdentifier:"Home") as! HomeViewController
        self.present(HomeViewController,animated:true,completion: nil)
//        self.dismiss(animated: true, completion: nil)
        HomeViewController.addComent = textField.text!
    }
    
}
