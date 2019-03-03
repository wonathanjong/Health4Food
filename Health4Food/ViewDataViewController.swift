//
//  ViewDataViewController.swift
//  Health4Food
//
//  Created by Jonathan Wong  on 3/2/19.
//  Copyright © 2019 Jonathan Wong . All rights reserved.
//

import Foundation
import UIKit
import PureLayout
import SwiftyJSON

class ViewDataViewController: UIViewController {
    var dataJSON: [String: JSON] = [:]
    let closeBT: UIButton = {
       let bt = UIButton()
        bt.setTitle("Close", for: .normal)
        bt.titleLabel?.textColor = Constants.Colors.mainBlue
        bt.setTitleColor(Constants.Colors.mainBlue, for: .normal)
        bt.setTitleColor(Constants.Colors.lightGray, for: .highlighted)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        bt.addTarget(self, action: #selector(ViewDataViewController.close), for: .touchUpInside)
        return bt
    }()
    let scrollView: UIScrollView = {
       let view = UIScrollView()
        return view
    }()
    let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = Constants.Colors.darkGray
        return label
    }()
    let brandLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.darkGray
        return label
    }()
    let upcLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.darkGray
        return label
    }()
    let mealTypesLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.darkGray
        return label
    }()
    let storeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.darkGray
        return label
    }()
    let targetGroupLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.darkGray
        return label
    }()
    let notesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = Constants.Colors.darkGray
        label.text = "Notes:"
        return label
    }()
    let notesTextView: UITextView = {
        let view = UITextView()
        view.textColor = Constants.Colors.darkGray
        view.layer.borderWidth = 1
        view.tintColor = UIColor.clear
        view.layer.cornerRadius = 4
        view.font = UIFont.systemFont(ofSize: 15)
        view.layer.borderColor = Constants.Colors.darkGray.cgColor
        view.isEditable = false
        return view
    }()
    let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.text = "Ingredients:"
        label.textColor = Constants.Colors.darkGray
        return label
    }()
    let ingredientsTextView: UITextView = {
        let view = UITextView()
        view.textColor = Constants.Colors.darkGray
        view.layer.borderWidth = 1
        view.tintColor = UIColor.clear
        view.layer.cornerRadius = 4
        view.font = UIFont.systemFont(ofSize: 15)
        view.layer.borderColor = Constants.Colors.darkGray.cgColor
        view.isEditable = false
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(dataJSON: [String: JSON]){
        self.init()
        self.dataJSON = dataJSON
        
        if let photo = dataJSON["photoLink"]?.string{
            if let url = URL(string: photo){
                downloadImage(from: url, imageView: self.imageView)
            }
        } else{
            imageView.image = UIImage(named: "noImage")
        }
        if let name = dataJSON["name"]?.string{
            nameLabel.text = name
        }
        if let brand = dataJSON["brand"]?.string{
            brandLabel.attributedText = attributedText(withString: "Brand: " + brand, boldString: "Brand: ", font: UIFont.systemFont(ofSize: 14))
        }
        if let upc = dataJSON["upcNum"]?.string{
            upcLabel.attributedText = attributedText(withString: "UPC #: " + upc, boldString: "UPC #: ", font: UIFont.systemFont(ofSize: 14))
        }
        if let mealTypes = dataJSON["mealTypes"]?.array{
            var str = ""
            for (index, meal) in mealTypes.enumerated(){
                if let me = meal.string{
                    if (index != 0 && index != mealTypes.count-1){
                        str += me + ", "
                    } else{
                        str+=me
                    }
                }
            }
            mealTypesLabel.attributedText = attributedText(withString: "Meal Types: " + str, boldString: "Meal Types: ", font: UIFont.systemFont(ofSize: 14))
        }
        if let store = dataJSON["store"]?.string {
            storeLabel.attributedText = attributedText(withString: "Store: " + store, boldString: "Store: ", font: UIFont.systemFont(ofSize: 14))
        }
        if let note = dataJSON["note"]?.string{
//            notesTextView.attributedText = attributedText(withString: "Note: " + note, boldString: "Note: ", font: UIFont.systemFont(ofSize: 14))
            notesTextView.text = note
        }
        if let ingredients = dataJSON["ingredients"]?.string{
           print(ingredients)
//           ingredientsTextView.attributedText = attributedText(withString: "Ingredients: " + ingredients, boldString: "Ingredients: ", font: UIFont.systemFont(ofSize: 14))
            ingredientsTextView.text = ingredients
        }
        if let targetGroup = dataJSON["targetGroup"]?.string{
           print(targetGroup)
            targetGroupLabel.attributedText = attributedText(withString: "Target Group: " + targetGroup, boldString: "Target Group: ", font: UIFont.systemFont(ofSize: 14))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        setupConstraints()
        hideKeyboard()
    }
    
    
    func setupConstraints(){
        view.addSubview(closeBT)
        view.addSubview(scrollView)
        let elements = [imageView, nameLabel, brandLabel, upcLabel, mealTypesLabel, storeLabel, targetGroupLabel, notesLabel, notesTextView, ingredientsLabel, ingredientsTextView]
        for element in elements{
            scrollView.addSubview(element)
        }
        
        closeBT.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        closeBT.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        
        scrollView.autoPinEdge(.top, to: .bottom, of: closeBT, withOffset: 5)
        scrollView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(), excludingEdge: .top)
        scrollView.contentSize = CGSize(width: Constants.Screen.width, height: Constants.Screen.height*1.5)
        
        imageView.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        imageView.autoAlignAxis(toSuperviewAxis: .vertical)
        imageView.autoSetDimension(.width, toSize: Constants.Screen.width/2)
        imageView.autoSetDimension(.height, toSize: Constants.Screen.width/1.5)
        
        nameLabel.autoPinEdge(.top, to: .bottom, of: imageView, withOffset: 5)
        nameLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        brandLabel.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 5)
        brandLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
        
        upcLabel.autoPinEdge(.top, to: .bottom, of: brandLabel, withOffset: 5)
        upcLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
        
        mealTypesLabel.autoPinEdge(.top, to: .bottom, of: upcLabel, withOffset: 5)
        mealTypesLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
        
        storeLabel.autoPinEdge(.top, to: .bottom, of: mealTypesLabel, withOffset: 5)
        storeLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
        
        targetGroupLabel.autoPinEdge(.top, to: .bottom, of: storeLabel, withOffset: 5)
        targetGroupLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
        
        notesLabel.autoPinEdge(.top, to: .bottom, of: targetGroupLabel, withOffset: 5)
        notesLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
        
        notesTextView.autoPinEdge(.top, to: .bottom, of: notesLabel, withOffset: 5)
        notesTextView.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
        notesTextView.autoSetDimension(.height, toSize: 50)
        notesTextView.autoSetDimension(.width, toSize: Constants.Screen.width - 10)
        
        ingredientsLabel.autoPinEdge(.top, to: .bottom, of: notesTextView, withOffset: 5)
        ingredientsLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
        
        ingredientsTextView.autoPinEdge(.top, to: .bottom, of: ingredientsLabel, withOffset: 5)
        ingredientsTextView.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
        ingredientsTextView.autoSetDimension(.height, toSize: 100)
        ingredientsTextView.autoSetDimension(.width, toSize: Constants.Screen.width - 10)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL, imageView: UIImageView) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                print("lmaoooo")
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    @objc func close(){
        dismiss(animated: true, completion: nil)
    }
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        
        view.addGestureRecognizer(swipeDown)
        view.addGestureRecognizer(tap)
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
