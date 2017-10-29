# XBookmark
Bookmark Plugin for Xcode 

# Compatibility

Xcode 8.x and Xcode 7.x

# Screenshot

![xbookmark](http://i.imgur.com/IoSw0Iz.png)


# Feature
- Toggle Bookmark
- Show Bookmarks
- Next Bookmark
- Previous Bookmark

# Install

  Xcode 8 Users, Follow instructions in [INSTALL_Xcode8.md](INSTALL_Xcode8.md) first.
  
  Download source code or clone the repo. Then,
  
  1. Confirm `xcode-select` points to your Xcode
  ```bash
  $ xcode-select -p
  /Applications/Xcode.app/Contents/Developer
  ```
  
  If this doesn't show your Xcode application path, use `xcode-select -s` to set.
  
  2. make
  ```bash
  $ make
  ```

  If you see something like 
  
  ```
  XBookmark hasn't confirmed the compatibility with your Xcode, Version X.X
  Do you want to compile XBookmark with support Xcode Version X.X at your own risk? 
  ```
  Press y if you want to use XBookmark with your Xcode version (even it is not confirmed it works)
  
  3. Restart your Xcode. 

  4. Launch Xcode. You'll be asked if you load XBookmark. Press 'Yes' to it.
     If you press 'No' by mistake, close the Xcode and execute the following from a terminal

  ```
    defaults delete  com.apple.dt.Xcode DVTPlugInManagerNonApplePlugIns-Xcode-X.X     (X.X is your Xcode version)
  ```
    
  Then relaunch Xcode.

Now, you can see `XBookmark` menus in the `Edit` Menu. Press `F3` in source editor , and you will see the `STAR`.

# Usage
**Shortcuts configurable**
- type `F3` to toggle bookmarks.
- type `Shift + F3` to display bookmark list.
- type `Command + F3` to jump to next bookmark.
- type `Ctrl + Shift + F3` to jump to previous bookmark.
- type `Command + Shift + F3` to clear bookmarks.



# Thanks for
- XToDo
- JumpMarks

# History Versions

- 2017-03-28 1.1 Xcode8.3 Support
- 2016-12-29 1.0 Add Xcode8 Support
- 2016-07-14 0.4 Add shortcut for clear bookmarks
- 2015-10-31 0.3 
    1. Shortcut configurable.
    2. Star flag in sidebar of code editor.
- 2015-10-26 0.2 Fix problem (main for slow locating).
- 2015-10-06 0.1 First Release (just working).
