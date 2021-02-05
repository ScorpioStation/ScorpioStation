# DOWNLOADING
This document contains all the relevant information for downloading and running your own ParaCode server.

## GETTING THE CODE
The simplest way to obtain the code is using the GitHub .zip feature.

Click [here](https://github.com/ScorpioStation/ScorpioStation/archive/master.zip) to get the latest code as a .zip file, then unzip it to wherever you want.

The more complicated and easier to update method is using git.  
You'll need to download git or some client from [here](http://git-scm.com/).  
When that's installed, right click in any folder and click on "Git Bash".  
When that opens, type in:

```sh
    git clone https://github.com/ScorpioStation/ScorpioStation
```

(Hint: Hold down Ctrl and press Insert to paste into git bash)

This will take a while to download (it is the entire repo + history, not just a snapshot), but it provides an easier method for updating.

## INSTALLATION
First-time installation should be fairly straightforward.  
First, you'll need to install [BYOND](https://secure.byond.com/download/).

Second, this repository repository contains source code, so the next steps
are to compile the server files.

There are some dependencies not included in the source tree. The pros
like to build these things for themselves, but we're going to cheat for now
and just take the latest copies that somebody else built.

Open up the folder where the code is kept, and run the script called
`prepare-dev-windows.bat`

Third, open `paradise.dme` by double-clicking it, open the Build menu, and
click compile.  

This'll take a little while, and if everything's done right,
you'll get a message like this:

```sh
    saving paradise.dmb (DEBUG mode)
    paradise.dmb - 0 errors, 0 warnings
```

If you see any errors or warnings, something has gone wrong - possibly a
corrupt download, the files extracted wrong, or the script didn't get those
extra dependencies. Ask on #coding-talk on the [Discord](https://scorpiostation.com/discord).

Once that's done, open up the `config` folder.  

Inside the `config` folder is another folder `example`. Copy all of the text files
from the `example` folder to the `config` folder.

You'll want to edit `config.txt` to set your server location,
so that all your players don't get disconnected at the end of each round.

It's recommended you don't turn on the gamemodes with probability 0,
as they have various issues and aren't currently being tested,
so they may have unknown and bizarre bugs.

You'll also want to edit `admins.txt` to remove the default admins and add your
own. "Hosting Provider" is the highest level of access, and the other
recommended admin levels for now are "Game Admin" and "Mentor". The format is:

```cfg
    byondkey - Rank
```

where the BYOND key must be in lowercase and the admin rank must be properly capitalized.  
There are a bunch more admin ranks, but these two should be enough for most servers,
assuming you have trustworthy admins.

Finally, to start the server,
run Dream Daemon and enter the path to your compiled `paradise.dmb` file.  
Make sure to set the port to the one you specified in the `config.txt`,
and set the Security box to 'Trusted'.  
Then press GO and the server should start up and be ready to join.

### Installation (Linux)
The code is fully able to run on Windows, however Linux is the recommended
platform. The code requires Docker, 2 libraries, and some additional
dependencies.

To use a SQL Database on a Debian-based Linux, run the following:
`sudo apt-get install libmariadb-dev:i386`

Another library rust-g can be installed by running a script from the root
of the project: `prepare-dev-linux.sh`

To install the dependencies needed by rust-g on a Debian-based Linux, run the
following:
`sudo apt-get install libssl-dev:i386 pkg-config:i386 zlib1g-dev:i386`.

If you have trouble, ask on #coding-talk on our [Discord](https://scorpiostation.com/discord).

### UPDATING
To update an existing installation, first back up your /config and /data folders
as these store your server configuration, player preferences and banlist.

If you used the zip method, you'll need to download the zip file again and
unzip it somewhere else, and then copy the /config and /data folders over.

If you used the git method, you simply need to type this in to git bash:

```sh
    git pull
```

When this completes, copy over your /data and /config folders again, just in case.

When you have done this, you'll need to recompile the code, but then it should work fine.

### SQL Setup
The SQL backend is required for storing character saves, preferences,
administrative data, and many other things. We recommend running a database
if your server is going to be used as more than just a local test server.

Your database details go in `config/dbconfig.txt`,
and the SQL schema is in `SQL/scorpio/scorpio_schema.sql`.

More detailed setup instructions are located on our wiki:
https://scorpiostation.com/wiki/index.php/Setting_up_the_Database
