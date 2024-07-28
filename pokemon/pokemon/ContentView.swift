import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = PokemonViewModel()
    var colours: [Color] = [.blue, .cyan, .green, .indigo, .mint, .orange, .pink, .purple, .red, .teal]
    
    var body: some View {
        
        NavigationView {
            VStack {
                HStack { // Stack for title and pokedex nav link
                    Spacer()
                    Text("Random Pokémon")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    Spacer()
                    NavigationLink(destination: PokedexView()) {
                        Text("Pokédex >")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .background(EmptyView()) // Remove background
                    }
                    Spacer()
                }
                Spacer()
                
                if viewModel.isLoading { // Loading view while waiting on pokemon view to load
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(2)
                    
                } else {
                    if let pokemon = viewModel.pokemon {
                        VStack {
                            Circle()
                                .fill(colours.randomElement() ?? .blue)
                                .padding()
                                .overlay(
                                    AsyncImage(url: URL(string: pokemon.sprites.frontDefault)) { phase in
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
                                )
                            Text(pokemon.name.capitalized)
                                .font(.largeTitle)
                                .foregroundColor(.black) // Adjust text color
                        }
                        .transition(.opacity) // Change to .opacity for a fade-in effect
                    }
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.fetchRandomPokemon()
                }) {
                    Text("New Pokémon")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 20)
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [.purple, .red, .pink]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
            .onAppear {
                viewModel.fetchRandomPokemon()
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

