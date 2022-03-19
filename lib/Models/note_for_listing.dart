class NoteForListing {
  String noteID;
  String noteTitle;
  DateTime  createDateTime;
  DateTime latestEditedDateTime;

  NoteForListing({
    this.noteID,
    this.noteTitle,
    this.createDateTime,
    this.latestEditedDateTime
});

  factory NoteForListing.fromJson(Map<String,dynamic> item){
     return NoteForListing(
       noteID:  item["noteID"],
       noteTitle: item["noteTitle"],
       createDateTime: DateTime.parse(item["createDateTime"]),
       latestEditedDateTime:item["latestEditedDateTime"] != null ? DateTime.parse(item["latestEditedDateTime"]) : null);
  }

}