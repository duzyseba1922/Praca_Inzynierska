import UIKit
import Firebase

protocol newsDelegate {
   func updateNews()
}

class NewsManagerController: UIViewController,UITextViewDelegate {

    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    var delegate: newsDelegate!
    
    var list = [[String]]()
    var team: String = ""
    var chosenOption: String = ""
    var chosenTab: String = ""
    var cellId: Int = 0
    var intKeys = [Int]()
    
    @IBOutlet weak var newsTitle: UITextView!
    @IBOutlet weak var newsContent: UITextView!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTitle.layer.cornerRadius = 20
        newsContent.layer.cornerRadius = 20
        confirmButton.layer.cornerRadius = 10
        
        if chosenOption == "edit" {
            newsTitle.text = list[cellId][0]
            newsContent.text = list[cellId][1]
        }
        
        ref = Database.database().reference()
        getNews()
        getKeys()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func getKeys(){
        ref?.child("\(chosenTab)/\(team)").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = Int(snap.key)
                self.intKeys.append(key!)
            }
        })
    }
    
    func getNews(){
        refHandle = ref?.child("News/\(team)").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
            }
        })
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        if chosenOption == "add" {
            ref?.child("\(chosenTab)/\(team)/\(String(describing: intKeys.max() ?? -1 + 1))/0").setValue(newsTitle.text!)
            ref?.child("\(chosenTab)/\(team)/\(String(describing: intKeys.max() ?? -1 + 1))/1").setValue(newsContent.text!)
            self.dismiss(animated: true, completion: nil)
        } else if chosenOption == "edit" {
            ref?.child("\(chosenTab)/\(team)/\(cellId)/0").setValue(newsTitle.text!)
            ref?.child("\(chosenTab)/\(team)/\(cellId)/1").setValue(newsContent.text!)
            delegate.updateNews()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func DismissKeyboard() {
        self.view.endEditing(true)
    }
}
