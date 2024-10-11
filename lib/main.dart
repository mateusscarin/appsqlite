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
  final _bookService = BookService();
  List<dynamic> _bookList = []; // Lista de livros

  @override
  void initState() {
    super.initState();
    _fetchBooks(); // Carrega os livros ao iniciar
  }

  Future<void> _fetchBooks() async {
    try {
      var books = await _bookService.readAllBooks();
      setState(() {
        _bookList = books.map((book) {
          Book bookModel = Book();
          bookModel.id = book['id'];
          bookModel.title = book['title'];
          bookModel.numChapters = int.tryParse(book['num_chapters']);
          bookModel.numPages = int.tryParse(book['num_pages']);
          bookModel.summary = book['summary'];
          return bookModel;
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar livros: $e')),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
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

  Future<void> _deleteBook(int bookId) async {
    try {
      await _bookService.deleteBook(bookId);
      _showSuccessSnackBar('Livro excluído com sucesso!');
      _fetchBooks(); // Atualiza a lista após exclusão
    } catch (e) {
      _showSuccessSnackBar('Erro ao excluir livro: $e');
    }
  }

  Future<void> _confirmDelete(BuildContext context, int bookId) {
    return showDialog(
      context: context,
      builder: (context) {
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
              onPressed: () {
                _deleteBook(bookId);
                Navigator.pop(context);
              },
              child: const Text('Excluir'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
              ),
              onPressed: () => Navigator.pop(context),
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
      body: _bookList.isEmpty
          ? Center(
              child: Text('Nenhum livro encontrado!',
                  style: TextStyle(fontSize: 20)))
          : ListView.builder(
              itemCount: _bookList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewBook(book: _bookList[index]),
                        ),
                      ).then(
                          (_) => _fetchBooks()); // Atualiza a lista ao voltar
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
                                builder: (context) =>
                                    EditBook(book: _bookList[index]),
                              ),
                            ).then((_) =>
                                _fetchBooks()); // Atualiza a lista ao voltar
                          },
                          icon: const Icon(Icons.edit, color: Colors.teal),
                        ),
                        IconButton(
                          onPressed: () =>
                              _confirmDelete(context, _bookList[index].id),
                          icon: const Icon(Icons.delete, color: Colors.red),
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
          ).then((_) {
            _fetchBooks(); // Atualiza a lista após adicionar um novo livro
            _showSuccessSnackBar('Livro adicionado com sucesso!');
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
