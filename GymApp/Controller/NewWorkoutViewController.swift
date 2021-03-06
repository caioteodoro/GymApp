//
//  NewWorkoutViewController.swift
//  GymApp
//
//  Created by Caio Teodoro on 29/05/22.
//

import UIKit
import FirebaseFirestore
import MaterialComponents
import SwiftUI
import FirebaseAuth

class NewWorkoutViewController: UIViewController {
    
    @IBOutlet weak var doneButton: MDCButton!
    @IBOutlet weak var exercisesTableView: UITableView!
    @IBOutlet weak var descriptionTextField: MDCFilledTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var allExercises = [Exercicio]()
    var selectedExercises = [Int]()
    var userWorkouts = [Treino]()
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getExercises()
        
        exercisesTableView.dataSource = self
        exercisesTableView.delegate = self
        exercisesTableView.allowsMultipleSelection = true
        
        errorLabel.alpha = 0
        
        customizeButton(button: doneButton,
                        bgColor: UIColor.tanColor,
                        title: "Concluído",
                        txtColor: UIColor.creamColor)
        
        customizeFilledTextField(textField: descriptionTextField,
                                 label: "Descrição",
                                 placeholder: "Treino A",
                                 underlineColorNormal: UIColor.goldColor,
                                 underlineColorEditing: UIColor.tanColor,
                                 backgroundColorNormal: UIColor.creamColor,
                                 backgroundColorEditing: UIColor.goldColor)
    }
    
    func printError (_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if descriptionTextField.text == "" {
            printError("Preencha a descrição")
        } else if selectedExercises.isEmpty {
            printError("Selecione ao menos um exercício")
        } else {
            
            db.collection("users").whereField("uid", isEqualTo: uid!).getDocuments { snapshot, err in
                if err != nil {
                    print(err!.localizedDescription)
                } else {
                    for document in snapshot!.documents {
                        let docRef = document.documentID
                        var currentName = 0
                        if !self.userWorkouts.isEmpty {
                            currentName = self.userWorkouts.last!.nome + 1
                        }

                        self.db.collection("users").document(docRef).collection("customWorkouts").addDocument(data: ["uid":self.uid ?? "",
                                                "nome": currentName,
                                                "descricao":self.descriptionTextField.text ?? "",
                                                "data":Date(),
                                                "exercicios":self.selectedExercises
                                                ]) { err in
                                if err != nil { print(err!.localizedDescription) }
                        }
                    }
                }
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("UpdateTableViewIdentifier"), object: nil)
            self.dismiss(animated: true)
            
        }
    }
}

extension NewWorkoutViewController: UITableViewDelegate, UITableViewDataSource {

    func getExercises() {
        
        db.collection("exercises").getDocuments { snapshot, error in
            if error != nil {
                print("Documentos não encontrados")
            } else {
                var rawExercises = [Exercicio]()
                for document in snapshot!.documents {
                    let documentName = document.get("nome") as! Int
                    let documentImage = URL(string: document.get("imagem") as! String)
                    let documentDescription = document.get("obsevacoes") as! String
                    rawExercises.append(Exercicio(nome: documentName,
                                                    imagem: documentImage!,
                                                    observacoes: documentDescription))
                }
                self.allExercises = rawExercises.sorted { exerciseA, exerciseB in
                    exerciseA.nome < exerciseB.nome
                }
                self.exercisesTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as? CustomCell else { fatalError() }
        
        cell.titleLabel.text = String(allExercises[indexPath.row].nome)
        cell.descriptionLabel.text = allExercises[indexPath.row].observacoes
        
        let iconView = UIImageView()
        iconView.sd_setImage(with: allExercises[indexPath.row].imagem)
        cell.icon.image = iconView.image

        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let exerciseName = indexPath.row + 1
        let exerciseIndex = selectedExercises.firstIndex(of: exerciseName)!
        selectedExercises.remove(at: exerciseIndex)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exerciseName = indexPath.row + 1
        selectedExercises.append(exerciseName)
    }
    
    
}
