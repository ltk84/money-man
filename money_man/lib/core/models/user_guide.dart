class UserGuides {
  List<String> questions;
  List<String> answers;

  UserGuides() {
    questions = [
      "How to set periodical income/expense?",
      "What's budget? How to use budget?",
      "What's event? How it works?",
      "What's bill?",
      "Can i use multiple currency for only one wallet?",
      "How to update new password ?",
    ];

    answers = [
      'You can use "Recurring Transactions" function (under "Planning" section for Android version) in Navigation panel. Please be aware that the concept for recurring transaction is kinda similar to an automatic method to add repetitive transactions. You will only see the transactions in your wallet when it reaches the time you have anticipated in the setting of recurring transactions. Therefore, be patient when you add recurring transaction and have not seen it in the transaction list. Try setting the nearest time (about next 3-5 minutes) to see how the function works. To change the repeating mode, tap the "Repeat Daily" to see other options or anticipate the number of days that such transaction will repeat in the future in line "Every 1 day".',
      'Budget : a targeted limit for one specific wallet’s all categories or one specific category.',
      'Create an app event to track spending on a real event, like a weekend trip ',
      'Tracking your bil, such as electronic, tax, internet,.. You can make it in planning section',
      'Sorry, but you can not do this, our merchandise is one currency for one wallet',
      'By accessing Account tab in the bottom navigation bar, you should choose "My account", you will see the option "Change password" there!'
    ];
  }
}
