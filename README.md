vital-Vim-Prompt
==============================================================================
[![Travis CI](https://img.shields.io/travis/lambdalisue/vital-Vim-Prompt/master.svg?style=flat-square&label=Travis%20CI)](https://travis-ci.org/lambdalisue/vital-Vim-Prompt) [![AppVeyor](https://img.shields.io/appveyor/ci/lambdalisue/vital-Vim-Prompt/master.svg?style=flat-square&label=AppVeyor)](https://ci.appveyor.com/project/lambdalisue/vital-Vim-Prompt/branch/master) ![Version 1.0.0](https://img.shields.io/badge/version-1.0.0-yellow.svg?style=flat-square) ![Support Vim 7.3 or above](https://img.shields.io/badge/support-Vim%207.3%20or%20above-yellowgreen.svg?style=flat-square) [![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE) [![Doc](https://img.shields.io/badge/doc-%3Ah%20vital--Vim--Prompt-orange.svg?style=flat-square)](doc/vital-vim-prompt.txt)


Introductions
-------------------------------------------------------------------------------

Install
-------------------------------------------------------------------------------

```vim
NeoBundle 'lambdalisue/vital-Vim-Prompt'
```

And call the following to bundle this plugin

```vim
:Vitalize . +Vim.Prompt
```

Usage
-------------------------------------------------------------------------------

```vim
let s:Prompt = vital#vital#import('Vim.Prompt')
if s:Prompt.ask('Do you like Vim?')
    call s:Prompt.echo('Title', 'I knew')
else
    call s:Prompt.error('What did you say?')
endif
```


License
-------------------------------------------------------------------------------
The MIT License (MIT)

Copyright (c) 2016 Alisue, hashnote.net

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

