import 'package:appsqlite/model/Book.dart';
import 'package:appsqlite/services/BookService.dart';
import 'package:flutter/material.dart';

class AddBook extends StatefulWidget {
  const AddBook({Key? key}) : super(key: key);

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final _bookTitleController = TextEditingController();
  final _bookNumChaptersController = TextEditingController();
  final _bookNumPagesController = TextEditingController();
  final _bookSummaryController = TextEditingController();
  bool _validateTitle = false;
  bool _validateNumChapters = false;
  bool _validateNumPages = false;
  bool _validateSummary = false;
  final _bookService = BookService();

  @override
  void initState() {
    setState(() {
      _bookTitleController.text = '';
      _bookNumChaptersController.text = '';
      _bookNumPagesController.text = '';
      _bookSummaryController.text = '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scarin Library"),
        backgroundColor: Colors.red, // Cor da AppBar para harmonizar com o design
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cadastro de Livro',
                style: TextStyle(
                  fontSize: 24, // Ajuste de tamanho da fonte
                  color: Colors.red, // Cor destacada
                  fontWeight: FontWeight.w600, // Deixa o texto mais proeminente
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _bookTitleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintText: 'Título do livro',
                  labelText: 'Título',
                  errorText: _validateTitle
                      ? 'Título do livro não pode ser vazio'
                      : null,
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _bookNumChaptersController,
                keyboardType: TextInputType.number, // Torna o campo numérico
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintText: 'Número de capítulos',
                  labelText: 'Capítulos',
                  errorText: _validateNumChapters
                      ? 'Capítulos do livro não pode ser vazio'
                      : null,
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _bookNumPagesController,
                keyboardType: TextInputType.number, // Campo numérico
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintText: 'Número de páginas',
                  labelText: 'Páginas',
                  errorText: _validateNumPages
                      ? 'Páginas do livro não pode ser vazio'
                      : null,
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _bookSummaryController,
                maxLength: 500, // Limita o resumo a 500 caracteres
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintText: 'Resumo do livro',
                  labelText: 'Resumo',
                  errorText:
                      _validateSummary ? 'Resumo não pode ser vazio' : null,
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0, 
                        horizontal: 24.0,
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () async {
                      setState(() {
                        _validateTitle = _bookTitleController.text.isEmpty;
                        _validateNumChapters =
                            _bookNumChaptersController.text.isEmpty;
                        _validateNumPages =
                            _bookNumPagesController.text.isEmpty;
                        _validateSummary =
                            _bookSummaryController.text.isEmpty;
                      });

                      if (!_validateTitle &&
                          !_validateNumChapters &&
                          !_validateNumPages &&
                          !_validateSummary) {
                        var _book = Book();
                        _book.title = _bookTitleController.text;
                        _book.numPages = int.tryParse(_bookNumPagesController.text) ?? 0;
                        _book.numChapters = int.tryParse(_bookNumChaptersController.text) ?? 0;
                        _book.summary = _bookSummaryController.text;

                        var result = await _bookService.updateBook(_book);
                        Navigator.pop(context, result);
                      }
                    },
                    child: const Text('Salvar'),
                  ),
                  const SizedBox(width: 10.0),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 24.0,
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      _bookTitleController.clear();
                      _bookNumPagesController.clear();
                      _bookSummaryController.clear();
                    },
                    child: const Text('Limpar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
