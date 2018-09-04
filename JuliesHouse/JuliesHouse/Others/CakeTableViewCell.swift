import UIKit

class CakeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cakeImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let f = contentView.frame
        let fr = UIEdgeInsetsInsetRect(f, UIEdgeInsetsMake(15, -10, 15, 0))
        contentView.frame = fr
    }
}


