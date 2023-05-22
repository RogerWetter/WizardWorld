//
//  ContentView.swift
//  WizardWorld
//
//  Created by roger wetter on 05.05.23.
//

import SwiftUI

struct SpellEntry: Decodable, Identifiable {
  var id: String {
    get {
      UUID().uuidString
    }
  }
  var name: String
  var incantation: String?
  var canBeVerbal: Bool?
  var effect: String?
  var type: String?
  var light: String?
  var creator: String?


}

struct ContentView: View {
  @State var data = [SpellEntry]()
  @State var searchText = ""
  var body: some View {
    NavigationStack {
      VStack {

        List(data) { entry in
          NavigationLink(destination: DetailView(entry: entry)) {
            Text(entry.name)
          }
        }
            .onAppear {
              self.loadData()
            }
            .refreshable {
              self.loadData()
            }
            .listStyle(PlainListStyle())
      }
          .navigationTitle("Spells")
    }
        .searchable(text: $searchText)
        .onChange(of: searchText, perform: { val in
          self.loadData()
        })
        .navigationViewStyle(
            StackNavigationViewStyle())
  }


  func loadData() {
    DispatchQueue.global().async {
      do {
        let req = searchText.isEmpty ? "https://wizard-world-api.herokuapp.com/Spells" : "https://wizard-world-api.herokuapp.com/Spells?Name=\(searchText)"
        
        let url = URL(string: req.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "%20"))

        //create a data instance
        let jsonData = try Data(contentsOf: url!)
        let decoder = JSONDecoder()

        //and decode it to Person
        data = try decoder.decode([SpellEntry].self, from: jsonData)

      } catch {
        fatalError("Couldn't load file from main bundle:\n\(error)")
      }
    }
  }

  struct DetailView: View {
    var entry: SpellEntry
    var body: some View {
      VStack {
        Image(systemName: "bolt.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundColor(getColor(light: entry.light ?? "default"))
          .frame(width: UIScreen.main.bounds.width/2)
          
          
        Text("incantation: \(entry.incantation ?? "")").bold()
        Text("effect: \(entry.effect ?? "")").italic()
        Text("type: \(entry.type ?? "")")
        Text("creator: \(entry.creator ?? "")")
        //Text("can be verbal: \(entry.canBeVerbal)")

      }
      .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
          .navigationTitle(entry.name)
    }
    func getColor(light: String) -> Color {
      switch light {
      case "Blue":
        return Color(red: 0x15/255, green: 0x33/255, blue: 0x9b/255, opacity: 1.0) //"#15339b"
      case "IcyBlue":
        return Color(red: 0x6f/255, green: 0x93/255, blue: 0xff/255, opacity: 1.0) //"#6f93ff"
      case "BrightBlue":
        return Color(red: 0x00/255, green: 0x96/255, blue: 0xFF/255, opacity: 1.0) //"#0096FF"
      case "Red":
        return Color(red: 0xc4/255, green: 0x0b/255, blue: 0x0b/255, opacity: 1.0) //"#c40b0b"
      case "Gold":
        return Color(red: 0xec/255, green: 0xaa/255, blue: 0x50/255, opacity: 1.0) //"#ecaa50"
      case "Purple":
        return Color(red: 0x5f/255, green: 0x4e/255, blue: 0xa8/255, opacity: 1.0) //"#5f4ea8"
      case "White":
        return Color(red: 0xff/255, green: 0xff/255, blue: 0xff/255, opacity: 1.0) //"#ffffff"
      case "Green":
        return Color(red: 0x59/255, green: 0xc7/255, blue: 0x2d/255, opacity: 1.0) //"#59c72d"
      case "Orange":
        return Color(red: 0xff/255, green: 0x94/255, blue: 0x4e/255, opacity: 1.0) //"#ff944e"
      case "Pink":
        return Color(red: 0xe7/255, green: 0x4e/255, blue: 0xff/255, opacity: 1.0) //"#e74eff"
      case "Yellow":
        return Color(red: 0xff/255, green: 0xdc/255, blue: 0x4e/255, opacity: 1.0) //"#ffdc4e"
      case "Violet":
        return Color(red: 0xee/255, green: 0x82/255, blue: 0xee/255, opacity: 1.0) // "violet"
      default:
        return Color(red: 0x00/255, green: 0x00/255, blue: 0x00/255, opacity: 1.0) // "000"
      }
    }

  }

}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
