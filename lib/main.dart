import 'package:appsqlite/model/Book.dart';
import 'package:appsqlite/screens/AddBook.dart';
import 'package:appsqlite/screens/EditBook.dart';
import 'package:appsqlite/screens/ViewBooks.dart';
import 'package:appsqlite/services/BookService.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scarin Library',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Book> _bookList = <Book>[]; // Removido o 'late'
  final _bookService = BookService();
  bool _isLoading = true; // Variável para controlar o carregamento

  // Método otimizado para carregar livros
  getAllBookDetails() async {
    var books = await _bookService.readAllBooks();
    _bookList = <Book>[];
    books.forEach((book) {
      setState(() {
        var bookModel = Book();
        bookModel.id = book['id'];
        bookModel.title = book['title'];
        bookModel.numChapters = book['numChapters'];
        bookModel.numPages = book['numPages'];
        bookModel.summary = book['summary'];
        _bookList.add(bookModel);
      });
    });
  }

  @override
  void initState() {
    getAllBookDetails();
    super.initState();
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  _deleteFormDialog(BuildContext context, bookId) {
    return showDialog(
      context: context,
      builder: (param) {
        return AlertDialog(
          title: const Text(
            'Deseja realmente excluir?',
            style: TextStyle(color: Colors.teal, fontSize: 20),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                var result = await _bookService.deleteBook(bookId);
                if (result != null) {
                  Navigator.pop(context);
                  getAllBookDetails();
                  _showSuccessSnackBar('Livro excluído com sucesso!');
                }
              },
              child: const Text('Excluir'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Livros"),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Indicador de progresso
          : _bookList.isEmpty
              ? const Center(child: Text('Nenhum livro encontrado!'))
              : ListView.builder(
                  itemCount: _bookList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewBook(
                                book: _bookList[index],
                              ),
                            ),
                          );
                        },
                        leading: const Icon(Icons.book),
                        title: Text(_bookList[index].title ?? ''),
                        subtitle: Text(
                            '${_bookList[index].numPages ?? 'Não informado'} páginas'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditBook(
                                      book: _bookList[index],
                                    ),
                                  ),
                                ).then((data) {
                                  if (data != null) {
                                    getAllBookDetails();
                                    _showSuccessSnackBar(
                                        'Livro alterado com sucesso!');
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.teal,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _deleteFormDialog(context, _bookList[index].id);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBook()),
          ).then((data) {
            if (data != null) {
              getAllBookDetails();
              _showSuccessSnackBar('Livro adicionado com sucesso!');
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
