# Labirynt Tajemnic #
(pol. _The Labirynth of Mysteries_)

## Description ##

This is my first attempt at creating a video game which I made back in June 2007 as a final project for computer science class in junior high school.

For me, apart from having a purely sentimental value, it is also an interesting example of code written by someone without almost any experience in programming, but (too) great ambitions and no knowledge of limitations. The code, looking at it from a perspective of 11 years of programming, is really appalling/funny. See first commit for the unchanged, broken code from 2007. For example, a thing I now find most amusing, is the fact that I wasn't aware of the existence of functions in programming, so all the code uses just plain procedures with no arguments. This obviously leads to a great amount of repetition.

The project got to a stage where there was some gameplay, but then I introduced bugs which I wasn't able to fix. I have created this repository to achieve a closure - to finally complete a project I never finished. And to have something productive to work on when I'm procrastinating.
The first steps will be actually bringing the project to a working state, then refactor it to bring it to a more palatable shape, and finally to make it what it was supposed to be in the first place - a dungeon-crawler turn-based RPG with vector graphics. A working one, hopefully.


## Install & run ##

A Free Pascal compiler is required to compile the source code.

On Ubuntu, install `fpc` with

```
sudo apt-get install fpc
```
The original version depended on a BGI (Borland Graphics Interface)-compatible Pascal module called `graph`. This has now been replace with `ptcgraph` which is included in `fpc`

Next, compile and run the program:

```
fpc -o labirynt labirynt.pas

./labirynt
```

The initial committed version of the program doesn't really work properly. Some initial debugging is needed to bring the project to a working state.