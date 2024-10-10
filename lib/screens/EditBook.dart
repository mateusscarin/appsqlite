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
  void dispose() {
    // Liberar os controladores quando o widget for descartado
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
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                controller: _bookTitleController,
                label: 'Título',
                hintText: 'Título',
                validatorMessage: 'Título do livro não pode ser vazio',
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                controller: _bookNumChaptersController,
                label: 'Capítulos',
                hintText: 'Capítulos',
                validatorMessage: 'Capítulos do livro não pode ser vazio',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                controller: _bookNumPagesController,
                label: 'Páginas',
                hintText: 'Páginas',
                validatorMessage: 'Páginas do livro não pode ser vazia',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20.0),
              _buildTextField(
                controller: _bookSummaryController,
                label: 'Resumo',
                hintText: 'Resumo',
                validatorMessage: 'Resumo não pode ser vazio',
                maxLines: 5,
                maxLength: 500,
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      label: 'Atualizar',
                      backgroundColor: Colors.teal,
                      onPressed: _onUpdate,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: _buildButton(
                      label: 'Limpar',
                      backgroundColor: Colors.red,
                      onPressed: _onClear,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir campos de texto com validação
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required String validatorMessage,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        labelText: label,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        return null;
      },
    );
  }

  // Método para construir botões
  Widget _buildButton({
    required String label,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        textStyle: const TextStyle(fontSize: 15),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }

  // Método para atualizar o livro
  void _onUpdate() {
    if (_formKey.currentState!.validate()) {
      var _book = Book();
      _book.id = widget.book.id;
      _book.title = _bookTitleController.text;
      _book.numPages = int.tryParse(_bookNumPagesController.text) ?? 0;
      _book.numChapters = int.tryParse(_bookNumChaptersController.text) ?? 0;
      _book.summary = _bookSummaryController.text;

      _bookService.updateBook(_book);
      Navigator.pop(context);

      // Exibir mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Livro atualizado com sucesso!')),
      );
    }
  }

  // Método para limpar os campos com confirmação
  void _onClear() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('Deseja realmente limpar todos os campos?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _bookTitleController.clear();
                _bookNumChaptersController.clear();
                _bookNumPagesController.clear();
                _bookSummaryController.clear();
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: const Text('Limpar'),
            ),
          ],
        );
      },
    );
  }
}
