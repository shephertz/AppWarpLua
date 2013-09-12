AppWarpLua
==========

Lua SDK files for AppWarp and Corona application samples.

**Prerequisites**

* Follow [these steps](http://appwarp.shephertz.com/game-development-center/Using-AppHQ/) and get your key pair and a room id.
* Copy the AppWarp folder from the latest version and put it in the Sample's folder that you want to run.
* Load the Sample in Corona Simulator

Following samples are provided

**Chat**

* This illustrates simple chat room operations. 
* Users connect and join with a random name generate from os.clock()
* We then join the room created from AppHq console and subscribe to it
* Upon success, move to the next scene where they can exchange some fixed messages using the chat apis
* Using Corona native keyboard samples, developers can allow users to type in messages. This is not included in this sample.

**ColorMove**

* This illustrates moving of vectors in real time. Users can drag vectors to update their locations on other users screens.
* Users connect and join with a random name generate from os.clock()
* We then join the room created from AppHq console and subscribe to it
* We then use the updatePeers apis to send the changes made to vector positions and make them reflect on all users screens.
