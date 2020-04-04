public with sharing class LeadProcessor implements Database.Batchable<sObject>, Database.Stateful {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, Name FROM Lead'
        );
    }

    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        List<Lead> leadsToUpdate = new List<Lead>();
        for (Lead thisLead : scope) {
            thisLead.LeadSource = 'Dreamforce';
            leadsToUpdate.add(thisLead);
        }

        update leadsToUpdate;
    }

    public void finish(Database.BatchableContext bc) {
        
    }
}