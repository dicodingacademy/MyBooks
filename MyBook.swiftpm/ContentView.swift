import SwiftUI
import SwiftData

@available(iOS 17, *)
@Model
class Book {
  var title: String
  var author: String
  
  init(title: String, author: String) {
    self.title = title
    self.author = author
  }
}

@available(iOS 17, *)
struct ContentView: View {
  @Environment(\.modelContext) private var context
  @Query var books: [Book]
  @State private var title = ""
  @State private var author = ""
  
  var body: some View {
    NavigationView {
      VStack {
        Form {
          Section(header: Text("Add a New Book")) {
            TextField("Title", text: $title)
            TextField("Author", text: $author)
            Button(action: addBook) {
              Text("Add Book")
            }
          }
        }
        
        List {
          ForEach(books) { book in
            VStack(alignment: .leading) {
              Text(book.title).font(.headline)
              Text(book.author).font(.subheadline)
            }
          }
          .onDelete(perform: deleteBook)
        }
      }
      .navigationTitle("MyBooks")
    }
  }
  
  private func addBook() {
    let newBook = Book(title: title, author: author)
    context.insert(newBook)
    title = ""
    author = ""
  }
  
  private func deleteBook(at offsets: IndexSet) {
    for index in offsets {
      let book = books[index]
      context.delete(book)
    }
  }
}

@available(iOS 17, *)
#Preview {
  ContentView()
    .modelContainer(for: Book.self)
}
