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

class CollectDataViewController: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate, BarcodeScannerErrorDelegate{
    
    
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
    let targetGroupBT: UIButton = {
        let buttonView = UIButton()
        buttonView.setTitle("Infants", for: .normal)
        buttonView.setTitleColor(Constants.Colors.darkGray, for: .normal)
        buttonView.setTitleColor(Constants.Colors.lightGray, for: .highlighted)
        buttonView.layer.cornerRadius = 4
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = Constants.Colors.darkGray.cgColor
        buttonView.clipsToBounds = true
        buttonView.backgroundColor = UIColor.white
        buttonView.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        buttonView.addTarget(self, action: #selector(CollectDataViewController.chooseTargetGroup), for: .touchUpInside)
        return buttonView
    }()
    let storeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.textColor = Constants.Colors.darkGray
        label.text = "Store"
        return label
    }()
    let storeBT: UIButton = {
        let buttonView = UIButton()
        buttonView.setTitle("Whole Foods", for: .normal)
        buttonView.setTitleColor(Constants.Colors.darkGray, for: .normal)
        buttonView.setTitleColor(Constants.Colors.lightGray, for: .highlighted)
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = Constants.Colors.darkGray.cgColor
        buttonView.layer.cornerRadius = 4
        buttonView.clipsToBounds = true
        buttonView.backgroundColor = UIColor.white
        buttonView.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        buttonView.addTarget(self, action: #selector(CollectDataViewController.chooseTargetGroup), for: .touchUpInside)
        return buttonView
    }()
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
    let notesTF: UITextField = {
        let field = UITextField()
        field.placeholder = "Write a note about the food"
        return field
    }()
    //third view
    let thirdView: UIView = {
       let view = UIView()
        return view
    }()
    let imageView: UIImageView = {
        let view  = UIImageView()
        return view
    }()
    let upcLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Constants.Colors.darkGray
        label.text = "UPAC #: 292489123"
        return label
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Constants.Colors.darkGray
        label.text = "Dasani Water"
        return label
    }()
    let nutritionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Constants.Colors.darkGray
        label.text = "Nutrition Rating: 3%"
        return label
    }()
    let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Constants.Colors.darkGray
        label.text = "Ingredients: Water, salt, Tomatoes"
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
        buttonView.setTitleColor(UIColor.white, for: .normal)
        buttonView.setTitleColor(Constants.Colors.lightGray, for: .highlighted)
        buttonView.layer.cornerRadius = 5
        buttonView.clipsToBounds = true
        buttonView.backgroundColor = Constants.Colors.darkBlue
        buttonView.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        buttonView.addTarget(self, action: #selector(CollectDataViewController.scanBarcode), for: .touchUpInside)
        return buttonView
    }()
    let submitDataBT: UIButton = {
        let buttonView = UIButton()
        buttonView.setTitle("SUBMIT DATA", for: .normal)
        buttonView.setTitleColor(UIColor.white, for: .normal)
        buttonView.setTitleColor(Constants.Colors.lightGray, for: .highlighted)
        buttonView.layer.cornerRadius = 4
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
        topView.addSubview(targetGroupBT)
        topView.addSubview(storeLabel)
        topView.addSubview(storeBT)
        secondView.addSubview(breakCB)
        secondView.addSubview(breakLabel)
        secondView.addSubview(lunchCB)
        secondView.addSubview(lunchLabel)
        secondView.addSubview(dinCB)
        secondView.addSubview(dinLabel)
        secondView.addSubview(snackCB)
        secondView.addSubview(snackLabel)
        thirdView.addSubview(imageView)
        thirdView.addSubview(upcLabel)
        thirdView.addSubview(nameLabel)
        thirdView.addSubview(nutritionLabel)
        thirdView.addSubview(ingredientsLabel)
        lastView.addSubview(scanBarcodeBT)
        lastView.addSubview(submitDataBT)
        
        let elements = [topView, mealsIncludedLabel, secondView, thirdView, lastView, notesLabel, notesTF]
        for element in elements{
            view.addSubview(element)
        }
        
        topView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15), excludingEdge: .bottom)
        targetGroupLabel.autoPinEdge(toSuperviewEdge: .top)
        targetGroupLabel.autoPinEdge(toSuperviewEdge: .left)
        targetGroupBT.autoPinEdge(.top, to: .bottom, of: targetGroupLabel, withOffset: 5)
        targetGroupBT.autoPinEdge(.left, to: .left, of: targetGroupLabel, withOffset: 0)
        targetGroupBT.autoSetDimension(.height, toSize: 35)
        targetGroupBT.autoSetDimension(.width, toSize: (Constants.Screen.width-40)/2)
        targetGroupBT.autoPinEdge(.right, to: .left, of: storeBT, withOffset: -10)
        
        storeBT.autoPinEdge(toSuperviewEdge: .bottom)
        storeBT.autoPinEdge(toSuperviewEdge: .right)
        storeLabel.autoPinEdge(.bottom, to: .top, of: storeBT, withOffset: -5)
        storeLabel.autoPinEdge(.left, to: .left, of: storeBT, withOffset: 0)
        storeLabel.autoAlignAxis(.horizontal, toSameAxisOf: targetGroupLabel)
        storeBT.autoSetDimension(.height, toSize: 35)
        
        mealsIncludedLabel.autoPinEdge(.top, to: .bottom, of: topView, withOffset: 10)
        mealsIncludedLabel.autoPinEdge(.left, to: .left, of: topView, withOffset: 0)
        
        secondView.autoPinEdge(.top, to: .bottom, of: mealsIncludedLabel, withOffset: 5)
        secondView.autoAlignAxis(toSuperviewAxis: .vertical)
        
        breakCB.autoPinEdge(toSuperviewEdge: .top)
        breakCB.autoPinEdge(toSuperviewEdge: .left)
        breakCB.autoSetDimensions(to: CGSize(width: 20, height: 20))
        breakCB.autoPinEdge(.bottom, to: .top, of: dinCB, withOffset: -5)
        breakLabel.autoAlignAxis(.horizontal, toSameAxisOf: breakCB)
        breakLabel.autoPinEdge(.left, to: .right, of: breakCB, withOffset: 5)
        breakLabel.autoPinEdge(.right, to: .left, of: lunchCB, withOffset: -50)
        
        dinCB.autoPinEdge(toSuperviewEdge: .bottom)
        dinCB.autoPinEdge(toSuperviewEdge: .left)
        dinCB.autoSetDimensions(to: CGSize(width: 20, height: 20))
        dinLabel.autoAlignAxis(.horizontal, toSameAxisOf: dinCB)
        dinLabel.autoPinEdge(.left, to: .right, of: dinCB, withOffset: 5)
        dinLabel.autoPinEdge(.right, to: .left, of: snackCB, withOffset: -50)
        
        lunchLabel.autoPinEdge(toSuperviewEdge: .top)
        lunchLabel.autoPinEdge(toSuperviewEdge: .right)
        lunchLabel.autoAlignAxis(.horizontal, toSameAxisOf: breakLabel)
        lunchCB.autoAlignAxis(.horizontal, toSameAxisOf: lunchLabel)
        lunchCB.autoSetDimensions(to: CGSize(width: 20, height: 20))
        lunchCB.autoPinEdge(.right, to: .left, of: lunchLabel, withOffset: -5)
        lunchCB.autoPinEdge(.bottom, to: .top, of: snackCB, withOffset: -5)
        
        snackLabel.autoPinEdge(toSuperviewEdge: .bottom)
        snackLabel.autoPinEdge(toSuperviewEdge: .right)
        snackCB.autoAlignAxis(.horizontal, toSameAxisOf: dinLabel)
        snackCB.autoAlignAxis(.horizontal, toSameAxisOf: dinCB)
        snackCB.autoSetDimensions(to: CGSize(width: 20, height: 20))
        snackCB.autoPinEdge(.right, to: .left, of: snackLabel, withOffset: -5)
        
        notesLabel.autoPinEdge(.top, to: .bottom, of: secondView, withOffset: 10)
        notesLabel.autoPinEdge(.left, to: .left, of: mealsIncludedLabel, withOffset: 0)
        notesTF.autoPinEdge(.top, to: .bottom, of: notesLabel, withOffset: 5)
        notesTF.autoPinEdge(.left, to: .left, of: notesLabel, withOffset: 0)
        notesTF.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        
        thirdView.autoPinEdge(.top, to: .bottom, of: notesTF, withOffset: 20)
        thirdView.autoPinEdge(.left, to: .left, of: notesLabel, withOffset: 0)
        thirdView.autoPinEdge(.right, to: .right, of: notesTF, withOffset: 0)
        
        imageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), excludingEdge: .right)
        imageView.autoSetDimensions(to: CGSize(width: 100, height: 150))
        upcLabel.autoPinEdge(.left, to: .right, of: imageView, withOffset: 10)
        upcLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        nameLabel.autoPinEdge(.left, to: .right, of: imageView, withOffset: 10)
        nameLabel.autoPinEdge(.top, to: .bottom, of: upcLabel, withOffset: 5)
        nutritionLabel.autoPinEdge(.left, to: .right, of: imageView, withOffset: 10)
        nutritionLabel.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 5)
        ingredientsLabel.autoPinEdge(.left, to: .right, of: imageView, withOffset: 10)
        ingredientsLabel.autoPinEdge(.top, to: .bottom, of: nutritionLabel, withOffset: 5)
        ingredientsLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        
        lastView.autoPinEdge(.top, to: .bottom, of: thirdView, withOffset: 10)
        lastView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        lastView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        
        scanBarcodeBT.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        scanBarcodeBT.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        scanBarcodeBT.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        scanBarcodeBT.autoSetDimension(.height, toSize: 50)
        scanBarcodeBT.autoSetDimension(.width, toSize: (Constants.Screen.width-25)/2)
        scanBarcodeBT.autoPinEdge(.right, to: .left, of: submitDataBT, withOffset: -5)
        
        submitDataBT.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        submitDataBT.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        submitDataBT.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        submitDataBT.autoSetDimension(.height, toSize: 50)
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func chooseTargetGroup(){
        
    }
    @objc func submitData(){
        
    }
    //barcode scanning
    @objc func scanBarcode(){
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        viewController.headerViewController.titleLabel.text = "Scan barcode"
        viewController.headerViewController.closeButton.tintColor = Constants.Colors.mainBlue
        viewController.messageViewController.regularTintColor = .black
        viewController.messageViewController.errorTintColor = .red
        viewController.messageViewController.textLabel.textColor = .black
        viewController.cameraViewController.barCodeFocusViewType = .animated
        // Show camera position button
        viewController.cameraViewController.showsCameraButton = true
        // Set settings button text
        let title = NSAttributedString(
            string: "Settings",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 17), .foregroundColor : UIColor.white]
        )
        
        present(viewController, animated: true, completion: nil)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print(code)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        
    }
}
