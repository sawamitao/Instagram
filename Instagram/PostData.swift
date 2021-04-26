//
//  PostData.swift
//  Instagram
//
//  Created by 田尾　早和美 on 2021/04/18.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    var comment: [String] = []
    var comment_name: [String] = []
    var isComented: Bool = false
    var last_comment_time: Date?
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID

        let postDic = document.data()

        self.name = postDic["name"] as? String
        self.caption = postDic["caption"] as? String

        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        let timestamp_comment = postDic["last_comment_time"] as? Timestamp
        self.date = timestamp_comment?.dateValue()

        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        
        if let comment = postDic["comment"] as? [String] {
            self.comment = comment
        }
        if let comment_name = postDic["comemnt_name"] as? [String] {
            self.comment_name = comment_name
        }
        
        if let myid = Auth.auth().currentUser?.uid {
            // likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているかを判断
            if self.likes.firstIndex(of: myid) != nil {
                // myidがあれば、いいねを押していると認識する。
                self.isLiked = true
            }
        }

    }
}
