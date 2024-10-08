import 'package:appsqlite/model/Book.dart';
import 'package:appsqlite/services/BookService.dart';
import 'package:flutter/material.dart';

class EditBook extends StatefulWidget {
  final Book book;
  const EditBook({Key? key, required this.book}) : super(key: key);

  @override
  State<EditBook> createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  final _bookTitleController = TextEditingController();
  final _bookNumChaptersController = TextEditingController();
  final _bookNumPagesController = TextEditingController();
  final _bookSummaryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _bookService = BookService();

  @override
  void initState() {
    super.initState();
    _bookTitleController.text = widget.book.title ?? '';
    _bookNumChaptersController.text = '${widget.book.numChapters}';
    _bookNumPagesController.text = '${widget.book.numPages}';
    _bookSummaryController.text = widget.book.summary ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scarin Library"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Editar Livro',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.teal,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _bookTitleController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Título',
                    labelText: 'Título',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Título do livro não pode ser vazio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _bookNumChaptersController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Capítulos',
                    labelText: 'Capítulos',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Capítulos do livro não pode ser vazio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _bookNumPagesController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Páginas',
                    labelText: 'Páginas',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Páginas do livro não pode ser vazia';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _bookSummaryController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Resumo',
                    labelText: 'Resumo',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Resumo não pode ser vazio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            var _book = Book();
                            _book.id = widget.book.id;
                            _book.title = _bookTitleController.text;
                            _book.numPages =
                                int.tryParse(_bookNumPagesController.text) ?? 0;
                            _book.numChapters =
                                int.tryParse(_bookNumChaptersController.text) ??
                                    0;
                            _book.summary = _bookSummaryController.text;
                            _bookService.updateBook(_book);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Atualizar'),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          _bookTitleController.clear();
                          _bookNumChaptersController.clear();
                          _bookNumPagesController.clear();
                          _bookSummaryController.clear();
                        },
                        child: const Text('Limpar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
