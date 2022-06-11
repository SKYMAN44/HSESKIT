//
//  InputView.swift
//  
//
//  Created by Дмитрий Соколов on 23.02.2022.
//

import UIKit

public protocol InputViewDelegate: AnyObject {
    func inputViewHeightDidChange(heightConstrain: CGFloat)
    func messageSent(message: MessageContent)
}

public class InputView: UIView {
    private var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "upwardArrow"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .background.style(.firstLevel)()
        button.backgroundColor = .primary.style(.primary)()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addConstraint(NSLayoutConstraint(item: button,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: button,
                                                  attribute: .width,
                                                  multiplier: 1,
                                                  constant: 0))
        button.widthAnchor.constraint(equalToConstant: 36).isActive = true
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    private var chooseImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus-circle"), for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.tintColor = .primary.style(.primary)()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addConstraint(NSLayoutConstraint(item: button,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: button,
                                                  attribute: .width,
                                                  multiplier: 1,
                                                  constant: 0))
        button.widthAnchor.constraint(equalToConstant: 36).isActive = true
        button.addTarget(self, action: #selector(chooseImageTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private var inputTextView: UITextView = {
        let textField = UITextView()
        textField.backgroundColor = .background.style(.firstLevel)()
        textField.textColor = .textAndIcons.style(.tretiary)()
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0
        textField.contentInsetAdjustmentBehavior = .never
        textField.isEditable = true
        textField.text = "Message"
        textField.font = .customFont.style(.message)()
        textField.textContainerInset = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        textField.isScrollEnabled = false
        
        return textField
    }()
    
    private var inputFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .background.style(.firstLevel)()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
        return view
    }()
    
    private var contentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(InputContentCollectionViewCell.self, forCellWithReuseIdentifier: InputContentCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        return collectionView
    }()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isExclusiveTouch = false
        scrollView.isMultipleTouchEnabled = true
        
        return scrollView
    }()
    
    
    public weak var delegate: InputViewDelegate?
    private var presentingController: UIViewController?
    private var chosenPhotos: [UIImage] = [] {
        didSet {
            if(chosenPhotos.isEmpty) {
                contentCollectionView.isHidden = true
                contentCollectionView.reloadData()
                textViewDidChange(inputTextView)
            } else {
                contentCollectionView.isHidden = false
                contentCollectionView.reloadData()
                textViewDidChange(inputTextView)
            }
            let textViewIsEmpty = inputTextView.text == "" ? true : false
            enableButton(textViewIsEmpty: textViewIsEmpty, photosIsEmpty: chosenPhotos.isEmpty)
        }
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        inputTextView.delegate = self
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        presentingController = findViewController()
        sendButton.layer.cornerRadius = sendButton.frame.width / 2
        chooseImageButton.layer.cornerRadius = chooseImageButton.frame.width / 2
    }
    
    // MARK: - UI setup
    private func setup() {
        setupButtons()
        setupInputField()
    }
    
    private func setupButtons() {
        addSubview(sendButton)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        addSubview(chooseImageButton)
        
        NSLayoutConstraint.activate([
            chooseImageButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            chooseImageButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func setupInputField() {
        addSubview(inputFieldView)
        
        inputFieldView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputFieldView.leftAnchor.constraint(equalTo: chooseImageButton.rightAnchor, constant: 10),
            inputFieldView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            inputFieldView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            inputFieldView.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8)
        ])
        
        inputFieldView.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: inputFieldView.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: inputFieldView.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: inputFieldView.bottomAnchor),
            scrollView.rightAnchor.constraint(equalTo: inputFieldView.rightAnchor)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [contentCollectionView, inputTextView])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        
        scrollView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -5),
            stackView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        contentCollectionView.isHidden = true
    }
    
    // MARK: - Interactions
    @objc
    private func sendButtonTapped() {
        if let text = inputTextView.text, inputTextView.text != "", inputTextView.textColor != .textAndIcons.style(.tretiary)() {
            inputTextView.text = ""
            let message = MessageContent(text: text, image: nil)
            delegate?.messageSent(message: message)
        }
        
        guard !chosenPhotos.isEmpty else { return }
        
        chosenPhotos.forEach { (photo) in
            let message = MessageContent(text: nil, image: photo.copy() as? UIImage)
            delegate?.messageSent(message: message)
        }
        chosenPhotos.removeAll()
    }
    
    // TODO: - Switch to PHPhoto Library
    @objc
    private func chooseImageTapped(sender: UIButton) {
        guard let controller = presentingController else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alertController = UIAlertController(title:"Choose Image Source", message: nil,preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Cancel",style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let cameraAction = UIAlertAction(title: "Camera",style: .default, handler: { action in imagePicker.sourceType = .camera
                controller.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library",style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                controller.present(imagePicker, animated: true, completion: nil)
            })
        alertController.addAction(photoLibraryAction)
        }

        alertController.popoverPresentationController?.sourceView = sender

        controller.present(alertController, animated: true, completion: nil)
    }
    
    private func enableButton(textViewIsEmpty: Bool, photosIsEmpty: Bool) {
        if(!textViewIsEmpty || !photosIsEmpty) {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
    }

    // MARK: - API
    public func dismissView() {
        inputTextView.resignFirstResponder()
    }
    
}

// MARK: - CollectionViewDelegate
extension InputView: UICollectionViewDelegate { }

// MARK: - CollectionView Data Source
extension InputView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chosenPhotos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InputContentCollectionViewCell.reuseIdentifier, for: indexPath) as! InputContentCollectionViewCell
        cell.configure(image: chosenPhotos[indexPath.row])
        cell.delegate = self
        cell.indexPath = indexPath
        
        return cell
    }
}

// MARK: - CollectionViewCell Delegate
extension InputView: InputContentCollectionViewCellDelegate {
    func removeButtonPressed(indexPath: IndexPath) {
        chosenPhotos.remove(at: indexPath.row)
    }
}

// MARK: - TextView Delegate
extension InputView: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.textColor == .textAndIcons.style(.tretiary)()) {
            textView.text = nil
            textView.textColor = .textAndIcons.style(.primary)()
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text.isEmpty || textView.text == "") {
            let textViewIsEmpty = textView.text == "" ? true : false
            enableButton(textViewIsEmpty: textViewIsEmpty, photosIsEmpty: chosenPhotos.isEmpty)
            textView.text = "Message"
            textView.textColor = .textAndIcons.style(.tretiary)()
            delegate?.inputViewHeightDidChange(heightConstrain: 56)
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let height = newSize.height
        let textViewIsEmpty = textView.text == "" ? true : false
        enableButton(textViewIsEmpty: textViewIsEmpty, photosIsEmpty: chosenPhotos.isEmpty)
        if(!chosenPhotos.isEmpty && height >= 52) {
            delegate?.inputViewHeightDidChange(heightConstrain: 150)
        } else if (!chosenPhotos.isEmpty && height < 52) {
            delegate?.inputViewHeightDidChange(heightConstrain: 130)
        } else if(height > 100) {
            delegate?.inputViewHeightDidChange(heightConstrain: 150)
        } else {
            delegate?.inputViewHeightDidChange(heightConstrain: 30 + height)
        }
    }
}

// MARK: - ImagePickerDelegate
extension InputView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let selectedImage = info[.originalImage] as? UIImage,
              let controller = presentingController
        else { return }
        chosenPhotos.append(selectedImage)
        
        controller.dismiss(animated: true, completion: nil)
    }
}
