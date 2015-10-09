# RandomUser
Create a table with list of users parsed from randomuser.me and add selected users to the Contacts (iOS 9.0)


This is a test project in Swift to try the new Contacts framework that was introduced in iOS 9

Data with user Info are coming from https://randomuser.me/api/
Then you can select users ad add them to Contacts

Compile and run it in simulator
When table with users is populated select one or more users and press Save button
(don’t forget to allow the access to the Contacts when prompted, if you forgot just reset the simulator)
If user is saved it will be marked with (Saved) after the name
To find the added users in the Contacts press Cmd-Shift-H and open the Contacts app

To get new list of users press “Refresh button”

Nice to implement features:

1. Create a custom cell instead of one of default types
2. Add possibility to specify how many users need to be retrieved from the server
in Config screen and save this to the Users Preferences
3. Add more test cases

Make it better:

1. Use constants instead of String values
2. Make string localizable
3. Handle the images better (balance between storing in memory and accessing the web)
4. Check for memory leaks

