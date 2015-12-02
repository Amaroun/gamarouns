# README #

### What is this repository for? ###

**This repository is a Gentoo layman overlay called *gamarouns* **

More about *Gentoo*: https://gentoo.org

Now, *Gentoo* package system is called *portage*: https://wiki.gentoo.org/wiki/Portage

Portage package system uses *overlays*, a data storages containig files describing packages: https://wiki.gentoo.org/wiki/Overlay

To maintain overlays, a tool called *layman* is used: https://wiki.gentoo.org/wiki/Layman

So this repository is a layman overlay.

### How do I get set up? ###

First, setup a portage and a layman (getting a Gentoo instalation and installing layman by portage(part of the distro) is most common way)

Then you can either fetch overlays through official references:

```
#!bash

 layman -L

```
and then add gamarouns overlay

```
#!bash

 layman -a gamarouns

```

or you can install overaly directly by url:

```
#!bash

 layman -o https://bitbucket.org/amaroun/gamarouns/raw/default/amarouns_repos.xml -f -a gamarouns

```


### Contribution guidelines ###

I have no immediate plans for other contributors at the moment, you may contact me if you would get some proposal.

### Who do I talk to? ###

Repo owner