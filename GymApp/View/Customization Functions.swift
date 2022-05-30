//
//  Customization Functions.swift
//  GymApp
//
//  Created by Caio Teodoro on 23/05/22.
//

import Foundation
import MaterialComponents
import UIKit

func customizeButton(button: MDCButton,
                     bgColor: UIColor,
                     title: String,
                     txtColor: UIColor) {
    let button = button
    button.setTitle(title, for: .normal)
    button.setBackgroundColor(bgColor)
    button.setTitleColor(txtColor, for: .normal)
    button.setTitleColor(txtColor, for: .highlighted)
}

func customizeOutlinedTextField(textField: MDCOutlinedTextField,
                        label: String,
                        placeholder: String,
                        normalColor: UIColor,
                        editingColor: UIColor){
    let textField = textField
    textField.label.text = label
    textField.placeholder = placeholder
    textField.sizeToFit()
    textField.setOutlineColor(normalColor, for: .normal)
    textField.setOutlineColor(editingColor, for: .editing)
    textField.setFloatingLabelColor(normalColor, for: .normal)
    textField.setFloatingLabelColor(editingColor, for: .editing)
}

func customizeFilledTextField(textField: MDCFilledTextField,
                        label: String,
                        placeholder: String,
                        underlineColorNormal: UIColor,
                        underlineColorEditing: UIColor,
                        backgroundColorNormal: UIColor,
                        backgroundColorEditing: UIColor){
    let textField = textField
    textField.label.text = label
    textField.placeholder = placeholder
    textField.sizeToFit()
    textField.setUnderlineColor(underlineColorNormal, for: .normal)
    textField.setUnderlineColor(underlineColorEditing, for: .editing)
    textField.setFilledBackgroundColor(backgroundColorNormal, for: .normal)
    textField.setFilledBackgroundColor(backgroundColorEditing, for: .editing)
    textField.setFloatingLabelColor(underlineColorEditing, for: .normal)
}
