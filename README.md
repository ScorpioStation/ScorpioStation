# Scorpio Station
[Website](https://scorpiostation.com/) - [Code](https://github.com/ScorpioStation/ScorpioStation) - [Discord](https://scorpiostation.com/discord)

---

### GETTING THE CODE
The simplest way to obtain the code is using the GitHub .zip feature.

Click [here](https://github.com/ScorpioStation/ScorpioStation/archive/master.zip) to get the latest code as a .zip file, then unzip it to wherever you want.

The more complicated and easier to update method is using git.  
You'll need to download git or some client from [here](http://git-scm.com/).  
When that's installed, right click in any folder and click on "Git Bash".  
When that opens, type in:

    git clone https://github.com/ScorpioStation/ScorpioStation

(hint: hold down ctrl and press insert to paste into git bash)

This will take a while to download, but it provides an easier method for updating.

### INSTALLATION
First-time installation should be fairly straightforward.  
First, you'll need to install [BYOND](https://secure.byond.com/download/).

Second, you'll need to install [Docker Desktop](https://www.docker.com/get-started).
(Ask on Discord if you need help.)

This is a sourcecode-only release, so the next steps are to compile the server files.

Third, there are some dependencies not included in the source tree. The pros
like to build these things for themselves, but we're going to cheat for now
and just take the latest copies that somebody else built.

Open up the folder where the code is kept, and run the script called
`prepare-dev-windows.bat`

Fourth, open `paradise.dme` by double-clicking it, open the Build menu, and
click compile.  

This'll take a little while, and if everything's done right,
you'll get a message like this:

    saving paradise.dmb (DEBUG mode)

    paradise.dmb - 0 errors, 0 warnings

If you see any errors or warnings, something has gone wrong - possibly a
corrupt download, the files extracted wrong, or the script didn't get those
extra dependencies. Ask on #coding-talk on the [Discord](https://scorpiostation.com/discord).

Once that's done, open up the `config` folder.  

Inside the config folder is another `example` folder. Copy all of the text files
from that folder to the `config` folder.

You'll want to edit `config.txt` to set your server location,
so that all your players don't get disconnected at the end of each round.

It's recommended you don't turn on the gamemodes with probability 0,
as they have various issues and aren't currently being tested,
so they may have unknown and bizarre bugs.

You'll also want to edit `admins.txt` to remove the default admins and add your
own. "Hosting Provider" is the highest level of access, and the other
recommended admin levels for now are "Game Admin" and "Mentor". The format is:

    byondkey - Rank

where the BYOND key must be in lowercase and the admin rank must be properly capitalized.  
There are a bunch more admin ranks, but these two should be enough for most servers,
assuming you have trustworthy admins.

Finally, to start the server,
run Dream Daemon and enter the path to your compiled `paradise.dmb` file.  
Make sure to set the port to the one you specified in the `config.txt`,
and set the Security box to 'Trusted'.  
Then press GO and the server should start up and be ready to join.

---

### UPDATING
To update an existing installation, first back up your /config and /data folders
as these store your server configuration, player preferences and banlist.

If you used the zip method,
you'll need to download the zip file again and unzip it somewhere else,
and then copy the /config and /data folders over.

If you used the git method, you simply need to type this in to git bash:

    git pull

When this completes, copy over your /data and /config folders again, just in case.

When you have done this, you'll need to recompile the code, but then it should work fine.

---

### Configuration
For a basic setup, simply copy every file from config/example to config.

---

### SQL Setup
The SQL backend for the library and stats tracking requires a MySQL server.

Your database details go in `config/dbconfig.txt`,
and the SQL schema is in `SQL/scorpio/scorpio_schema.sql`.

More detailed setup instructions are located on our wiki:
https://scorpiostation.com/wiki/index.php/Setting_up_the_Database

---

### LICENSE
ScorpioStation is licensed under the GNU Affero General Public License version 3.

If you host a server using *any* code licensed under the GNU Affero General
Public License, you are required to provide full source code for your servers
users as well, including add-ons and modifications you have made.

As of 5th January 2015, all new contributions are licensed under the GNU Affero
General Public License. If you wish to submit code under the GPL v3 then commits
and files must be marked as such in comments.

If you wish to use our code in a closed source manner you may use anything
before commit 445615b8439bf606ff204a42c8e7b6b69d983255, which is licensed
under GPL v3.

See [this](https://www.gnu.org/licenses/why-affero-gpl.html) for more information.

Any files located in the
`ScorpioStation/goon`,
`ScorpioStation/icons/goonstation`, or
`ScorpioStation/sound/goonstation`
directories, or any subdirectories of the listed directories, are licensed
under the Creative Commons 3.0 BY-NC-SA license
(https://creativecommons.org/licenses/by-nc-sa/3.0)

All other assets including icons and sound files are licensed under the
Creative Commons 3.0 BY-SA license (https://creativecommons.org/licenses/by-sa/3.0/),
unless otherwise indicated.
