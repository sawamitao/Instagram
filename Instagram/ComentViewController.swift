//
//  ComentViewController.swift
//  Instagram
//
//  Created by 田尾　早和美 on 2021/04/21.
//

import UIKit
import Firebase

import SVProgressHUD
var content_id :Int = 0

class ComentViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    var content_id: String = ""
    @IBAction func button(_ sender: Any) {
        let washingtonRef = Firestore.firestore().collection(Const.PostPath).document(content_id)
        washingtonRef.collection("comment")
            .document()
            .setData([
                "comment": textField.text!,
                "name": Auth.auth().currentUser!.displayName!
            ],
            completion: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
    }
}

