import 'package:flutter/material.dart';

class Salon {
  String email;
  String password;
  String name;
  String phone;
  String id, openTime, closeTime;
  String address, city, googlemaps, picture;
  Salon(
    this.email,
    this.password,
    this.id,
    this.name,
    this.phone,
    this.address,
    this.city,
    this.googlemaps,
    this.picture,
    this.openTime,
    this.closeTime,
  );

}