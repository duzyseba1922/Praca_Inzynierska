import UIKit
import Firebase

class RecordsListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ref: DatabaseReference?
    var refHandle: DatabaseHandle?
    var team: String = ""
    var badge: UIImage?
    var chosenOption: String = ""
    var chosenTab: String = ""
    var list = [[String]]()
    var teams = [String]()
    var keys = [Int]()
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        ref = Database.database().reference()
        
        switch chosenTab {
            case "News":
                getNews()
            case "Schedule":
                getSchedule()
                getTeams()
            case "Squad":
                getSquad()
            case "Teams":
                getTeams()
        default:
            print("Wystąpił błąd.")
        }
        
        switch chosenOption {
            case "edit" :
                textLabel.text = "Wybierz rekord do edycji"
            case "delete" :
                textLabel.text = "Wybierz rekord do usunięcia"
            default:
                textLabel.text = "Wybierz co chcesz zrobić"
        }
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.tableFooterView = UIView(frame: frame)
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 10
    }
    
    func getNews(){
        refHandle = ref?.child("\(chosenTab)/\(team)").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
                self.tableView.reloadData()
                if(self.tableView.numberOfRows(inSection: 0) != 0){
                    AppInstance.hideLoader()
                }
            }
        })
    }
    
    func getTable(){
        let selectedRowIndex = self.tableView.indexPathForSelectedRow
        let cellId = selectedRowIndex!.row
        refHandle = ref?.child("Table").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
            }
            if self.list.count == self.teams.count {
                for x in 0...self.list.count - 1 {
                    if self.list[x][0] == self.teams[cellId] {
                        self.ref?.child("Table/\(x)").removeValue()
                    }
                }
            }
        })
    }
    
    func getSchedule(){
        refHandle = ref?.child("\(chosenTab)/\(team)").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
                self.tableView.reloadData()
            }
        })
    }
    
    func getSquad(){
        refHandle = ref?.child("\(chosenTab)/\(team)").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.list.append(actualPost)
                self.tableView.reloadData()
            }
        })
    }
    
    func getTeams() {
        refHandle = ref?.child("Teams").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? String
            if let actualPost = post {
                self.teams.append(actualPost)
                self.tableView.reloadData()
                self.teams.sort()
            }
        })
    }
    
    func deleteAlert(Message: String) {
        let alert = UIAlertController(title: "Czy na pewno chcesz kontynuować?", message: Message, preferredStyle: UIAlertController.Style.alert)
        let confirmAction = UIAlertAction(title: "Tak, usuń", style: UIAlertAction.Style.destructive) {
            UIAlertAction in
            if self.chosenTab == "Teams" {
                self.deleteTeams()
            } else {
                self.deleteRecords()
            }
        }
        let cancelAction = UIAlertAction(title: "Nie, powróć", style: UIAlertAction.Style.cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func normalize(_ str: String) -> String {
        let original = ["Ą", "ą", "Ć", "ć", "Ę", "ę", "Ł", "ł", "Ń", "ń", "Ó", "ó", "Ś", "ś", "Ź", "ź", "Ż", "ż"]
        let normalized = ["A", "a", "C", "c", "E", "e", "L", "l", "N", "n", "O", "o", "S", "s", "Z", "z", "Z", "z"]
        var str = str
        for x in 0...original.count - 1 {
            if original.contains(where: str.contains) == true {
                str = str.replacingOccurrences(of: original[x], with: normalized[x])
            } else {
                return str
            }
        }
        return str
    }
    
    func deleteRecords() {
        let selectedRowIndex = self.tableView.indexPathForSelectedRow
        let cellId = selectedRowIndex!.row
        ref?.child("\(chosenTab)/\(team)/\(cellId)").removeValue()
        switch chosenTab {
            case "News":
                list.removeAll()
                getNews()
            case "Schedule":
                list.removeAll()
                getSchedule()
            case "Squad":
                let deleteRef = Storage.storage().reference().child("players/\(team)/\(normalize("\(list[cellId][0])")).png")
                deleteRef.delete { (error) in
                    if let error = error {
                        print(error)
                    } else {}
                }
                list.removeAll()
                getSquad()
            default:
                print("Wystąpił błąd.")
        }
        tableView.reloadData()
    }
    
    func deleteTeams(){
        let selectedRowIndex = self.tableView.indexPathForSelectedRow
        let cellId = selectedRowIndex!.row
        let selectedTeam = teams[cellId]
        
        ref?.child("Table").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = Int(snap.key)
                self.keys.append(key!)
            }
            self.ref?.child("Table").observe(.childAdded, with: { (snapshot) in
                let post = snapshot.value as? [String]
                if let actualPost = post {
                    self.list.append(actualPost)
                }
                if self.list.count == self.teams.count {
                    if self.keys.count == self.teams.count {
                        for x in 0...self.keys.max()! {
                            if self.list[x][0] == selectedTeam {
                                self.ref?.child("Table/\(x)").removeValue()
                            }
                        }
                    }
                }
            })
        })
        
        ref?.child("Teams").queryOrderedByValue().queryEqual(toValue: selectedTeam).observeSingleEvent(of: .value) { (querySnapshot) in
            for result in querySnapshot.children {
                let resultSnapshot = result as! DataSnapshot
                self.ref?.child("Teams/\(resultSnapshot.key)").removeValue()
            }
        }
        
        let deleteRef = Storage.storage().reference().child("badges/\(selectedTeam).png")
        deleteRef.delete(completion: nil)
        
        ref?.child("Info/\(selectedTeam)").removeValue()
        ref?.child("News/\(selectedTeam)").removeValue()
        ref?.child("Schedule/\(selectedTeam)").removeValue()
        ref?.child("Squad/\(selectedTeam)").removeValue()
        teams.removeAll()
        getTeams()
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var amount: Int = 0
        switch chosenTab {
            case "News", "Schedule", "Squad":
                amount = list.count
            case "Teams":
                amount = teams.count
            default:
                print("Wystąpił błąd.")
        }
        return amount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "record")
        cell?.layer.masksToBounds = true
        cell?.layer.cornerRadius = 10
        cell?.textLabel?.numberOfLines = 0
        cell?.backgroundColor = UIColor(red: 255/255, green: 224/255, blue: 178/255, alpha: 0.9)
        switch chosenTab {
            case "News", "Squad":
                cell?.textLabel?.text = list[indexPath.row][0]
            case "Schedule":
                switch list[indexPath.row][4] {
                    case "true":
                        cell?.textLabel?.text = "\(team) \(list[indexPath.row][2]):\(list[indexPath.row][3]) \(list[indexPath.row][1])"
                    case "false":
                        cell?.textLabel?.text = "\(list[indexPath.row][1]) \(list[indexPath.row][3]):\(list[indexPath.row][2]) \(team)"
                    default:
                        cell?.textLabel?.text = "\(team) \(list[indexPath.row][2]):\(list[indexPath.row][3]) \(list[indexPath.row][1])"
                }
            case "Teams":
                cell?.textLabel?.text = teams[indexPath.row]
            default:
                print("Wystąpił błąd.")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if chosenOption == "delete" {
            if self.chosenTab == "Teams" {
                self.deleteAlert(Message: "Spowoduje to usunięcie WSZYSTKICH danych o tej drużynie")
            } else {
                self.deleteAlert(Message: "")
            }
        } else {
            performSegue(withIdentifier: chosenTab, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "News" {
            let vc = segue.destination as! NewsManagerController
            vc.delegate = self
            vc.chosenOption = chosenOption
            vc.team = team
            vc.list = list
            vc.chosenTab = chosenTab
            let selectedRowIndex = self.tableView.indexPathForSelectedRow
            vc.cellId = selectedRowIndex!.row
        } else if segue.identifier == "Schedule" {
            let vc = segue.destination as! ScheduleManagerController
            vc.delegate = self
            vc.chosenOption = chosenOption
            vc.team = team
            vc.teams = teams
            vc.list = list
            vc.chosenTab = chosenTab
            let selectedRowIndex = self.tableView.indexPathForSelectedRow
            vc.cellId = selectedRowIndex!.row
        } else if segue.identifier == "Squad" {
            let vc = segue.destination as! SquadManagerController
            vc.delegate = self
            vc.chosenOption = chosenOption
            vc.team = team
            vc.list = list
            vc.chosenTab = chosenTab
            let selectedRowIndex = self.tableView.indexPathForSelectedRow
            vc.cellId = selectedRowIndex!.row
        } else if segue.identifier == "Teams" {
            let vc = segue.destination as! TeamManagerController
            vc.delegate = self
            vc.chosenOption = chosenOption
            vc.teams = teams
            vc.chosenTab = chosenTab
            let selectedRowIndex = self.tableView.indexPathForSelectedRow
            vc.cellId = selectedRowIndex!.row
        }
    }
}

extension RecordsListController: newsDelegate {
    func updateNews() {
        list.removeAll()
        getNews()
        tableView.reloadData()
    }
}
extension RecordsListController: scheduleDelegate {
    func updateSchedule() {
        list.removeAll()
        getSchedule()
        tableView.reloadData()
    }
}
extension RecordsListController: squadDelegate {
    func updateSquad() {
        list.removeAll()
        getSquad()
        tableView.reloadData()
    }
}
extension RecordsListController: teamsDelegate {
    func updateTeams() {
        teams.removeAll()
        getTeams()
        tableView.reloadData()
    }
}
