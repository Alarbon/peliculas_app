// To parse this JSON data, do
//
//     final actorResponse = actorResponseFromJson(jsonString);

import 'dart:convert';

class ActorResponse {
  ActorResponse({
    this.adult,
    this.alsoKnownAs,
    this.biography,
    this.birthday,
    this.gender,
    this.homepage,
    this.id,
    this.imdbId,
    this.knownForDepartment,
    this.name,
    this.placeOfBirth,
    this.popularity,
    this.profilePath,
  });

  bool? adult;
  List<String>? alsoKnownAs;
  String? biography;
  DateTime? birthday;

  int? gender;
  dynamic homepage;
  int? id;
  String? imdbId;
  String? knownForDepartment;
  String? name;
  String? placeOfBirth;
  double? popularity;
  String? profilePath;

  factory ActorResponse.fromRawJson(String str) =>
      ActorResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  get fullprofilePath {
    if (this.profilePath != null)
      return 'https://image.tmdb.org/t/p/w500${this.profilePath}';

    return 'https://i.stack.imgur.com/GNhx0.png';
  }

  get getBibliography {
    if (this.biography == null || this.biography == "") {
      return 'Sin biografía disponible';
    }
    return biography!;
  }

  get birthdayFormated {
    if (birthday == null) {
      return 'Sin fecha de nacimiento';
    }
    return '${birthday!.day}/${birthday!.month}/${this.birthday!.year}';
  }

  factory ActorResponse.fromJson(Map<String, dynamic> json) => ActorResponse(
        adult: json["adult"],
        alsoKnownAs: json["also_known_as"] == null
            ? []
            : List<String>.from(json["also_known_as"]!.map((x) => x)),
        biography: json["biography"],
        birthday:
            json["birthday"] == null ? null : DateTime.parse(json["birthday"]),
        gender: json["gender"],
        homepage: json["homepage"],
        id: json["id"],
        imdbId: json["imdb_id"],
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        placeOfBirth: json["place_of_birth"],
        popularity: json["popularity"]?.toDouble(),
        profilePath: json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "also_known_as": alsoKnownAs == null
            ? []
            : List<dynamic>.from(alsoKnownAs!.map((x) => x)),
        "biography": biography,
        "birthday":
            "${birthday!.year.toString().padLeft(4, '0')}-${birthday!.month.toString().padLeft(2, '0')}-${birthday!.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "homepage": homepage,
        "id": id,
        "imdb_id": imdbId,
        "known_for_department": knownForDepartment,
        "name": name,
        "place_of_birth": placeOfBirth,
        "popularity": popularity,
        "profile_path": profilePath,
      };
}
