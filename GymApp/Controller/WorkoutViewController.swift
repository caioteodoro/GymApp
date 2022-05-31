//
//  EditWorkoutViewController.swift
//  GymApp
//
//  Created by Caio Teodoro on 30/05/22.
//

import UIKit
import MaterialComponents
import Firebase
import FirebaseAuth

class WorkoutViewController: UIViewController {

    var currentWorkout = Treino()
    let db = Firestore.firestore()
    var exercisesNames = [Int]()
    var exercises = [Exercicio]()
    var userDocumentId = ""
    
    @IBOutlet weak var addExerciseButton: MDCButton!
    @IBOutlet weak var doneButton: MDCButton!
    @IBOutlet weak var exercisesTableView: UITableView!
    @IBOutlet weak var lastWorkoutLabel: UILabel!
    @IBOutlet weak var workoutTitleLabel: UILabel!
    
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm" //yyyy
        return formatter.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExerciseVCSegue" {
            if let addExerciseVC = segue.destination as? AddExerciseViewController {
                addExerciseVC.currentExercises = self.exercises
                addExerciseVC.userDocumentId = self.userDocumentId
                addExerciseVC.currentWorkout = self.currentWorkout
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exercisesTableView.delegate = self
        exercisesTableView.dataSource = self
        
        lastWorkoutLabel.text = "Último treino: " + stringFromDate(currentWorkout.data)
        workoutTitleLabel.text = currentWorkout.descricao
        
        customizeButton(button: addExerciseButton,
                        bgColor: UIColor.tanColor,
                        title: "Adicionar exercício",
                        txtColor: UIColor.creamColor)
        
        customizeButton(button: doneButton,
                        bgColor: UIColor.tanColor,
                        title: "Treino concluído",
                        txtColor: UIColor.creamColor)
        
        getExercises()
     
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        db.collection("users").document(userDocumentId).collection("customWorkouts").whereField("nome", isEqualTo: currentWorkout.nome).getDocuments { snapshot, err in
            if err != nil {
                print(err!.localizedDescription)
            } else if snapshot?.count != 1 {
                print("Mais de um documento encontrado")
            } else {
                let document = snapshot?.documents.first
                document?.reference.updateData(["data":Date()])
                self.currentWorkout.data = Date()
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name("UpdateTableViewIdentifier"), object: nil)
        dismiss(animated: true)
    }
}

extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func getExercises() {
        var rawExercises = [Int]()
        db.collection("users").document(userDocumentId).collection("customWorkouts").whereField("nome", isEqualTo: currentWorkout.nome).getDocuments { snapshot, err in
            if err != nil {
                print(err!.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    let documentExercises = document.get("exercicios") as! [Int]
                    for i in 0...documentExercises.count-1 {
                        rawExercises.append(documentExercises[i])
                    }
                    rawExercises.sort()
                    self.exercisesNames = rawExercises
                    
                    self.db.collection("exercises").getDocuments { snapshot, err in
                        if err != nil {
                            print(err!.localizedDescription)
                        } else {
                            for document in snapshot!.documents {
                                let documentName = document.get("nome") as! Int
                                for i in 0...self.exercisesNames.count-1 {
                                    print("documentName:")
                                    print(documentName)
                                    print("i:")
                                    print(i)
                                    if documentName == self.exercisesNames[i] {
                                        print("If acessado!")
                                        print(i)
                                        let documentImage = URL(string: document.get("imagem") as! String)
                                        let documentDescription = document.get("obsevacoes") as! String
                                        self.exercises.append(Exercicio(nome: documentName,
                                                                           imagem: documentImage!,
                                                                           observacoes: documentDescription))
                                    }
                                }
                            }
                            self.exercisesTableView.reloadData()
                        }
                    }
                }
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as? CustomCell else { fatalError() }
        
        cell.titleLabel.text = String(exercises[indexPath.row].nome)
        cell.descriptionLabel.text = exercises[indexPath.row].observacoes
        
        let iconView = UIImageView()
        iconView.sd_setImage(with: exercises[indexPath.row].imagem)
        cell.icon.image = iconView.image

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            exercises.remove(at: indexPath.row)
            self.exercisesTableView.deleteRows(at: [indexPath], with: .fade)
            
            db.collection("users").document(userDocumentId).collection("customWorkouts").whereField("nome", isEqualTo: self.currentWorkout.nome).getDocuments { snapshot, err in
                if err != nil {
                    print(err!.localizedDescription)
                } else if snapshot!.count > 1 {
                    print("Mais de um treino encontrado.")
                } else {
                    let document = snapshot?.documents.first
                    var updatedExercises = [Int]()
                    for exercise in self.exercises {
                        updatedExercises.append(exercise.nome)
                    }
                    self.db.collection("users").document(self.userDocumentId).collection("customWorkouts").document(document!.documentID).updateData(["exercicios" : updatedExercises])
                }
            }
        }
    }

}
