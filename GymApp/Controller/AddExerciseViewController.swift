//
//  AddExerciseViewController.swift
//  GymApp
//
//  Created by Caio Teodoro on 30/05/22.
//

import UIKit
import MaterialComponents
import FirebaseFirestore

class AddExerciseViewController: UIViewController {

    @IBOutlet weak var doneButton: MDCButton!
    @IBOutlet weak var exercisesTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let db = Firestore.firestore()
    var currentWorkout = Treino()
    var currentExercises = [Exercicio]()
    var missingExercises = [Exercicio]()
    var updatedExercises = [Int]()
    var userDocumentId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Adicionar exercícios"
        
        exercisesTableView.dataSource = self
        exercisesTableView.delegate = self
        exercisesTableView.allowsMultipleSelection = true
        
        customizeButton(button: doneButton,
                        bgColor: UIColor.tanColor,
                        title: "Concluído",
                        txtColor: UIColor.creamColor)
        
        getExercises()
        
        for exercise in currentExercises {
            updatedExercises.append(exercise.nome)
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        db.collection("users").document(userDocumentId).collection("customWorkouts").whereField("nome", isEqualTo: currentWorkout.nome).getDocuments { snapshot, err in
            if err != nil {
                print(err!.localizedDescription)
            } else if snapshot!.count > 1 {
                print("Mais de um treino encontrado com este nome.")
            } else {
                let document = snapshot?.documents.first
                self.db.collection("users").document(self.userDocumentId).collection("customWorkouts").document(document!.documentID).updateData(["exercicios" : self.updatedExercises])
            }
        }
        dismiss(animated: true)
    }
    

}

extension AddExerciseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func getExercises() {
        
        db.collection("exercises").getDocuments { snapshot, error in
            if error != nil {
                print("Documentos não encontrados")
            } else {
                var rawExercises = [Exercicio]()
                for document in snapshot!.documents {
                    let documentName = document.get("nome") as! Int
                    if !self.currentExercises.contains(where: { exercicio in
                        exercicio.nome == documentName
                    }) {
                        let documentImage = URL(string: document.get("imagem") as! String)
                        let documentDescription = document.get("obsevacoes") as! String
                        rawExercises.append(Exercicio(nome: documentName,
                                                        imagem: documentImage!,
                                                        observacoes: documentDescription))
                    }
                }
                self.missingExercises = rawExercises.sorted { exerciseA, exerciseB in
                    exerciseA.nome < exerciseB.nome
                }
                self.exercisesTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missingExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as? CustomCell else { fatalError() }
        
        cell.titleLabel.text = String(missingExercises[indexPath.row].nome)
        cell.descriptionLabel.text = missingExercises[indexPath.row].observacoes
        
        let iconView = UIImageView()
        iconView.sd_setImage(with: missingExercises[indexPath.row].imagem)
        cell.icon.image = iconView.image

        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let exerciseName = missingExercises[indexPath.row].nome
        let exerciseIndex = updatedExercises.firstIndex(of: exerciseName)!
        updatedExercises.remove(at: exerciseIndex)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exerciseName = missingExercises[indexPath.row].nome
        updatedExercises.append(exerciseName)
    }
    
}
