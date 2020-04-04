trigger ContentDocumentTrigger on ContentDocument (after insert, after update) {
    List<Id> documentIds = new List<Id>();
    for (ContentDocument att : trigger.new) {
        documentIds.add(att.Id);
    }
    
    List<ContentDocumentLink> documentLinks = [
        SELECT 
        	LinkedEntityId, 
        	ContentDocumentId, 
        	LinkedEntity.Type 
        FROM 
        	ContentDocumentLink 
        WHERE 
            ContentDocumentId IN :documentIds];

    Map<Id, Id> managerNoteIdToDocumentId = new Map<Id, Id>();
    for (ContentDocumentLink documentLink : documentLinks) {
        if (documentLink.LinkedEntity.Type != 'Manager_Note__c') {
            continue;
        }

        managerNoteIdToDocumentId.put(documentLink.LinkedEntityId, documentLink.ContentDocumentId);
    }

    List<ContentVersion> contentVersions = [
        SELECT
            Id,
            IsLatest,
            ContentDocument.Title
        FROM
            ContentVersion
        WHERE
            ContentDocumentId IN :documentIds
    ];

    List<Id> contentVersionIds = new List<Id>();
    Map<Id, ContentVersion> documentIdsToVersions = new Map<Id, ContentVersion>();
    for(ContentVersion contentVersion : contentVersions) {
        if (!contentVersion.IsLatest) {
            continue;
        }
        
        contentVersionIds.add(contentVersion.Id);
        documentIdsToVersions.put(contentVersion.ContentDocumentId, contentVersion);
    }

    if (contentVersions.size() == 0) {
        return;
    }

    List<ContentDistribution> contentDistributions = [
        SELECT
            ContentDocumentId,
            ContentDownloadUrl,
            ContentVersionId
        FROM
            ContentDistribution
        WHERE
            ContentVersionId IN :contentVersionIds
    ];

    Map<Id, ContentDistribution> documentsToDistributions = new Map<Id, ContentDistribution>();
    for (ContentDistribution contentDistribution : contentDistributions) {
        if (documentsToDistributions.containsKey(contentDistribution.ContentDocumentId)) {
            continue;
        }

        documentsToDistributions.put(contentDistribution.ContentDocumentId, contentDistribution);
    }

    List<ContentDistribution> distributionsToAdd = new List<ContentDistribution>();

    for (Id documentId : documentIds) {
        if (documentsToDistributions.containsKey(documentId)) {
            // A ContentDistribution exists for this document so don't need to create one
            continue;
        }

        ContentVersion version = documentIdsToVersions.get(documentId);
        ContentDistribution distribution = new ContentDistribution(
            Name = version.ContentDocument.Title,
            ContentVersionid = version.Id,
            PreferencesAllowViewInBrowser = true,
            PreferencesLinkLatestVersion = true,
            PreferencesNotifyOnVisit = false,
            PreferencesPasswordRequired = false,
            PreferencesAllowOriginalDownload = true
        );

        distributionsToAdd.add(distribution);
    }

    if (distributionsToAdd.size() > 0) {
        insert distributionsToAdd;
        List<Id> distributionIdsAdded = new List<Id>();
        for (ContentDistribution distribution : distributionsToAdd) {
            distributionIdsAdded.add(distribution.Id);
        }

        List<ContentDistribution> contentDistributionsAdded = [
            SELECT
                Id,
                ContentDocumentId,
                ContentDownloadUrl,
                ContentVersionId
            FROM
                ContentDistribution
            WHERE
                Id IN :distributionIdsAdded];
        contentDistributions.addAll(contentDistributionsAdded);
    }
    
    if (contentDistributions.size() == 0) {
        return;
    }

    Map<Id, String> managerNotesToLinks = new Map<Id, String>();
    for (ContentDistribution distribution : contentDistributions) {
        managerNotesToLinks.put(distribution.ContentDocumentId, distribution.ContentDownloadUrl);
    }
    
    List<Manager_Note__c> managerNotes = [SELECT Id, Attachment_Links__c FROM Manager_Note__c WHERE Id IN :managerNoteIdToDocumentId.keySet()];
    List<Manager_Note__c> notesToUpdate = new List<Manager_Note__c>();

    for (Manager_Note__c managerNote : managerNotes) {
        Id documentId = managerNoteIdToDocumentId.get(managerNote.Id);
        String link = managerNotesToLinks.get(documentId);
        if (String.isBlank(link)) {
            continue;
        }
        
        if (!String.isBlank(managerNote.Attachment_Links__c)) {
            managerNote.Attachment_Links__c += '<br />';
        } else {
            managerNote.Attachment_Links__c = '';
        }

        managerNote.Attachment_Links__c += link;
        notesToUpdate.add(managerNote);
    }
    
    update notesToUpdate;
}