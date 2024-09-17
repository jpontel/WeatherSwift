import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var startPoint = UnitPoint(x: 0.98, y: 0)
    @State private var endPoint = UnitPoint(x: 1.2, y: 1.5)

    var body: some View {
        HStack {
            
        }
        VStack {
            Text(viewModel.city)
                .font(.largeTitle)
                .bold()
                .padding()
                .foregroundColor(.white)

            Text(viewModel.temperature)
                .font(.system(size: 60))
                .bold()
                .padding()
                .foregroundColor(.white)

            Text(viewModel.description)
                .font(.title)
                .padding()
                .foregroundColor(.white)

            TextField("Enter City", text: $viewModel.city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                viewModel.fetchWeather(for: viewModel.city)
            }) {
                Text("Get Weather")
                    .bold()
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.15, green: 0.47, blue: 0.8), location: 0.29),
                    Gradient.Stop(color: Color(red: 0.01, green: 0.35, blue: 0.69), location: 0.49),
                    Gradient.Stop(color: Color(red: 0.11, green: 0.43, blue: 0.76), location: 0.67),
                    Gradient.Stop(color: Color(red: 0.59, green: 0.79, blue: 1), location: 1.00),
                ],
                startPoint: startPoint,
                endPoint: endPoint
            )
            .ignoresSafeArea()
        )
        .onAppear {
            withAnimation(Animation.linear(duration: 7.0).repeatForever(autoreverses: true)) {
                startPoint = UnitPoint(x: 1, y: 0)
                endPoint = UnitPoint(x: 0, y: 1)
            }
        }
    }
}

#Preview {
    ContentView()
}
