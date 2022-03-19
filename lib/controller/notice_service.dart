import 'dart:convert';
import 'package:fluttercrud/Models/apiResponse.dart';
import 'package:fluttercrud/Models/createNote.dart';
import 'package:fluttercrud/Models/note.dart';
import 'package:fluttercrud/Models/note_for_listing.dart';
import 'package:http/http.dart' as http;

class NoticeServices{

    String baseUrl = "http://tq-notes-api-jkrgrdggbq-el.a.run.app";

    // retrive data list

    Future <ApiResponse<List<NoteForListing>>> getNoticeList() async{
      final url = Uri.parse(baseUrl + "/notes");

      final headers = { "apiKey": "0f12c60b-f8ac-4aa2-aec7-8e4da101ebd1"};

      final response = await http.get(
       url,
       headers: headers
      );
       if(response.statusCode == 200 ){
         final jsonData = jsonDecode(response.body);
         final notes = <NoteForListing> [];
         for(var item in jsonData ){
           notes.add(NoteForListing.fromJson(item));
         }
         return ApiResponse<List<NoteForListing>>(data: notes);
       }
      return ApiResponse<List<NoteForListing>>(error:true,errorMessage: "An error occurred");
    }

      // Retrived notes on textField
    Future <ApiResponse<Note>> getNote(String noteID)async{

        final url = Uri.parse(baseUrl + "/notes/" + noteID );

        final headers = { "apiKey": "0f12c60b-f8ac-4aa2-aec7-8e4da101ebd1"};

        final response = await http.get(
          url,
          headers: headers
        );

        if(response.statusCode == 200){
          final jsonData = jsonDecode(response.body);
           return ApiResponse<Note>(data: Note.fromJson(jsonData));
        }
        return ApiResponse<Note>(error: true,errorMessage: "An error occured");

    }


    // Create note POST
    Future <ApiResponse<bool>> createNote(NoteInsert item ) async{

      final url = Uri.parse(baseUrl + "/notes");

      final headers = {"apiKey": "0f12c60b-f8ac-4aa2-aec7-8e4da101ebd1",
        'Content-Type': 'application/json'
      };
      final jsonBody = jsonEncode(item);

      final response = await http.post(
          url,
        headers: headers,
        body: jsonBody
      );
      if(response.statusCode == 200 || response.statusCode == 201){
          return ApiResponse<bool>(data:  true);
      }
      return ApiResponse<bool>(error: true,errorMessage: "An error Occurred");
    }


      // UpdateNote
    Future<ApiResponse<bool>> updateNote(NoteInsert item, String noteID)async{
      final url = Uri.parse(baseUrl + "/notes" + noteID);
     final headers = {"apiKey": "0f12c60b-f8ac-4aa2-aec7-8e4da101ebd1",
        'Content-Type': 'application/json'
      };
     final jsonBody = jsonEncode(item);

     final response = await http.put(url,
     headers: headers,
     body: jsonBody
     );
     if(response.statusCode == 200 || response.statusCode == 204){
       return ApiResponse<bool>(data:  true);
     }
      return ApiResponse<bool>(error: true,errorMessage: "An error occurred");
    }

    // DeleteNote
    Future<ApiResponse<bool>> deleteNote(String noteID)async{
      final url = Uri.parse(baseUrl + "/notes/" + noteID);
      final headers = {"apiKey": "0f12c60b-f8ac-4aa2-aec7-8e4da101ebd1",
        'Content-Type': 'application/json'
      };
      final response = await http.delete(url,
      headers: headers);
      if(response.statusCode == 200 || response.statusCode == 204){
        return ApiResponse<bool>(data: true);
      }
      return ApiResponse<bool>(error: true,errorMessage:  "An error occurred");
    }
}