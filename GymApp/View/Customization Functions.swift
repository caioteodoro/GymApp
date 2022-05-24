//
//  Customization Functions.swift
//  GymApp
//
//  Created by Caio Teodoro on 23/05/22.
//

import Foundation
import MaterialComponents

func customizeButton(button: MDCButton,
                     bgColor: UIColor,
                     title: String,
                     txtColor: UIColor) {
    let button = button
    button.setTitle(title, for: .normal)
    button.setBackgroundColor(bgColor)
    button.setTitleColor(txtColor, for: .normal)
    button.setTitleColor(txtColor, for: .selected)
    button.setTitleColor(txtColor, for: .focused)
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
