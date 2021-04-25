//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 田尾　早和美 on 2021/04/18.
//
import UIKit
import FirebaseUI
import Firebase

class PostTableViewCell: UITableViewCell {
 
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var comentButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!

    @IBOutlet weak var comentLabel: UITextView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // PostDataの内容をセルに表示
    func setPostData(_ postData: PostData) {
        // 画像の表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with: imageRef)

//        // キャプションの表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"


        // 日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }

        // いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"

        // いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        //コメントの表示
        var comment_set = [""]
        Firestore.firestore().collection(Const.PostPath).document(postData.id).collection("comment").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let comment = document.get("comment") as! String
                    let name = document.get("name") as! String
                    comment_set .append(comment+""+name)
                
                }
            var i = 0
            var coment_text:String = ""
            while i < comment_set.count{
                coment_text = coment_text + "\(comment_set[i])"+"\r\n"
                i = i+1
            self.comentLabel.text = coment_text
                    
                    
            
                }
                
            }
        }
        

        

    }
    
    
    
}

