class TicketType {
  final String code; // e.g. REG*
  final String label; // e.g. "1x REG**, 1x Free Bottle Drinking Water 500ml"
  final double price;

  const TicketType({
    required this.code,
    required this.label,
    required this.price,
  });
}

enum SeatStatus { available, selected, unavailable }

class Seat {
  final String id; // e.g. A1
  final String row;
  final int number;
  SeatStatus status;

  Seat({
    required this.id,
    required this.row,
    required this.number,
    this.status = SeatStatus.available,
  });
}

enum PaymentMethod { card, gcash, grabpay }
