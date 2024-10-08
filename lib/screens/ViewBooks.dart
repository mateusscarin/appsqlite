import 'package:appsqlite/model/Book.dart';
import 'package:flutter/material.dart';

class ViewBook extends StatefulWidget {
  final Book book;

  const ViewBook({super.key, required this.book});

  @override
  State<ViewBook> createState() => _ViewBookState();
}

class _ViewBookState extends State<ViewBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Livro"),
        backgroundColor: Colors.red, // Cor harmonizada com a paleta de cores da aplicação
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Informações do Livro",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red, // Cor em destaque
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 20),
            
            // Exibindo o título do livro
            Row(
              children: [
                const Icon(Icons.book, color: Colors.teal), // Ícone de livro
                const SizedBox(width: 10),
                const Text(
                  'Título:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded( // Expande para ocupar o espaço restante
                  child: Text(
                    widget.book.title ?? '',
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis, // Elipse se o texto for muito longo
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Exibindo o número de páginas
            Row(
              children: [
                const Icon(Icons.menu_book, color: Colors.teal), // Ícone de capítulos
                const SizedBox(width: 10),
                const Text(
                  'Capítulos:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${widget.book.numChapters ?? '0'}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Exibindo o número de páginas
            Row(
              children: [
                const Icon(Icons.library_books, color: Colors.teal), // Ícone de páginas
                const SizedBox(width: 10),
                const Text(
                  'Páginas:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${widget.book.numPages ?? '0'} páginas',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Exibindo o resumo
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resumo:',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.book.summary ?? 'Sem resumo disponível.',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
