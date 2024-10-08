import 'package:appsqlite/db_helper/repository.dart';
import 'package:appsqlite/model/Book.dart';

class BookService {
  final String referenceTable = 'tb_books';

  late Repository _repository;
  BookService() {
    _repository = Repository();
  }
  //Save Book
  saveBook(Book book) async {
    return await _repository.insertData(referenceTable, book.bookMap());
  }

  //Read All Books
  readAllBooks() async {
    return await _repository.readData(referenceTable);
  }

  //Edit Book
  updateBook(Book book) async {
    return await _repository.updateData(referenceTable, book.bookMap());
  }

  deleteBook(bookId) async {
    return await _repository.deleteDataById(referenceTable, bookId);
  }
}
