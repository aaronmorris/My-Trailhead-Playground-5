trigger UpdateAttachmentLink on Attachment (after insert, after update) {
    System.debug('>>> in UpdateAttachmentLink trigger');
    Map<Id, String> parentsToLinks = new Map<Id, String>();
    for (Attachment att : trigger.new) {
        System.debug('>>>' + Url.getOrgDomainUrl().toExternalForm());
        System.debug('>>>' + att);
        String link = Url.getOrgDomainUrl().toExternalForm() + '/' + att.Id;
        parentsToLinks.put(att.ParentId, link);
    }

    List<Manager_Note__c> managerNotes = [SELECT Id, Attachment_Links__c FROM Manager_Note__c WHERE Id IN :parentsToLinks.keySet()];
    System.debug('>>> managerNotes: ' + managerNotes);
    List<Manager_Note__c> notesToUpdate = new List<Manager_Note__c>();
    for (Manager_Note__c managerNote : managerNotes) {
        String link = parentsToLinks.get(managerNote.Id);
        if (String.isBlank(link)) {
            System.debug('>>> link is blank');
            continue;
        }
        
        if (!String.isBlank(managerNote.Attachment_Links__c)) {
            managerNote.Attachment_Links__c += '<br />';
        } else {
            managerNote.Attachment_Links__c = '';
        }
        
        System.debug('>>> adding notes');
        managerNote.Attachment_Links__c += link;
        notesToUpdate.add(managerNote);
    }
    
    update notesToUpdate;
}