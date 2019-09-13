class Coupon {
  List<int> earnedTickets;
  List<TicketMapping> ticketMapping;

  Coupon({this.earnedTickets, this.ticketMapping});

  Coupon.fromJson(Map<String, dynamic> json) {
    earnedTickets = json['earnedTickets'].cast<int>();
    if (json['ticketMapping'] != null) {
      ticketMapping = new List<TicketMapping>();
      json['ticketMapping'].forEach((v) {
        ticketMapping.add(new TicketMapping.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['earnedTickets'] = this.earnedTickets;
    if (this.ticketMapping != null) {
      data['ticketMapping'] =
          this.ticketMapping.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TicketMapping {
  int ticketNo;
  String assignDate;
  String assignDateStr;
  TicketMapping({this.ticketNo, this.assignDate});

  TicketMapping.fromJson(Map<String, dynamic> json) {
    ticketNo = json['ticketNo'];
    assignDate = json['assignDate'];
    assignDateStr = json['assignDateStr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticketNo'] = this.ticketNo;
    data['assignDate'] = this.assignDate;
    data['assignDateStr'] = this.assignDateStr;
    return data;
  }
}
