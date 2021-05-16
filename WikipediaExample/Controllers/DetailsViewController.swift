//
//  DetailsViewController.swift
//  WikipediaExample
//
//  Created by Zhanibek Lukpanov on 09.05.2021.
//

import UIKit
import WikipediaKit

final class DetailsViewController: UIViewController, Coordinating {
    
    // MARK:- Properties
    var coordinator: Coordinator?
    
    var model: WikipediaArticlePreview
    
    private let textView: UITextView = {
       let textView = UITextView()
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.backgroundColor = .lightGray
        return textView
    }()
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()
    
    private lazy var copyButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(copyBarButtonTapped))
    }()

    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setuplayout()
        textView.text = "Название: \(model.title)\n\n Описание: \(model.description) \n\n Текст: \(model.rawText)"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.layer.cornerRadius = 30
    }
    
    // MARK:- Initializators
    init(model: WikipediaArticlePreview) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK:- Layout
    private func setuplayout() {
        
        view.backgroundColor = .white
        
        view.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        navigationItem.rightBarButtonItems = [actionBarButtonItem, copyButtonItem]
        
    }
    
    // MARK:- BarButton Methods
    @objc private func actionBarButtonTapped(sender: UIBarButtonItem) {
        
        let shareController = UIActivityViewController(activityItems: [textView.text ?? ""], applicationActivities: nil)
        
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        
        present(shareController,animated: true,completion: nil)
    }
    
    @objc private func copyBarButtonTapped() {
        let text = self.textView.text
        let paste = UIPasteboard.general
        paste.string = text
        
        let alert = UIAlertController(title: "Copied", message: "you text was copied", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
