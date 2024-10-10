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
  void dispose() {
    // Dispose the controllers to free up resources when the widget is removed
    _bookTitleController.dispose();
    _bookNumChaptersController.dispose();
    _bookNumPagesController.dispose();
    _bookSummaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scarin Library"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cadastro de Livro',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20.0),
            _buildTextField(
              controller: _bookTitleController,
              label: 'Título',
              hintText: 'Título do livro',
              errorText:
                  _validateTitle ? 'Título do livro não pode ser vazio' : null,
            ),
            const SizedBox(height: 20.0),
            _buildTextField(
              controller: _bookNumChaptersController,
              label: 'Capítulos',
              hintText: 'Número de capítulos',
              keyboardType: TextInputType.number,
              errorText: _validateNumChapters
                  ? 'Capítulos do livro não pode ser vazio'
                  : null,
            ),
            const SizedBox(height: 20.0),
            _buildTextField(
              controller: _bookNumPagesController,
              label: 'Páginas',
              hintText: 'Número de páginas',
              keyboardType: TextInputType.number,
              errorText: _validateNumPages
                  ? 'Páginas do livro não pode ser vazio'
                  : null,
            ),
            const SizedBox(height: 20.0),
            _buildTextField(
              controller: _bookSummaryController,
              label: 'Resumo',
              hintText: 'Resumo do livro',
              maxLength: 500,
              errorText: _validateSummary ? 'Resumo não pode ser vazio' : null,
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                _buildButton(
                  label: 'Salvar',
                  backgroundColor: Colors.red,
                  onPressed: _onSave,
                ),
                const SizedBox(width: 10.0),
                _buildButton(
                  label: 'Limpar',
                  backgroundColor: Colors.grey,
                  onPressed: _clearForm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir um campo de texto com validação
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: hintText,
        labelText: label,
        errorText: errorText,
      ),
    );
  }

  // Método para construir os botões
  Widget _buildButton({
    required String label,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 24.0,
        ),
        textStyle: const TextStyle(fontSize: 16),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }

  // Método para salvar o livro
  void _onSave() async {
    setState(() {
      _validateTitle = _bookTitleController.text.isEmpty;
      _validateNumChapters = _bookNumChaptersController.text.isEmpty;
      _validateNumPages = _bookNumPagesController.text.isEmpty;
      _validateSummary = _bookSummaryController.text.isEmpty;
    });

    if (!_validateTitle &&
        !_validateNumChapters &&
        !_validateNumPages &&
        !_validateSummary) {
      var book = Book();
      book.title = _bookTitleController.text;
      book.numChapters = int.tryParse(_bookNumChaptersController.text) ?? 0;
      book.numPages = int.tryParse(_bookNumPagesController.text) ?? 0;
      book.summary = _bookSummaryController.text;

      var result = await _bookService.updateBook(book);
      Navigator.pop(context, result);
    }
  }

  // Método para limpar o formulário
  void _clearForm() {
    _bookTitleController.clear();
    _bookNumChaptersController.clear();
    _bookNumPagesController.clear();
    _bookSummaryController.clear();
  }
}
