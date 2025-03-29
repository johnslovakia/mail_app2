class Mail {

  final String senderAddress, senderName, subject, text;
  final DateTime date;
  final bool read;


  const Mail(this.senderAddress, this.senderName, this.subject, this.text,
      this.date, this.read);
}