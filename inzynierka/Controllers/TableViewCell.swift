import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var matches: UILabel!
    @IBOutlet weak var goals: UILabel!
    @IBOutlet weak var points: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
