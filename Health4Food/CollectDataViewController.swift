//
//  CollectData.swift
//  Health4Food
//
//  Created by Jonathan Wong  on 2/24/19.
//  Copyright © 2019 Jonathan Wong . All rights reserved.
//

import Foundation
import UIKit
import PureLayout
import BarcodeScanner
import M13Checkbox
import Alamofire
import SwiftyJSON

class CollectDataViewController: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate, BarcodeScannerErrorDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var foodJSON: [String: Any]?
    var upcCode: String?
    var notesEdited = false
    
    let widthFactor = UIScreen.main.bounds.size.width/375
    let heightFactor = UIScreen.main.bounds.size.height/667
    
    //top view
    let topView: UIView = {
        let view = UIView()
        return view
    }()
    let targetGroupLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = Constants.Colors.darkGray
        label.text = "Target Group"
        return label
    }()
    let targetGroupField: UITextField = {
        let buttonView = UITextField()
        buttonView.text = "Infants"
        buttonView.tintColor = UIColor.clear
        buttonView.textAlignment = .center
//        buttonView.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        buttonView.textColor = Constants.Colors.darkGray
        buttonView.layer.cornerRadius = 35/4
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = Constants.Colors.darkGray.cgColor
        buttonView.clipsToBounds = true
        buttonView.backgroundColor = UIColor.white
        buttonView.font = UIFont.systemFont(ofSize: 18)
//        buttonView.addTarget(self, action: #selector(CollectDataViewController.chooseTargetGroup), for: .touchUpInside)
        let image = UIImage(named:"downCaret")
        let imageView = UIImageView(image: image)
        if let size = imageView.image?.size {
            imageView.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 15.0, height: size.height)
        }
        imageView.contentMode = UIView.ContentMode.center
        buttonView.rightView = imageView
        buttonView.rightViewMode = UITextField.ViewMode.always
        
        return buttonView
    }()
    let storeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = Constants.Colors.darkGray
        label.text = "Store"
        return label
    }()
    let storeField: UITextField = {
        let buttonView = UITextField()
        buttonView.text = "Whole Foods"
        buttonView.tintColor = UIColor.clear
        buttonView.textAlignment = .center
        buttonView.textColor = Constants.Colors.darkGray
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = Constants.Colors.darkGray.cgColor
        buttonView.layer.cornerRadius = 35/4
        buttonView.clipsToBounds = true
        buttonView.backgroundColor = UIColor.white
        buttonView.font = UIFont.systemFont(ofSize: 18)
//        buttonView.addTarget(self, action: #selector(CollectDataViewController.chooseTargetGroup), for: .touchUpInside)
        let image = UIImage(named:"downCaret")
        let imageView = UIImageView(image: image)
        if let size = imageView.image?.size {
            imageView.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 15.0, height: size.height)
        }
        imageView.contentMode = UIView.ContentMode.center
        buttonView.rightView = imageView
        buttonView.rightViewMode = UITextField.ViewMode.always
        
        return buttonView
    }()
    let targetGroupPicker: UIPickerView = {
        let pv = UIPickerView()
        return pv
    }()
    let targetGroupData = [String](arrayLiteral: "Infant", "Prenatal/Pregnancy", "Toddler", "Child", "Adolescent", "Adult", "Geriatric")
    let storePicker: UIPickerView = {
        let pv = UIPickerView()
        return pv
    }()
    let storeData = [String](arrayLiteral: "Whole Foods", "HEB")
    //second view
    let secondView: UIView = {
        let view = UIView()
        return view
    }()
    let mealsIncludedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = Constants.Colors.darkGray
        label.text = "Meals Included"
        return label
    }()
    let breakCB: M13Checkbox = {
       let checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        checkbox.tintColor = Constants.Colors.mainBlue
        checkbox.stateChangeAnimation = M13Checkbox.Animation(rawValue: "BounceFill")!
        return checkbox
    }()
    let breakLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        label.textColor = Constants.Colors.darkGray
        label.text = "Breakfast"
        return label
    }()
    let lunchCB: M13Checkbox = {
        let checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        checkbox.tintColor = Constants.Colors.mainBlue
        checkbox.stateChangeAnimation = M13Checkbox.Animation(rawValue: "BounceFill")!
        return checkbox
    }()
    let lunchLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        label.textColor = Constants.Colors.darkGray
        label.text = "Lunch"
        return label
    }()
    let dinCB: M13Checkbox = {
        let checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        checkbox.tintColor = Constants.Colors.mainBlue
        checkbox.stateChangeAnimation = M13Checkbox.Animation(rawValue: "BounceFill")!
        return checkbox
    }()
    let dinLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        label.textColor = Constants.Colors.darkGray
        label.text = "Dinner"
        return label
    }()
    let snackCB: M13Checkbox = {
        let checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        checkbox.tintColor = Constants.Colors.mainBlue
        checkbox.stateChangeAnimation = M13Checkbox.Animation(rawValue: "BounceFill")!
        return checkbox
    }()
    let snackLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        label.textColor = Constants.Colors.darkGray
        label.text = "Snack"
        return label
    }()
    let notesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = Constants.Colors.darkGray
        label.text = "Notes"
        return label
    }()
    let notesTF: UITextView = {
        let field = UITextView()
        field.text = "Write notes here!"
        field.textColor = UIColor.lightGray
        field.layer.borderWidth = 1
        field.tintColor = Constants.Colors.mainBlue
        field.layer.cornerRadius = 4
        field.font = UIFont.systemFont(ofSize: 15)
        field.layer.borderColor = Constants.Colors.darkGray.cgColor
        return field
    }()
    //third view
    let thirdView: UIView = {
       let view = UIView()
//        view.isHidden = true
        return view
    }()
    let imageView: UIImageView = {
        let view  = UIImageView()
        view.image = UIImage(named: "noBarcode")
        view.layer.cornerRadius = 4
        return view
    }()
    let scrolly: UIScrollView = {
       let view = UIScrollView()
       view.bounces = true
//        view.isScrollEnabled = true
     
        
       return view
    }()
    let upcLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = Constants.Colors.darkGray
        label.text = "UPC #: "
        return label
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = Constants.Colors.darkGray
        label.text = "Name: "
        label.numberOfLines = 0
        return label
    }()
    let nutritionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = Constants.Colors.darkGray
        label.text = "Brand: "
        return label
    }()
    let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = Constants.Colors.darkGray
        label.text = "Ingredients: "
        label.numberOfLines = 0
        return label
    }()
    //last view
    let lastView: UIView = {
       let view = UIView()
        return view
    }()
    let scanBarcodeBT: UIButton = {
        let buttonView = UIButton()
        buttonView.setTitle("SCAN BARCODE", for: .normal)
        buttonView.titleEdgeInsets = UIEdgeInsets(top:0, left:10, bottom:0, right:0)
        buttonView.setTitleColor(UIColor.white, for: .normal)
        buttonView.setTitleColor(Constants.Colors.lightGray, for: .highlighted)
        buttonView.layer.cornerRadius = 50/2
        buttonView.clipsToBounds = true
        buttonView.backgroundColor = Constants.Colors.darkBlue
        buttonView.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        buttonView.addTarget(self, action: #selector(CollectDataViewController.scanBarcode), for: .touchUpInside)
        let image = UIImage(named:"whiteBarcode")
        buttonView.setImage(image, for: .normal)
        buttonView.imageView?.contentMode = .scaleAspectFit
        buttonView.imageEdgeInsets = UIEdgeInsets(top:0, left:-10, bottom:0, right:0)
        return buttonView
    }()
    let submitDataBT: UIButton = {
        let buttonView = UIButton()
        buttonView.setTitle("SUBMIT DATA", for: .normal)
        buttonView.setTitleColor(UIColor.white, for: .normal)
        buttonView.setTitleColor(Constants.Colors.lightGray, for: .highlighted)
        buttonView.layer.cornerRadius = 50/2
        buttonView.clipsToBounds = true
        buttonView.backgroundColor = Constants.Colors.otherBlue
        buttonView.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        buttonView.addTarget(self, action: #selector(CollectDataViewController.submitData), for: .touchUpInside)
        return buttonView
    }()
    
    
    override func viewDidLoad() {
        navigationItem.title = "HEALTH4FOOD"
        if let window = AppDelegate.del().window as? Window {
            window.screenIsReady = true
        }
        storePicker.delegate = self
        storeField.inputView = storePicker
        targetGroupPicker.delegate = self
        targetGroupField.inputView = targetGroupPicker
        setupConstraints()
        hideKeyboard()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)]
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    // MARK: Constraining and Shit
    func setupConstraints(){
        topView.addSubview(targetGroupLabel)
        topView.addSubview(targetGroupField)
        topView.addSubview(storeLabel)
        topView.addSubview(storeField)
        secondView.addSubview(breakCB)
        secondView.addSubview(breakLabel)
        secondView.addSubview(lunchCB)
        secondView.addSubview(lunchLabel)
        secondView.addSubview(dinCB)
        secondView.addSubview(dinLabel)
        secondView.addSubview(snackCB)
        secondView.addSubview(snackLabel)
        thirdView.addSubview(imageView)
        thirdView.addSubview(scrolly)
        scrolly.addSubview(upcLabel)
        scrolly.addSubview(nameLabel)
        scrolly.addSubview(nutritionLabel)
        scrolly.addSubview(ingredientsLabel)
        lastView.addSubview(scanBarcodeBT)
        lastView.addSubview(submitDataBT)
        
        let elements = [topView, mealsIncludedLabel, secondView, thirdView, lastView, notesLabel, notesTF]
        for element in elements{
            view.addSubview(element)
        }
        print(Constants.Screen.height)
        print(Constants.Screen.width)
        topView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15), excludingEdge: .bottom)
        targetGroupLabel.autoPinEdge(toSuperviewEdge: .top)
        targetGroupLabel.autoPinEdge(toSuperviewEdge: .left)
        targetGroupField.autoPinEdge(.top, to: .bottom, of: targetGroupLabel, withOffset: 5 * heightFactor)
        targetGroupField.autoPinEdge(.left, to: .left, of: targetGroupLabel, withOffset: 0)
        targetGroupField.autoSetDimension(.height, toSize: 35 * heightFactor)
        targetGroupField.autoSetDimension(.width, toSize: (Constants.Screen.width-(40*widthFactor))/2)
        targetGroupField.autoPinEdge(.right, to: .left, of: storeField, withOffset: -10*widthFactor)
        
        storeField.autoPinEdge(toSuperviewEdge: .bottom)
        storeField.autoPinEdge(toSuperviewEdge: .right)
        storeLabel.autoPinEdge(.bottom, to: .top, of: storeField, withOffset: -5 * heightFactor)
        storeLabel.autoPinEdge(.left, to: .left, of: storeField, withOffset: 0)
        storeLabel.autoAlignAxis(.horizontal, toSameAxisOf: targetGroupLabel)
        storeField.autoSetDimension(.height, toSize: 35 * heightFactor)
        
        mealsIncludedLabel.autoPinEdge(.top, to: .bottom, of: topView, withOffset: 10 * heightFactor)
        mealsIncludedLabel.autoPinEdge(.left, to: .left, of: topView, withOffset: 0)
        
        secondView.autoPinEdge(.top, to: .bottom, of: mealsIncludedLabel, withOffset: 10 * heightFactor)
        secondView.autoAlignAxis(toSuperviewAxis: .vertical)
        
        breakCB.autoPinEdge(toSuperviewEdge: .top)
        breakCB.autoPinEdge(toSuperviewEdge: .left)
        breakCB.autoSetDimensions(to: CGSize(width: 30 * widthFactor, height: 30 * widthFactor))
        breakCB.autoPinEdge(.bottom, to: .top, of: dinCB, withOffset: -5 * heightFactor)
        breakLabel.autoAlignAxis(.horizontal, toSameAxisOf: breakCB)
        breakLabel.autoPinEdge(.left, to: .right, of: breakCB, withOffset: 5 * widthFactor)
        breakLabel.autoPinEdge(.right, to: .left, of: lunchCB, withOffset: -70 * widthFactor)
        
        dinCB.autoPinEdge(toSuperviewEdge: .bottom)
        dinCB.autoPinEdge(toSuperviewEdge: .left)
        dinCB.autoSetDimensions(to: CGSize(width: 30 * widthFactor, height: 30 * widthFactor))
        dinLabel.autoAlignAxis(.horizontal, toSameAxisOf: dinCB)
        dinLabel.autoPinEdge(.left, to: .right, of: dinCB, withOffset: 5 * widthFactor)
        dinLabel.autoPinEdge(.right, to: .left, of: snackCB, withOffset: -70 * widthFactor)
        
        lunchLabel.autoPinEdge(toSuperviewEdge: .top)
        lunchLabel.autoPinEdge(toSuperviewEdge: .right)
        lunchLabel.autoAlignAxis(.horizontal, toSameAxisOf: breakLabel)
        lunchCB.autoAlignAxis(.horizontal, toSameAxisOf: lunchLabel)
        lunchCB.autoSetDimensions(to: CGSize(width: 30 * widthFactor, height: 30 * widthFactor))
        lunchCB.autoPinEdge(.right, to: .left, of: lunchLabel, withOffset: -5 * widthFactor)
        lunchCB.autoPinEdge(.bottom, to: .top, of: snackCB, withOffset: -5 * heightFactor)
        
        snackLabel.autoPinEdge(toSuperviewEdge: .bottom)
        snackLabel.autoPinEdge(toSuperviewEdge: .right)
        snackLabel.autoAlignAxis(.horizontal, toSameAxisOf: dinLabel)
        snackCB.autoAlignAxis(.horizontal, toSameAxisOf: dinLabel)
        snackCB.autoAlignAxis(.horizontal, toSameAxisOf: dinCB)
        snackCB.autoSetDimensions(to: CGSize(width: 30 * widthFactor, height: 30 * widthFactor))
        snackCB.autoPinEdge(.right, to: .left, of: snackLabel, withOffset: -5 * widthFactor)
        
        notesLabel.autoPinEdge(.top, to: .bottom, of: secondView, withOffset: 10 * heightFactor)
        notesLabel.autoPinEdge(.left, to: .left, of: mealsIncludedLabel, withOffset: 0)
        notesTF.delegate = self
        notesTF.autoPinEdge(.top, to: .bottom, of: notesLabel, withOffset: 5 * heightFactor)
        notesTF.autoPinEdge(.left, to: .left, of: notesLabel, withOffset: 0)
        notesTF.autoPinEdge(toSuperviewEdge: .right, withInset: 20 * widthFactor)
        notesTF.autoSetDimension(.height, toSize: 60 * heightFactor)
        
        thirdView.autoPinEdge(.top, to: .bottom, of: notesTF, withOffset: 20 * heightFactor)
        thirdView.autoPinEdge(.left, to: .left, of: notesLabel, withOffset: 0)
        thirdView.autoPinEdge(.right, to: .right, of: notesTF, withOffset: 0)
        
        imageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), excludingEdge: .right)
        imageView.autoSetDimensions(to: CGSize(width: 100 * widthFactor, height: 150 * heightFactor))
        scrolly.autoPinEdge(.left, to: .right, of: imageView, withOffset: 10 * widthFactor)
        scrolly.autoPinEdge(.top, to: .top, of: imageView, withOffset: 0)
        scrolly.autoPinEdge(.right, to: .right, of: notesTF)
        scrolly.autoPinEdge(.bottom, to: .bottom, of: imageView)
        
        upcLabel.autoPinEdge(toSuperviewEdge: .left)
        upcLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        nameLabel.autoPinEdge(toSuperviewEdge: .left)
        
        nameLabel.autoPinEdge(.top, to: .bottom, of: upcLabel, withOffset: 5 * heightFactor)
        nutritionLabel.autoPinEdge(toSuperviewEdge: .left)
        nutritionLabel.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 5 * heightFactor)
        ingredientsLabel.autoPinEdge(toSuperviewEdge: .left)
        ingredientsLabel.autoPinEdge(.top, to: .bottom, of: nutritionLabel, withOffset: 5 * heightFactor)
        
        
        lastView.autoPinEdge(.top, to: .bottom, of: thirdView, withOffset: 25 * heightFactor)
        lastView.autoPinEdge(toSuperviewEdge: .left, withInset: 10 * widthFactor)
        lastView.autoPinEdge(toSuperviewEdge: .right, withInset: 10 * widthFactor)
        
        scanBarcodeBT.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        scanBarcodeBT.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        scanBarcodeBT.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        scanBarcodeBT.autoSetDimension(.height, toSize: 50 * heightFactor)
        scanBarcodeBT.autoSetDimension(.width, toSize: (Constants.Screen.width-30) * widthFactor/2)
        scanBarcodeBT.autoPinEdge(.right, to: .left, of: submitDataBT, withOffset: -10 * widthFactor)
        
        submitDataBT.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        submitDataBT.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        submitDataBT.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        
    }
    
    // MARK:Logic and Functions
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
    // MARK: UIPickerView Delegation
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == targetGroupPicker {
            return targetGroupData.count
        } else{
            return storeData.count
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == targetGroupPicker {
            return targetGroupData[row]
        } else{
            return storeData[row]
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == targetGroupPicker {
            targetGroupField.text = targetGroupData[row]
        } else{
            storeField.text = storeData[row]
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !notesEdited{
            textView.text = ""
            textView.textColor = Constants.Colors.darkGray
            notesEdited = true
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func submitData(){
        var mealTypes:[String] = []
        
        let breakState = breakCB.checkState
        switch breakState {
        case .checked:
            mealTypes.append("Breakfast")
        case .unchecked:
            break
        case.mixed:
            break
        }
        let lunchState = lunchCB.checkState
        switch lunchState {
        case .checked:
            mealTypes.append("Lunch")
        case .unchecked:
            break
        case.mixed:
            break
        }
        let dinnState = dinCB.checkState
        switch dinnState {
        case .checked:
            mealTypes.append("Dinner")
        case .unchecked:
            break
        case.mixed:
            break
        }
        let snackState = snackCB.checkState
        switch snackState {
        case .checked:
            mealTypes.append("Snack")
        case .unchecked:
            break
        case.mixed:
            break
        }
        let alert = UIAlertController(title: "Error", message: "Fill out all required sections before submitting", preferredStyle: .alert)
        let alerto = UIAlertController(title: "Success", message: "Product Submission Catalogued", preferredStyle: .alert)
        let already = UIAlertController(title: "Error", message: "Product Has Been Catalogued Already", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                return
                
            case .cancel:
                return
                
            case .destructive:
                return
            }}))
        alerto.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                return
                
            case .cancel:
                return
                
            case .destructive:
                return
            }}))
        already.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                return
                
            case .cancel:
                return
                
            case .destructive:
                return
            }}))
        print("mealTypes")
        if(mealTypes.count == 0){
            self.present(alert, animated: true, completion: nil)
            return
        }
        var note = ""
        if let not = notesTF.text{
            note = not
        }
        print("tg")
        guard let targetGroup = targetGroupField.text else{
            self.present(alert, animated: true, completion: nil)
            return
        }
        print("store")
        guard let store = storeField.text else{
            self.present(alert, animated: true, completion: nil)
            return
        }
        print("code")
        guard let code = upcCode else{
            self.present(alert, animated: true, completion: nil)
            return
        }
        print("jason")
        guard let jason = foodJSON else{
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        print(jason["nf_ingredient_statement"])
        
        var params: Parameters = ["upcNum": code, "targetGroup": targetGroup, "store": store, "mealTypes": mealTypes, "note": note, "matched": "yes"]
        print(params)
        if let ingredients = jason["nf_ingredient_statement"] as? String{
            print(ingredients)
            params["ingredients"] = ingredients
        }
        if let name = jason["food_name"] as? String{
            print(name)
            params["name"] = name
        }
        if let brand = jason["brand_name"] as? String{
            print(brand)
            params["brand"] = brand
        }
        if let photoLink = jason["photo"] as? [String: Any]{
            if let photoLin = photoLink["thumb"] as? String{
                print(photoLin)
                params["photoLink"] = photoLin
            }
        }
            
        print(params)
        
        let encodedURL = "https://ocrf6suq56.execute-api.us-east-1.amazonaws.com/dev/health/createUPCEntry"
        
        AF.request(encodedURL, method: .post, parameters: params, encoding: JSONEncoding.default, interceptor: nil).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                if json["error"]=="Item already catalogued"{
                    self.present(already, animated: true, completion: nil)
                }else{
                    self.present(alerto, animated: true, completion: nil)
                }
                self.resetView()

            case .failure(let error):
                print(error)
                
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func resetView(){
        self.foodJSON = nil
        self.upcCode = nil
        self.notesEdited = false
        
        targetGroupField.text = "Infants"
        storeField.text = "Whole Foods"
        
        self.notesTF.text = "Write notes here!"
        self.notesTF.textColor = Constants.Colors.lightGray
        
        breakCB.setCheckState(M13Checkbox.CheckState.unchecked, animated: true)
        lunchCB.setCheckState(M13Checkbox.CheckState.unchecked, animated: true)
        dinCB.setCheckState(M13Checkbox.CheckState.unchecked, animated: true)
        snackCB.setCheckState(M13Checkbox.CheckState.unchecked, animated: true)
        
        self.imageView.image = UIImage(named: "noBarcode")
        upcLabel.text = "UPC #: "
        nameLabel.text = "Name: "
        nutritionLabel.text = "Brand: "
        ingredientsLabel.text = "Ingredients: "
        
    }
    
    func setData(data: JSON, code: String){
        
        if let dict = data["foods"][0].dictionaryObject{
            foodJSON = dict
        } else{
            return
        }
        
        upcLabel.attributedText = attributedText(withString: "UPC #: " + code, boldString: "UPC #: ", font: UIFont.systemFont(ofSize: 14))

        if let ingredients = data["foods"][0]["nf_ingredient_statement"].string{
            ingredientsLabel.attributedText = attributedText(withString: "Ingredients: " + ingredients, boldString: "Ingredients: ", font: UIFont.systemFont(ofSize: 14))
        }
        if let brand = data["foods"][0]["brand_name"].string{
            nutritionLabel.attributedText = attributedText(withString: "Brand: " + brand, boldString: "Brand: ", font: UIFont.systemFont(ofSize: 14))
        }
        if let name = data["foods"][0]["food_name"].string{
            nameLabel.attributedText = attributedText(withString: "Name: " + name, boldString: "Name: ", font: UIFont.systemFont(ofSize: 14))
        }
        let widthThing = (Constants.Screen.width-imageView.intrinsicContentSize.width-40)
        let numLines = Int(ingredientsLabel.intrinsicContentSize.width/widthThing)
        let scrollSize = CGSize(width: widthThing,
                                height: CGFloat((numLines+5)*20))
        scrolly.contentSize = scrollSize
        scrolly.isDirectionalLockEnabled = true
        scrolly.alwaysBounceHorizontal = false
        
        
        ingredientsLabel.autoSetDimension(.width, toSize: widthThing)
        nameLabel.autoSetDimension(.width, toSize: widthThing)
        nameLabel.numberOfLines = Int(nameLabel.intrinsicContentSize.width/widthThing) + 5
        ingredientsLabel.numberOfLines = numLines + 5
        if let photoLink = data["foods"][0]["photo"]["thumb"].string{
            let firstmod = photoLink.replacingOccurrences(of: "\\" , with: "")
            if let url = URL(string: firstmod){
             downloadImage(from: url)
            }
        }else{
            imageView.image = UIImage(named: "noImage")
        }
        
        
        dismiss(animated: true, completion: nil)
        
    }
    //barcode scanning
    @objc func scanBarcode(){
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        viewController.headerViewController.titleLabel.text = "Scan barcode"
        viewController.headerViewController.titleLabel.textColor = Constants.Colors.darkGray
        viewController.headerViewController.closeButton.tintColor = Constants.Colors.mainBlue
        viewController.messageViewController.regularTintColor = Constants.Colors.darkGray
        viewController.messageViewController.errorTintColor = .red
        viewController.messageViewController.textLabel.textColor = Constants.Colors.darkGray
        viewController.cameraViewController.barCodeFocusViewType = .animated
        // Show camera position button
        viewController.cameraViewController.showsCameraButton = true
        
        present(viewController, animated: true, completion: nil)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print(code)
        if let cod = self.upcCode{
            if cod==code{
                dismiss(animated: true, completion: nil)
            }
        }
        //send it or whatever
        let headers: HTTPHeaders = ["x-app-key": "5220d22fce42b72eb94facf26358db37", "x-app-id": "7ab8d245"]
        let encodedURL = "https://trackapi.nutritionix.com/v2/search/item"
        let params: Parameters = ["upc": code]
        AF.request(encodedURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers, interceptor: nil).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["message"]=="resource not found"{
                    controller.resetWithError(message: "Product not found")
                }else{
                    self.upcCode = code
                    self.setData(data: json, code: code)
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
        
    }
}
