Use Flex Builder 4.6.LS10


Debugging in FDT or Flash Builder

selecting the "Run -> Debug Configurations..." menu item, or clicking the down arrow to the right of the "Debug" toolbar button and selecting "Debug Configurations..." In this screen, you should right-click on the configuration of the application of note, and select "Duplicate." The duplicated item will appear with a name like, "SampleApplication (1)." Select this debug profile in the tree, and then change the "URL or path to launch" configuration as follows:

Untick the "Use default" checkbox.
Enter "about:blank" as the URL.
Save your configuration by clicking the "Close" button, or launch it by clicking the "Debug" button.

The idea here is that when you launch this new debug profile, the browser associated with FlashBuilder will not open a page containing the Flex application, and thus a debug connection will not be established. However, FlashBuilder will still open up a debug listening service that will wait a short time before terminating. During this time, it is possible to manually load the application to be tested. As the application loads, it should connect to the debug session waiting within FlashBuilder, permitting the usual debug operation.

From: http://enterprisingflex.blogspot.com/2011/07/remote-debugging-in-flashbuilder.html










