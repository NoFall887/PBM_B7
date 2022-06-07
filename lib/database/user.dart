class CreateUser {
  final String nama;
  final String email;

  CreateUser({required this.nama, required this.email});

  static CreateUser fromJson(json) {
    return CreateUser(nama: json['nama'], email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {
      "nama": this.nama,
      "email": this.email,
    };
  }
}
