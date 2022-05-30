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
    @IBOutlet weak var workoutsTableView: UITableView!
    @IBOutlet weak var descriptionTextField: MDCFilledTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var rawExercises = [Exercicio]()
    var exercises = [Exercicio]()
    var selectedExercises = [Int]()
    let db = Firestore.firestore()
    let currentUID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getExercises()
        
        workoutsTableView.dataSource = self
        workoutsTableView.delegate = self
        workoutsTableView.allowsMultipleSelection = true
        
        errorLabel.alpha = 0
        
        customizeButton(button: doneButton,
                        bgColor: UIColor.tanColor,
                        title: "Concluído",
                        txtColor: UIColor.charcoalColor)
        
        customizeFilledTextField(textField: descriptionTextField,
                                 label: "Descrição",
                                 placeholder: "Treino A",
                                 underlineColorNormal: UIColor.goldColor,
                                 underlineColorEditing: UIColor.tanColor,
                                 backgroundColorNormal: UIColor.goldColor,
                                 backgroundColorEditing: UIColor.tanColor)
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
            db.collection("customWorkouts").whereField("userID", isEqualTo: currentUID!).getDocuments { snapshot, err in
                let userWorkoutsCount = snapshot?.count
                self.db.collection("customWorkouts").addDocument(data: ["userID":self.currentUID ?? "",
                                                                   "nome": userWorkoutsCount ?? 0,
                                                                   "descricao":self.descriptionTextField.text ?? "",
                                                                   "data":Date(),
                                                                   "exercicios":self.selectedExercises
                                                                  ]) { err in
                    if err != nil {
                        print(err!.localizedDescription)
                    }
                }
            }
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
                for document in snapshot!.documents {
                    let documentName = document.get("nome") as! Int
                    let documentImage = URL(string: document.get("imagem") as! String)
                    let documentDescription = document.get("obsevacoes") as! String
                    self.rawExercises.append(Exercicio(nome: documentName,
                                                    imagem: documentImage!,
                                                    observacoes: documentDescription))
                }
                self.exercises = self.rawExercises.sorted { exerciseA, exerciseB in
                    exerciseA.nome < exerciseB.nome
                }
                self.workoutsTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as? CustomCell else { fatalError() }
        
        cell.titleLabel.text = String(exercises[indexPath.row].nome)
        cell.descriptionLabel.text = exercises[indexPath.row].observacoes
        
        let iconView = UIImageView()
        iconView.sd_setImage(with: exercises[indexPath.row].imagem)
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
