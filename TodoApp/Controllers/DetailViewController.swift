//
//  DetailViewController.swift
//  TodoApp
//
//  Created by DalHyun Nam on 2023/04/07.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    
    lazy var buttons: [UIButton] = {
        return [redButton, greenButton, blueButton, purpleButton]
    }()
    
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    let toDoManager = CoreDataManager.shared
    
    var toDoData: MemoData? {
        didSet {
            temporaryNum = toDoData?.color
        }
    }
    
    
    
    var temporaryNum: Int64? = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureUI()
    }

    func setup() {
        mainTextView.delegate = self
        
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 10
        
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 8
        clearButtonColors()
    }
    
    func configureUI() {
        if let toDoData = self.toDoData {
            self.title = "메모 수정하기"
            
            guard let text = toDoData.memoText else { return }
            mainTextView.text = text
            
            mainTextView.textColor = .black
            saveButton.setTitle("UPDATE", for: .normal)
            mainTextView.becomeFirstResponder()
            let color = MyColor(rawValue: toDoData.color)
            setupColorTheme(color: color)
        } else {
            self.title = "새로운 메모 생성하기"
            
            saveButton.setTitle("SAVE", for: .normal)
            mainTextView.text = "텍스트를 여기에 입력하세요."
            mainTextView.textColor = .lightGray
            setupColorTheme(color: .red)
        }
        
        setupColorButton(num: temporaryNum ?? 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttons.forEach { button in
            button.clipsToBounds = true
            button.layer.cornerRadius = button.bounds.height / 2
        }
    }
    
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        
        self.temporaryNum = Int64(sender.tag)
        
        let color = MyColor(rawValue: Int64(sender.tag))
        setupColorTheme(color: color)
        
        clearButtonColors()
        setupColorButton(num: Int64(sender.tag))
    }
    
    func setupColorTheme(color: MyColor? = .red) {
        backgroundView.backgroundColor = color?.backgroundColor
        saveButton.backgroundColor = color?.buttonColor
    }
    
    func clearButtonColors() {
        redButton.backgroundColor = MyColor.red.backgroundColor
        redButton.setTitleColor(MyColor.red.buttonColor, for: .normal)
        greenButton.backgroundColor = MyColor.green.backgroundColor
        greenButton.setTitleColor(MyColor.green.buttonColor, for: .normal)
        blueButton.backgroundColor = MyColor.blue.backgroundColor
        blueButton.setTitleColor(MyColor.blue.buttonColor, for: .normal)
        purpleButton.backgroundColor = MyColor.purple.backgroundColor
        purpleButton.setTitleColor(MyColor.purple.buttonColor, for: .normal)
    }
    func setupColorButton(num: Int64) {
        switch num {
        case 1:
            redButton.backgroundColor = MyColor.red.buttonColor
            redButton.setTitleColor(.white, for: .normal)
        case 2:
            greenButton.backgroundColor = MyColor.green.buttonColor
            greenButton.setTitleColor(.white, for: .normal)
        case 3:
            blueButton.backgroundColor = MyColor.blue.buttonColor
            blueButton.setTitleColor(.white, for: .normal)
        case 4:
            purpleButton.backgroundColor = MyColor.purple.buttonColor
            purpleButton.setTitleColor(.white, for: .normal)
        default:
            redButton.backgroundColor = MyColor.red.buttonColor
            redButton.setTitleColor(.red, for: .normal)
        }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        if let toDoData = self.toDoData {
            toDoData.memoText = mainTextView.text
            toDoData.color = temporaryNum ?? 1
            toDoManager.updateToDo(newToDoData: toDoData) {
                print("업데이트 완료")
                self.navigationController?.popViewController(animated: true)
            }
            
        } else {
            let memoText = mainTextView.text
            toDoManager.saveToDoData(toDotext: memoText, colorInt: temporaryNum ?? 1) {
                print("저장완료")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "텍스트를 여기에 입력하세요." {
            textView.text = nil
            textView.textColor = .black
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            textView.text = "텍스트를 여기에 입력하세요."
            textView.textColor = .lightGray
        }
    }
}




