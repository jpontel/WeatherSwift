import SwiftUI

struct WeatherView: View {
    var city: String
    var temperature: String
    var description: String

    var body: some View {
        VStack {
            Text(city)
                .font(.largeTitle)
                .bold()
                .padding()

            Text(temperature)
                .font(.system(size: 60))
                .bold()
                .padding()

            Text(description)
                .font(.title)
                .padding()
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        VStack {
            WeatherView(
                city: viewModel.city,
                temperature: viewModel.temperature,
                description: viewModel.description
            )

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
                startPoint: UnitPoint(x: 0.98, y: 0),
                endPoint: UnitPoint(x: 0.02, y: 0.99)
            )
            .ignoresSafeArea()
        )
    }
}

#Preview {
    ContentView()
}
