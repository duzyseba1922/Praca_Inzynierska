import UIKit
import Firebase

class TableManagerController: UIViewController {

    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    
    var list = [[String]]()
    var team: String = ""
    var chosenOption: String = ""
    var chosenTab: String = ""
    
    @IBOutlet weak var points: UITextField!
    @IBOutlet weak var goalsConceded: UITextField!
    @IBOutlet weak var goalsScored: UITextField!
    @IBOutlet weak var matchesPlayed: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        getTable()
        confirmButton.layer.cornerRadius = 10
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func getTable(){
        refHandle = ref?.child("Table").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
            }
        
            for x in 0...self.list.count - 1 {
                if self.list[x][0] == self.team {
                    self.matchesPlayed.text! = self.list[x][1]
                    if let range = self.list[x][2].range(of: ":") {
                        let goalsC = self.list[x][2][range.upperBound...]
                        let goalsS = self.list[x][2][self.list[x][2].startIndex..<range.lowerBound]
                        self.goalsConceded.text! = "\(goalsC)"
                        self.goalsScored.text! = "\(goalsS)"
                    }
                    self.points.text! = self.list[x][3]
                }
            }
        })
    }
        
    @IBAction func confirmButton(_ sender: Any) {
        for x in 0...self.list.count - 1 {
            if self.list[x][0] == self.team {
                if (matchesPlayed.text != "" && goalsScored.text != "" && goalsConceded.text != "" && points.text != "") {
                    ref?.child("\(chosenTab)/\(x)/1").setValue(matchesPlayed.text!)
                    ref?.child("\(chosenTab)/\(x)/2").setValue("\(goalsScored.text!):\(goalsConceded.text!)")
                    ref?.child("\(chosenTab)/\(x)/3").setValue(points.text!)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("error")
                }
            }
        }
    }
    
    @objc func DismissKeyboard() {
        self.view.endEditing(true)
    }

}
