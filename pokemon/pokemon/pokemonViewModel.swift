import Foundation

class PokemonViewModel: ObservableObject {
    @Published var pokemon: Pokemon?
    @Published var speciesDescription: String?
    @Published var isLoading = false
    
    func fetchRandomPokemon() {
        let randomId = Int.random(in: 1...898)
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(randomId)"
        fetchPokemonDetail(urlString: urlString)
    }
    
    func fetchPokemonDetail(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }
                guard let data = data else {
                    print("No data received")
                    return
                }
                do {
                    let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                    self.pokemon = pokemon
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
    
   
            }
        

