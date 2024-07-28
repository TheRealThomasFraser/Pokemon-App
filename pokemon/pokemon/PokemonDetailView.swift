import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonListItem
    @StateObject private var viewModel = PokemonViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2)
            } else {
                if let detailedPokemon = viewModel.pokemon {
                    VStack {
                        Text(detailedPokemon.name.capitalized)
                            .font(.largeTitle)
                            .padding(.bottom, 20)

                        AsyncImage(url: URL(string: detailedPokemon.sprites.frontDefault)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                            } else if phase.error != nil {
                                Text("Failed to load image")
                                    .foregroundColor(.red)
                            } else {
                                ProgressView()
                            }
                        }

                        Text("Types: " + detailedPokemon.types.map { $0.type.name.capitalized }.joined(separator: ", "))
                            .padding(.top, 20)
                        
                      
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("")
        .onAppear {
            viewModel.fetchPokemonDetail(urlString: pokemon.url)
        }
    }
}

