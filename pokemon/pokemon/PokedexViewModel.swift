import Foundation

class PokedexViewModel: ObservableObject {
    @Published var pokemonList: [PokemonListItem] = []
    @Published var isLoading = false
    private var nextUrl: String? = "https://pokeapi.co/api/v2/pokemon?limit=100"
    
    func fetchPokemonList() {
        guard let urlString = nextUrl, let url = URL(string: urlString) else {
         
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
                    let response = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                    var newPokemonList = response.results
                    self.nextUrl = response.next
                    
                    // Fetch images for each Pokémon
                    let group = DispatchGroup()
                    for index in newPokemonList.indices {
                        group.enter()
                        self.fetchPokemonImage(urlString: newPokemonList[index].url) { imageUrl in
                            newPokemonList[index].imageUrl = imageUrl
                            group.leave()
                        }
                    }
                    
                    group.notify(queue: .main) {
                        self.pokemonList.append(contentsOf: newPokemonList)
                        
                    }
                    
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
    
    private func fetchPokemonImage(urlString: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                completion(pokemon.sprites.frontDefault)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

