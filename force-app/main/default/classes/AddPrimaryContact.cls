public with sharing class AddPrimaryContact implements Queueable{
    private Contact contact;
    private String state;

    public AddPrimaryContact(Contact c, String state) {
        this.contact = c;
        this.state = state;
    }

    public void execute(QueueableContext context) {
        List<Account> accounts = [SELECT BillingState FROM Account WHERE BillingState = :this.state LIMIT :MAXIMUM_NUMBER_OF_ACCOUNTS];
        List<Contact> contacts = new List<Contact>();
        for (Account account : accounts) {
            Contact accountContact = this.contact.clone();
            accountContact.AccountId = account.Id;
            contacts.add(accountContact);
        }

        insert contacts;
    }

    public static final Integer MAXIMUM_NUMBER_OF_ACCOUNTS = 200;
}