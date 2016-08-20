![banner](Resources/Banner.png)

WhatColorIsIt
=============

A simple screen saver that displays the current time. The background color is the current time converted into a hex string. Based off of [WhatColorIsIt](http://whatcolourisit.scn9a.org). 

The screen saver package can be downloaded from the [releases page](https://github.com/Marxon13/WhatColorIsIt/releases). The release also contains an app that is a demo of the screen saver (Open the app preferences to play with the screen saver configuration.)

##Table of Contents

* [**Recent Changes**](#recent-changes)
* [**Documentation**](#documentation) 
* [**Getting Started**](#getting-started)
    * [Installation](#installation)
    * [Use](#use)
* [**Project Structure**](project-structure)
* [**Project Details**](project-details)
    * [Requirements](requirements)
    * [Support](support)
    * [Todo](todo)
    * [License](license)

##Recent Changes

- **1.0.0:** The screen saver has been converted to Swift 3.
    - **Added:** 
        - New image resources.


##Documentation

The screen saver has a few configurable properties.

- **Main Label:** How the main label should display the time.
    - **Hex:** Display the time has a hex string (#235959).
    - **Time:** Display the time in the standard format (23:59:59)
    - **None:** Do not display the main label.

- **Secondary Label:** How the secondary label should display the time.
    - **Hex:** Display the time has a hex string (#235959).
    - **Time:** Display the time in the standard format (23:59:59)
    - **None:** Do not display the secondary label.

- **Inverted:** Whether to set the color to the text instead of the background.

##Getting Started

### Installation

Simply download the latest release from the [releases page](https://github.com/Marxon13/WhatColorIsIt/releases), unzip the download, and double click the "WhatColorIsIt.saver" file to install it.

### Use

To set and configure the screen saver, open `System Preferences` and navigate to the `Desktop & Screen Saver` page. In the left hand column, select the `What Color Is It?` screen saver to set it as the screen saver for the display. 

To configure the screen saver, press the `Screen Saver Options` button to open the configuration panel. Press `OK` to save the changes.

##Project Structure

**What Color Is It**

This is the target that builds the screen saver. The screen saver has three components:
    
- **WhatColorIsItView:** The view that renders the screen saver.
- **WhatColorIsItDefaults:** Stores the configuration of the screen saver and saves changes to disk.
- **WhatColorIsItConfigurationWindowController:** Controls the configuration window. Tying the controls to the default configuration.

**What Color Is It Demo**

A simple macOS app to help with debugging the screen saver. It simply displays the screen saver and its configuration view. The configuration view can be shown by opening the app preferences (Command + Comma).

##Project Details

### Requirements

- Runs on macOS El Capitan (10.11) or later.
- Requires Xcode 8 / Swift 3.0 to build

### Support

Open an issue or shoot me an email. Check out previous issues to see if your's has already been solved. (I would prefer an issue over an email. But will still happily respond to an email.)

### Todo

- I have no ideas, open an issue if you have one.

------

>Copyright (c) 2016 Brandon McQuilkin

>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.