Unix/Mac: [![Unix Build Status](https://secure.travis-ci.org/JoshCheek/seeing_is_believing.png?branch=master)](http://travis-ci.org/JoshCheek/seeing_is_believing) &nbsp;&nbsp; Windows: [![Windows Build Status](https://ci.appveyor.com/api/projects/status/32r7s2skrgm9ubva?svg=true)](https://ci.appveyor.com/project/JoshCheek/seeing-is-believing)

Seeing Is Believing
===================

Evaluates Ruby code, recording the results of each line.
Integrates with any extensible editor (I've integrated it with many already, see [the list](https://github.com/JoshCheek/seeing_is_believing/wiki/Editor-Integration)).
If you like Swift Playgrounds, you'll like SiB.

![example](https://s3.amazonaws.com/josh.cheek/images/scratch/sib-example1.gif)


Helpful links
-------------

* [Install](https://github.com/JoshCheek/seeing_is_believing/wiki/Installation)
* [Integrate with your editor](https://github.com/JoshCheek/seeing_is_believing/wiki/Editor-Integration)
* [Use as a library](https://github.com/JoshCheek/seeing_is_believing/wiki/Library-example)
* [Use on the command line](https://github.com/JoshCheek/seeing_is_believing/wiki/Command-Line-Usage)
* [Pro Tips (useful patterns)](https://github.com/JoshCheek/seeing_is_believing/wiki/Pro-Tips)
* [Features](https://github.com/JoshCheek/seeing_is_believing/tree/master/features)
* [Potential Future Features](https://github.com/JoshCheek/seeing_is_believing/wiki/Potential-future-features)
* [Set up it up for development work](https://github.com/JoshCheek/seeing_is_believing/wiki/Setting-it-up-for-Development)


Examples
--------

* Watch a [longer video](http://vimeo.com/73866851).
* Watch John Cinnamond use it in a [presentation](http://brightonruby.com/2016/the-point-of-objects-john-cinnamond/)
  at the 10:22 minute mark.
* [Avdi](https://github.com/avdi) uses it in [Ruby Tapas](https://www.rubytapas.com/),
  an amazing resource for developers in general and Ruby Developers in particular!


Known Issues
------------

* Assumes utf-8 everywhere. If this is an issue, please see the [encodings](https://github.com/JoshCheek/seeing_is_believing/wiki/Encodings) section of the wiki.
* `begin; else; break; end` this code (an else without a rescue) will emit a warning in Ruby, and is omitted from `Parser`'s AST.
  As such, I doubt that anyone will ever write it. But if you were to write it, it would blow up, because SiB rewrites your code, wrapping every expression that could have a value.
  This code will be wrapped. But using the value is **syntactically** invalid in Ruby, because it constitutes a "void value expression" (aka a pointless time sink and the cause of many bugs in SiB).
  Unfortunately, I can't easily check it to see if it's void since it's not in the parsed AST.  But it's so edge that I don't think it's worth worrying about.


Inspiration
-----------

* [Xmpfilter](http://www.rubydoc.info/gems/rcodetools/0.8.5.0/Rcodetools/XMPFilter), which is a part of the [rcodetools gem](https://rubygems.org/gems/rcodetools).
* Bret Victor's completely inspiring talk [Inventing on Principle](https://www.youtube.com/watch?v=PUv66718DII).
* My 8th Light mentor, [Doug Bradbury](http://blog.8thlight.com/doug-bradbury/archive.html) who asked me to make it for his Kids Ruby sessions (I don't think we ever finished integrating it, though >.<)


Shout outs
----------

* Whitequark for all the work on [Parser](http://github.com/whitequark/parser/), which dramatically dramatically improved SiB (I used to have my own horribly shitty line-based parser)
* [Travis CI](https://travis-ci.org/JoshCheek/seeing_is_believing)... I love you times a million! So many difficult bugs have been caught by this.
  It's so easy to work with, astoundingly convenient, helps me guarantee that SiB works on everyone else's computers, too. And it's free since SiB is open source.
  I literally have a Travis CI sticker on my laptop, I love you that much.

License
-------

<a href="http://www.wtfpl.net/"><img src="http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl.svg" height="20" alt="WTFPL" /></a>

    Copyright (C) 2014 Josh Cheek <josh.cheek@gmail.com>

    This program is free software. It comes without any warranty,
    to the extent permitted by applicable law.
    You can redistribute it and/or modify it under the terms of the
    Do What The Fuck You Want To Public License,
    Version 2, as published by Sam Hocevar.
    See http://www.wtfpl.net/ for more details.
