//
//  File.swift
//  Todo
//
//  Created by 김도윤 on 2023/08/28.
//

import UIKit

class CatDogImageViewController: UIViewController {
    @IBOutlet var changeImage: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        loadRandomAnimalImage()
    }

    @IBAction func changeImage(_ sender: UIBarButtonItem) {
        for subview in view.subviews {
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }

        loadRandomAnimalImage()
    }

    func loadRandomAnimalImage() {
        let animalChoice = ["cat", "dog"].randomElement() ?? "cat"
        fetchImage(for: animalChoice) { imageUrl in
            if let imageUrl = imageUrl {
                self.displayImage(from: imageUrl)
            }
        }
    }

    func fetchImage(for animal: String, completion: @escaping (String?) -> Void) {
        var urlString = ""

        switch animal {
        case "cat":
            urlString = "https://api.thecatapi.com/v1/images/search"
        case "dog":
            urlString = "https://api.thedogapi.com/v1/images/search"
        default:
            return
        }

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    if let imageUrl = jsonArray.first?["url"] as? String {
                        completion(imageUrl)
                    }
                }
            } catch {
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
        }

        task.resume()
    }

    func displayImage(from url: String) {
        guard let imageUrl = URL(string: url) else { return }

        let task = URLSession.shared.dataTask(with: imageUrl) { data, _, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            DispatchQueue.main.async {
                let image = UIImage(data: data)
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: 50, y: 280, width: 300, height: 300)
                self.view.addSubview(imageView)
            }
        }

        task.resume()
    }
}
