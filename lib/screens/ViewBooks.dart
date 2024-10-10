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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Informações do Livro",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 20),
            
            InfoRow(
              icon: Icons.book,
              label: 'Título:',
              value: widget.book.title ?? 'Sem título',
            ),
            const SizedBox(height: 20),
            
            InfoRow(
              icon: Icons.menu_book,
              label: 'Capítulos:',
              value: '${widget.book.numChapters ?? 0}',
            ),
            const SizedBox(height: 20),
            
            InfoRow(
              icon: Icons.library_books,
              label: 'Páginas:',
              value: '${widget.book.numPages ?? 0} páginas',
            ),
            const SizedBox(height: 20),
            
            const Text(
              'Resumo:',
              style: TextStyle(
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
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
