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
    var allExercises = [Exercicio]()
    var missingExercises = [Exercicio]()
    var userDocumentId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Adicionar exercícios"
        
        exercisesTableView.dataSource = self
        exercisesTableView.delegate = self
        
        customizeButton(button: doneButton,
                        bgColor: UIColor.tanColor,
                        title: "Adicionar",
                        txtColor: UIColor.creamColor)
        
        getExercises()
        
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
    
}
