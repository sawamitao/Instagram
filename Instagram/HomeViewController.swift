import UIKit
import Firebase
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    // 投稿データを格納する配列
    var postArray: [PostData] = []
    var addComent:String = ""
    var addComentName:String = ""
    

    // Firestoreのリスナー
    var listener: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        // ログイン済みか確認
        if Auth.auth().currentUser != nil {
            // listenerを登録して投稿データの更新を監視する
            let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                self.postArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                    var updateValue: FieldValue
                    var updateNameValue: FieldValue
                    let postData = PostData(document: document)
                    print ("追加コメント\(self.addComent)")
                    if  self.addComent != "" {
                        self.addComentName = (Auth.auth().currentUser?.displayName)!
                        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
                       
                        updateNameValue =  FieldValue.arrayUnion([self.addComentName])
                        updateValue = FieldValue.arrayUnion([self.addComent])
                        
                       
                        print("コメント者\(updateValue)")
                        
                        postRef.updateData(["coment_name":updateNameValue])
                        postRef.updateData(["coment":updateValue])
                        print(updateNameValue)
                    }
                    return postData
                }
                // TableViewの表示を更新する
                self.tableView.reloadData()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        // listenerを削除して監視を停止する
        listener?.remove()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])

        // セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        // セル内のボタンのアクションをソースコードで設定する
        cell.comentButton.addTarget(self, action:#selector(comentButton(_:forEvent:)), for: .touchUpInside)

        return cell
    }
    @objc func comentButton(_ sender: UIButton, forEvent event: UIEvent) {
        // タップされたセルのインデックスを求める
       
        print("DEBUG_PRINT: comentボタンがタップされました。")
        
        let comentViewController = self.storyboard?.instantiateViewController(withIdentifier:"coment") as! ComentViewController
        self.present(comentViewController,animated:true,completion: nil)
//        comentViewController.postRef = postRef
        
    }

    // セル内のボタンがタップされた時に呼ばれるメソッド
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        print("DEBUG_PRINT: likeボタンがタップされました。")
       
        
        

        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]

        // likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            // 更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                // すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                // 今回新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            // likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
    
//    // セル内のボタンがタップされた時に呼ばれるメソッド
//    @objc func comentButton(_ sender: UIButton, forEvent event: UIEvent) {
//        
//        print("DEBUG_PRINT: コメントボタンがタップされました")
//        
//        
//    }

}
