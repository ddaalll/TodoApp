//
//  ToDoCell.swift
//  TodoApp
//
//  Created by DalHyun Nam on 2023/04/05.
//

import UIKit

final class ToDoCell: UITableViewCell {


    @IBOutlet weak var backgoundView: UIView!
    
    @IBOutlet weak var toDoTextLabel: UILabel!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    var toDoData: MemoData? {
        didSet{
            configureUIwithData()
        }
    }
    
    //(델리게이트 대신에) 실행하고 싶은 클로저 저장, 뷰컨트롤러에 있는 클로저 저장할 예정(셀(자신)을 전달)
    var updateButtonPressed: (ToDoCell) -> Void = { (sender) in }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configurationUI()
    }

    func configurationUI() {
        backgoundView.clipsToBounds = true
        backgoundView.layer.cornerRadius = 8
        
        updateButton.clipsToBounds = true
        updateButton.layer.cornerRadius = 10
    }
    
    func configureUIwithData() {
        toDoTextLabel.text = toDoData?.memoText
        dateTextLabel.text = toDoData?.dateString
        guard let colorNum = toDoData?.color else { return }
        let color = MyColor(rawValue: colorNum) ?? .red
        updateButton.backgroundColor = color.buttonColor
        backgoundView.backgroundColor = color.backgroundColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state 
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        updateButtonPressed(self)
    }
    
    
    
}
