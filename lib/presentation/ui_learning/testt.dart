
class BookAuthor{
  final int id;
  final String bokkName;
  final String author;

  BookAuthor({
    required this.id, required this.bokkName, required this.author
});


  factory BookAuthor.fromJson(Map<String, dynamic>json){
    return BookAuthor(
      id: json['id'],
      bokkName: json['bokkName'],
      author: json['author']
    );
  }

  Map<String, dynamic>toJson(){
    return{
      "id":id,
      "bokkName":bokkName,
      "author":author
    };
  }

}
void main(){
var author = BookAuthor(id: 1, bokkName: "Book one", author: "author one");
print(author.toJson());
BookAuthor bookAuthor = BookAuthor.fromJson(author.toJson());
print(bookAuthor.bokkName);
}