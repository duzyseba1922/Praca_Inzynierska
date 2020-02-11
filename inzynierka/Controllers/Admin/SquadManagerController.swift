import UIKit
import Firebase

protocol squadDelegate {
   func updateSquad()
}

class SquadManagerController: UIViewController {

    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    var delegate: squadDelegate!
    
    var list = [[String]]()
    var team: String = ""
    var chosenOption: String = ""
    var chosenTab: String = ""
    var cellId: Int = 0
    var counter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        getSquad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func getSquad(){
        refHandle = ref?.child("Squad/\(team)/Trener").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
            }
        })
        refHandle = ref?.child("Squad/\(team)/Bramkarze").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
            }
        })
        refHandle = ref?.child("Squad/\(team)/Obrońcy").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
            }
        })
        refHandle = ref?.child("Squad/\(team)/Pomocnicy").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
            }
        })
        refHandle = ref?.child("Squad/\(team)/Napastnicy").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
            }
        })
    }
    
//    @IBAction func confirmButton(_ sender: Any) {
//        if chosenOption == "add" {
//            ref?.child("\(chosenTab)/\(team)/\(list.count)/0").setValue(newsTitle.text!)
//            ref?.child("\(chosenTab)/\(team)/\(list.count)/1").setValue(newsContent.text!)
//            self.dismiss(animated: true, completion: nil)
//        } else if chosenOption == "edit" {
//            ref?.child("\(chosenTab)/\(team)/\(cellId)/0").setValue(newsTitle.text!)
//            ref?.child("\(chosenTab)/\(team)/\(cellId)/1").setValue(newsContent.text!)
//            delegate.updateNews()
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
    
    @objc func DismissKeyboard() {
        self.view.endEditing(true)
    }
}
