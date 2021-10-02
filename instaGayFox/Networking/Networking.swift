import Foundation

class Networking {
    func getUserID(nickname: String, completion: @escaping (Result<User, Error>) -> ()) {
        guard let url = URL(string: "https://instagram47.p.rapidapi.com/get_user_id?username=\(nickname)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "x-rapidapi-host": "instagram47.p.rapidapi.com",
            "x-rapidapi-key": "69df373461mshfe787d156405efdp1ee204jsn52635a1c6b60"
        ]
        
        getData(request: request, completion: completion)
    }
    func getStory(userID: Int, completion: @escaping (Result<Stories, Error>) -> ()) {
        guard let url = URL(string: "https://instagram-stories1.p.rapidapi.com/v2/user_stories?userid=\(userID)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "x-rapidapi-host": "instagram-stories1.p.rapidapi.com",
            "x-rapidapi-key": "69df373461mshfe787d156405efdp1ee204jsn52635a1c6b60"
        ]

        
        getData(request: request, completion: completion)
    }
    private func getData<T: Codable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> ()) {
        URLSession.shared.dataTask(with: request) { (data, respons, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }

            do {
                print(String(data: data, encoding: .utf8))
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
