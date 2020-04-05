@IsTest
public with sharing class TestUtility {
    public static User createUserWithNoAccess() {
        return createUserWithNoAccess(USER_ALIAS_DEFAULT_NO_ACCESS);
    }

    public static User createUserWithNoAccess(String alias) {
        Id profileId = getProfileId(PROFILE_NAME_NO_ACCESS);
        User user = new User(
            FirstName = 'First',
            LastName = 'Last',
            Email = 'ajm-th-testutility@mailinator.com',
            Username = 'ajm-th-testutility@mailinator.com',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            ProfileId = profileId,
            Alias = alias
        );

        insert user;
        return user;
    }

    public static Id getProfileId(String profileName) {
        Profile profile = [
            SELECT
                Id
            FROM
                Profile
            WHERE
                Name = :profileName
            LIMIT 1
        ];

        return profile.Id;
    }

    public static final String
        USER_ALIAS_DEFAULT_NO_ACCESS = 'noaccess',
        PROFILE_NAME_NO_ACCESS = 'No Access';
}
