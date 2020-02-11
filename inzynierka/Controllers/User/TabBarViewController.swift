import UIKit
import Firebase

class TabBarViewController: UITabBarController {
    // MARK: - Database Reference
    var ref: DatabaseReference?
    
    // MARK: - Chosen Team Property
    var team = ""
    
    // MARK: - Badge Property
    var badge: UIImage?
    
    // MARK: - Table Handlers
    var refTableHandle: DatabaseHandle?
    
    // MARK: - Table Properties
    var table = [[String]]()
    
    // MARK: - Schedule Handlers
    var refScheduleHandle: DatabaseHandle?
    
    // MARK: - Schedule Properties
    var schedule = [[String]]()
    
    // MARK: - Squad Handlers
    var refSquadHandle: DatabaseHandle?
    
    // MARK: - Squad Properties
    var squad = [[String]]()
    
    // MARK: - Info Handlers
    var refFoundedHandle: DatabaseHandle?
    var refTrophiesHandle: DatabaseHandle?
    var refColorsHandle: DatabaseHandle?
    var refStadiumHandle: DatabaseHandle?
    var refValueHandle: DatabaseHandle?
    
    // MARK: - Info Properties
    var trophies = [String]()
    var founded = ""
    var colors = ""
    var stadium = ""
    var teamValue = ""
    var trophy = ""
    
    // MARK: - Main Method
    override func viewDidLoad(){
        super.viewDidLoad()
        
        ref = Database.database().reference()
        getTable()
        getSchedule()
        getSquad()
        getInfo()
    }
    
    // MARK: - Private Methods
    
    func getTable(){
        refTableHandle = ref?.child("Table").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.table.append(actualPost)
                self.table = self.table.sorted(by: {$0[3].localizedStandardCompare($1[3]) == .orderedDescending})
            }
        })
    }
    
    func getSchedule(){
        refScheduleHandle = ref?.child("Schedule/\(team)").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.schedule.append(actualPost)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                self.schedule = self.schedule.sorted(by: { dateFormatter.date(from:$0[0])!.compare(dateFormatter.date(from:$1[0])!) == .orderedDescending })
            }
        })
    }
    
    func getSquad(){
        refSquadHandle = ref?.child("Squad/\(team)").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post {
                self.squad.append(actualPost)
            }
        })
    }
    
    func getInfo(){
        refFoundedHandle = ref?.child("Info/\(team)/Founded").observe(.value, with: { (snapshot) in
            let post = snapshot.value as? String
            self.founded = post!
        })
        refTrophiesHandle = ref?.child("Info/\(team)/Trophies").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? String
            if let actualPost = post {
                self.trophies.append(actualPost)
            }
            self.trophy = self.trophies.joined(separator: ", ")
        })
        refColorsHandle = ref?.child("Info/\(team)/Colors").observe(.value, with: { (snapshot) in
            let post = snapshot.value as? String
            self.colors = post!
        })
        refStadiumHandle = ref?.child("Info/\(team)/Stadium").observe(.value, with: { (snapshot) in
            let post = snapshot.value as? String
            self.stadium = post!
        })
        refValueHandle = ref?.child("Info/\(team)/TeamValue").observe(.value, with: { (snapshot) in
            let post = snapshot.value as? String
            self.teamValue = post!
        })
    }
}
