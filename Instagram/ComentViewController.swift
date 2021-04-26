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
    let formatter = DateFormatter()
    @IBAction func button(_ sender: Any) {
        let dt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
        let washingtonRef = Firestore.firestore().collection(Const.PostPath).document(content_id)
        washingtonRef.collection("comment")
            .document()
            .setData([
                "comment": textField.text!,
                "name": Auth.auth().currentUser!.displayName!,
                "comment_time":dateFormatter.string(from: dt)
            ],
            completion: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
        let postRef = Firestore.firestore().collection(Const.PostPath).document(content_id)
        postRef.updateData(["last_comment_time": dateFormatter.string(from: dt)])
    }
}

