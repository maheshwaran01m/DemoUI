//
//  CustomMacroView.swift
//  DemoUI
//
//  Created by MAHESHWARAN on 21/06/26.
//

import SwiftUI
import SwiftData
import Observation

struct CustomMacroView: View {
  
  var body: some View {
    contentView
  }
}

extension CustomMacroView {
  
  var contentView: some View {
//    previewView
        AsyncImageView()
//        ToolbarView()
//        TabBarView()
//        SwipeActionView()
//        ReorderContentView()
//     OtherSwiftUIAPI()
  }
  
  var previewView: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }
  
  @Observable
  final class ModelItem {
    var title: String
    
    init(title: String) {
      self.title = title
    }
  }

  struct StateMacroView: View {
    
    static let x = [Color.red, .green, .blue]
    
    @State private var color = x.randomElement()
    /*
     @attached(accessor, names: named(init), named(get), named(set)) @attached(peer, names: prefixed(`_`), prefixed(__), prefixed(`$`)) public macro State() = #externalMacro(module: "SwiftUIMacros", type: "StateMacro")
     */
    
    // state is now lazily initialized, only
    // created once for the lifetime of the view
    // It won't re-initialize in each view updates
    // iOS 17+ need macro support / xcode 27 regenerate sdk
    @State var selectedValue = 0
    
    var body: some View {
      Text("Selected Value \(selectedValue)")
    }
  }

  // MARK: - Async Image

  struct AsyncImageView: View {
    
    @State var records = [Item]()
    
    var body: some View {
      contentView
      .task { await load() }
    }
    
    @ContentBuilder // To avoid type check issue in given time
    var contentView: some View {
      if !records.isEmpty {
        ScrollView {
          ForEach(records) { record in
            /// Not async image cache the image by default when you scroll bottom to top
            AsyncImage(url: record.url)
  //            .asyncImageURLSession(<#T##urlSession: URLSession##URLSession#>)
          }
        }
      } else {
        ContentUnavailableView("No Records", systemImage: "note.text")
      }
    }
    
    struct Item: Identifiable, Hashable {
      var id: String
      var url: URL?
      
      init(url urlString: String) {
        self.id = urlString + "_ID"
        self.url = URL(string: urlString)
      }
    }
    
    private func load() async {
      try? await Task.sleep(for: .seconds(1))
      
      records = (0..<10).map { _ in
        Item(url: "https://picsum.photos/seed/\(UUID().uuidString)/300/300")
      }
    }
  }

  // MARK: - Toolbar

  struct ToolbarView: View {
    
    var body: some View {
      NavigationStack {
        Text("Toolbar")
          .toolbar {
            
            // iOS 14+
            ToolbarItem(placement: .topBarPinnedTrailing) {
              Button("Share", systemImage: "square.and.arrow.up") {
                
              }
            }
            
            ToolbarItemGroup {
              
              Button("Undo", systemImage: "arrow.uturn.backward") {
                
              }
              
              Button("Redo", systemImage: "arrow.uturn.forward") {
                
              }
            }
            .visibilityPriority(.high) // iOS 27+
            
            // iOS 27+
            ToolbarOverflowMenu {
              Button("Copy", systemImage: "document.on.document") {
                
              }
              
              Button("Star", systemImage: "star") {
                
              }
              
              Button("Copy1", systemImage: "document.on.document") {
                
              }
              
              Button("Star2", systemImage: "star") {
                
              }
              
              Menu("Menu") {
                Button("Copy1", systemImage: "document.on.document") {
                  
                }
                
                Button("Star2", systemImage: "star") {
                  
                }
              }
            }
            
            
          }
      }
    }
  }

  // MARK: - Tab View

  struct TabBarView: View {
    
    var body: some View {
      TabView {
        Tab("Home", systemImage: "house") {
          Color.red
        }
        
        Tab("Library", systemImage: "heart.fill") {
          Color.yellow
        }
        
        Tab("Settings", systemImage: "gear") {
          Color.green
        }
        
        /*
        Tab("Search", systemImage: "magnifyingglass", role: .search) {
          Color.gray
        }
        */
        
        // iOS 27+
        Tab("Add", systemImage: "plus", role: .prominent) {
          Color.blue
        }
        
      }
    }
  }

  // MARK: - Swipe Action without List

  struct SwipeActionView: View {
    
    // Minimize toolbar when scrolling in macOS
    var body: some View {
      ScrollView {
        VStack {
          ForEach(ReorderContentView.Item.automatic) { record in
            Text(record.title)
              .padding()
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(.blue.opacity(0.3))
              .swipeActions {
                Button("Delete", role: .destructive) {
                  
                }
                
                Button("Redo", role: .cancel) {
                  
                }
              }
          }
        }
        .padding(.horizontal)
        .toolbar {
          ToolbarItem(placement: .navigation) {
            Button("Undo") {
              
            }
          }
          
          ToolbarItem(placement: .topBarTrailing) {
            Button("Redo") {
              
            }
          }
        }
      }
      .swipeActionsContainer()
    }
  }

  // MARK: - New Available SwiftUI API

  struct OtherSwiftUIAPI: View {

    @available(anyAppleOS 27.0, *)

    // @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func exampleForAvailableAPI() { }

    // MARK: - New ContentBuilder
    
    /*
     @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
     public typealias ContentBuilder = ViewBuilder
     */
    
    /// To reduce time in decision tree while type check
    @ContentBuilder
  //  @ViewBuilder
    func exampleForContentBuilder() -> some View {
      
     ScrollView {
        VStack(alignment: .leading) {
          ForEach(1..<21, id: \.self) { index in
            
            VStack(alignment: .leading) {
              Text("Title \(index)")
              
                HStack {
                  ForEach(1..<4, id: \.self) { index in
                  Text("Subtitle \(index)")
                }
                  .padding()
                  .background(Color.red, in: .capsule)
              }
              
              // Complex Views....
            }
          }
        }
      }
    }

    
    var body: some View {
      exampleForContentBuilder()
    }
    
    
    // MARK: - To Delete Project Cache
    
    // Product -> Delete Derived Data
  }

  // MARK: - Reorder

  struct ReorderContentView: View {
    
    @State var records = Item.automatic
    
    var body: some View {
      List {
        ForEach(records) { record in
          Text(record.title)
            .contentShape(.rect)
        }
        .reorderable() // iOS 27+
      }
      .reorderContainer(for: Item.self) { difference in
        difference.apply(to: &records)
      }
    }
    
    struct Item: Identifiable, Hashable {
      let id: String
      let title: String
      
      init(title: String) {
        self.id = title + "_ID"
        self.title = title
      }
      
      static let automatic: [Self] = (1..<21).map { Item(title: "\($0)") }
    }
  }

  /*
   import OrderedCollections // from https://github.com/apple/swift-collections

   extension ReorderDifference where CollectionID == ReorderableSingleCollectionIdentifier {
       
   func apply(to values: inout [some Identifiable<ItemID>]) {
           var dictionary = OrderedDictionary(uniqueKeys: values.map { $0.id }, values: values)
           let destinationOffset: Int? = switch destination.position {
           case .before(let destination):
               dictionary.keys.firstIndex(of: destination)
           case .end:
               nil
           }
           dictionary.move(keys: sources, to: destinationOffset ?? values.endIndex)
           values = dictionary.values.elements
       }
   }
   
   */
}

fileprivate extension ReorderDifference where CollectionID == ReorderableSingleCollectionIdentifier {
  
  func apply<T: Identifiable<ItemID>>(to values: inout [T]) {
    var copy = values
    let sourceIDs = Set(sources)
    
    let movedItems = copy.filter { sourceIDs.contains($0.id) }
    copy.removeAll { sourceIDs.contains($0.id) }
    
    let insertionIndex: Int = switch destination.position {
    case .before(let destinationID):
      copy.firstIndex { $0.id == destinationID } ?? copy.endIndex
      
    case .end:
      copy.endIndex
    }
    
    copy.insert(contentsOf: movedItems, at: insertionIndex)
    values = copy
  }
}
