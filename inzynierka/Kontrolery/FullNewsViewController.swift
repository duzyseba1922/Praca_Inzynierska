import UIKit

class FullNewsViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var news = [[String]]()
    var cellId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.delegate = self
        contentTextView.layer.masksToBounds = true
        contentTextView.layer.cornerRadius = 10
        
        AppInstance.showLoader()
        if(titleLabel.text != nil && contentTextView.text != nil){
            AppInstance.hideLoader()
        }
        
        titleLabel.layer.backgroundColor = UIColor(red: 255/255, green: 243/255, blue: 224/255, alpha: 0.9).cgColor
        titleLabel.layer.cornerRadius = 10
        
        self.titleLabel.text = self.news[self.cellId!][0]
        self.contentTextView.text = self.news[self.cellId!][1]
    }
}
