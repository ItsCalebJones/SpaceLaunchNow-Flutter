class Launcher {
  final int id;
  final String details;
  final bool flightProven;
  final String serialNumber;
  final String status;
  final int previousFlights;

  Launcher(
      {this.id,
      this.details,
      this.flightProven,
      this.serialNumber,
      this.status,
      this.previousFlights});

  factory Launcher.fromJson(Map<String, dynamic> json) {
    return Launcher(
      id: json['id'],
      details: json['details'],
      flightProven: json['flight_proven'],
      serialNumber: json['serial_number'],
      status: json['status'],
      previousFlights: json['previous_flights']
    );
  }
}
