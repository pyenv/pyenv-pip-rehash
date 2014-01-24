# pyenv-pip-rehash

[![Build Status](https://travis-ci.org/yyuu/pyenv-pip-rehash.png)](https://travis-ci.org/yyuu/pyenv-pip-rehash)

**Never run `pyenv rehash` again.** This pyenv plugin automatically
runs `pyenv rehash` every time you install or uninstall packages with using `pip`.

## Installation

Make sure you have pyenv 0.2.0 or later, then run:

    git clone https://github.com/yyuu/pyenv-pip-rehash.git ~/.pyenv/plugins/pyenv-pip-rehash

## Usage

1. `pip install` a pip that provides executables.
2. Marvel at how you no longer need to type `pyenv rehash`.

## How It Works

pyenv-pip-rehash hooks every invokation of `pip` commands via `pyenv`.
If the first argument for `pip` is `install` or `uninstall`, it invokes `pyenv rehash` automatically.

## History

**0.0.3** (Jan 22, 2014)

* Rewrite with using `exec` hook of `pyenv`
* Support `easy_install` in addition to `pip`
* Add tests

**0.0.2** (Jun 14, 2013)

* Surely remove `${PIP_SHIM_PATH}` on exit

**0.0.1** (May 13, 2013)

* Initial public release.

## License

(The MIT License)

Copyright (c) 2013 Yamashita, Yuu <<yamashita@geishatokyo.com>>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINpipENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
