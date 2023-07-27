[![hackmd-github-sync-badge](https://hackmd.io/qtds9NkrTHSKnrrh2_I64Q/badge)](https://hackmd.io/qtds9NkrTHSKnrrh2_I64Q)

## Section 1: Introduction to UNIX
----------------------------------

### Learning Goals
* visualize file/directory structures
* understand basic shell vocabulary
* gain exposure to the syntax of shell & shell scripting
* look at the contents of a directory 
* find features of commands with `--help`
* commands: `pwd`, `ls`, `cd`, `cat`, `rm`,`mkdir`, `rmdir`
------------------------------------

### What is the shell and what is the terminal?
The **shell** is a computer program that uses a command line interface (CLI) to give commands made by your keyboard to your operating system. Most people are used to interacting with a graphic user interface (GUI), where you can use a combination of your mouse and keyboard to carry out commands on your computer. We can use the shell through a **terminal** program. 

Everything we can do using our computer GUI, we can do in the shell. We can open programs, run analyses, create documents, delete files and create folders. We should note that _folders_ are called **directories** at the command line. For all intents and purposes they can be used interchangeably but if you'd like more information please see "The folder metaphor" section of [Wikipedia](https://en.wikipedia.org/wiki/Directory_%28computing%29#Folder_metaphor).

The ease of getting things done via the shell will increase with your exposure to the program.  

Let's open up a Terminal in the RStudioServer. In the left pane, click the `Terminal` tab.

![](https://hackmd.io/_uploads/r1livJwch.png)


When we open up terminal, we will see a line of text. This is a **prompt statement**. It can tell us useful things such as the name of the directory we are currently in, our username, or what computer we are currently running terminal on. The prompt statement here is quite long and distracting. Let's customize it to read `$ ` by running:

```
PS1='$ '
```

Then hit <kbd>Enter</kbd>. Better, right? (Well, shorter, at least!)

Let's take a look around. First, we can use the **print working directory** command see what directory we are currently located in.

```
pwd
```

This gives us the **absolute path** to the directory where we are located. An absolute path shows the complete series of directories you need to locate either a directory or a file starting from the root directory of your computer.

What is the root?
A useful way to start thinking about directories and files is through levels. At the highest level of your computer, you have the **root directory**. Everything that is contained in your computer is located in directories below your root directory. 


We can also look at the contents of the directory by using the `ls` command:

```
ls
```

This command prints out a list of files and directories that are located in our current working directory. We currently only have a folder called `R`, which contains information from our `R` and `RstudioServer` installation.

Let's download some files to play with! Instead of using the download / upload buttons on the RStudioServer, let's use the `Terminal`. Run the following code to download a zipped file and unzip it.

```
curl -JLO https://osf.io/f9uhm/download
unzip hannahs_unix_cafe.zip
```
> we'll go over the curl command for downloads a bit later

Now, if we look at the contents of our current directory we have added a file called `hannahs_unix_cafe.zip` and a directory called `hannahs_unix_cafe`.


To switch the directory we are located in, we need to change directories using the `cd` command. Let's move into the `hannahs_unix_cafe` directory. 

```
cd hannahs_unix_cafe
```

We can confirm that we have moved with the **print working directory** command, which shows what directory we are currently located in.

```
pwd
```

This gives us the **absolute path** to the directory where we are located. Again, an absolute path shows the complete series of directories you need to locate either a directory or a file starting from the root directory of your computer.

Let's have a look around.

```
ls
```
(`ls` stands for list. Or `list stuff`, if you prefer! :)


However, this directory contains more than the eye can see! To show hidden files we can use the `-a` option.

```
ls -a
```

What did you find? 


Using options with our commands allows us to do a lot! But how did we know to add `-a` after ls? Most commands offer a `--help`. Let's look at the available options that `ls` has:

```
ls --help
```

Here we see a long list of options. Each option will allow us to do something different.
> Future note: if `--help` doesn't work on your personal laptop, you can use the 'manual' instead: `man ls`. This manual should show the same information as `--help`, but will open a paged viewer where you can scroll up and down. Press `q` to exit that viewer.


##### Practice:
Find the date `unix_cafe.txt` was created with `ls -l`


We can also combine commands:

```
ls -lah
```

This combination of options will _list_ _all_ the contents of the directory, in _"long form"_ and display file sizes in _human readable_ units between files types. 

(what does  human readable units mean? compare `ls -lah` to `ls -la`)


## Navigation
  Now we have a fairly good concept of navigating around our computers and seeing what is located in the directory we are. But some of the beauty of the shell is that we can execute activities in locations that we are not currently in. To do this we can either use an absolute path or a relative path. A **relative path** is the path to another directory from the the one you are currently in. 

Again, check out the  `hannahs_unix_cafe` directory

```
ls
```

Here we see several directories and text files. We can see what is in the text file using the `cat` command which concatenates and prints the content of the file we list. 

```
cat unix_cafe.txt
```

we can reference files by relative path too:
```
cat staff/cooks.txt
```

```
cat staff/waiters.txt 
```

Let's navigate into the `menu` directory

```
cd menu
```
and look at its contents:
```
ls 
```

We can see the contents of hours, and staff too:

```
ls ../staff
ls ../hours
```

So, even though we are in the `menu/` directory, we can see what is in other directories by using the relative path to the directory of interest. Note we can also use absolute paths too. You may have noticed the `../` this is how to get to the directory above the one you are currently located in. 

This `..` feature can be used to help us navigate directories. Move back up, out of the menu folder with 
```
cd ..
```

Note: in this case, we have access to the RStudio file browser, too, which is really nice. But in some situations, like if you are using a remote high performance compute cluster (HPC), you'll have to get by with just the command line interface and no other interface!

Wouldn't it be nice to see the contents of multiple directories at once? We can use the wild card character `*`, which expands to match any amount of characters.

```
ls menu
```

```
ls menu/fall*
```

```
ls menu/*
```

We are quite used to moving, copying and deleting files using a GUI. All of these functions can be carried out at the command line with the following commands: 

Copy files with the `cp` command by specifying a file to copy and the location of the copied file. 

```
cd menu
ls
```

```
cd fall
ls
```

```
cp fall_lunch.txt fall_dinner.txt
ls
```

The syntax for the copy command is `cp <source_file> <destination>`. Using this syntax we can copy files to other directories as well:

```
cp year_round_offerings.txt ../spring/
```

If we list the files that are in the spring directory, we will see the `year_round_offerings.txt` file has been copied to the `spring/` directory.

```
ls -l ../spring
```

#### Practice:

1. use that `cat` function! check out the contents of `fall_festival_specials.txt`, and 2 more menus.


2. from the `spring/` directory, copy the spring lunch menu to a spring dinner menu

3. Super Challenge: A menu was misplaced! Given that the syntax for copy is the same as the syntax for move, use the `mv` (move) command to move the `fall_desserts.txt` file from `spring/` to `fall/`.


## Copy, move, remove
Once we know how to copy and move files, we can also copy and move directories. We can create new directories with the command `mkdir`. Let's make a new directory called `winter`

```
cd ~/hannahs_unix_cafe/menu
mkdir summer
ls -l
```

The shell is quite powerful and can create multiple directories at once. It can create multiple in the current working directory:

```
mkdir winter take-out
ls -l
```

or it can create a series of directories on top of one another:

```
cd ..
mkdir -p company_secrets/lie/deep/within/the/caverns/of/unix/
```

We can use tab complete to get to the `unix` directory. Type `cd c ` then hit `tab`. If you hit tab enough times your command will eventually read:

```
cd company_secrets/lie/deep/within/the/caverns/of/unix/
```

This nicely hints at the power of the shell - you can do certain things (in this case, create a nested hierarchy of directories) much more easily in the shell. But that power cuts both ways - you can also mess things up more easily in the shell!


Now let's talk about deleting things:
```
cd ~/hannahs_unix_cafe
```

delete a file with the `rm` command:
```
rm health_report_2023.txt
```

you can delete files with their relative path too:

```
rm  hours/holiday_hours/summer_hours.txt 
```

you can delete an empty directory with `rmdir`:
```
rmdir menu/summer
```

## Section 2: Working with files (CSV scavenger hunt)
---------------------------------

### Learning Goals
* looking inside files
* search for keywords within files
* commands: `curl`, `less`, `head`, `tail`, `wc` `grep`, `cut`
* running a script
------------------------------------------

Let's try out several of the tools and strategies we use for file manipulation the course via a digital scavenger hunt using (drumroll) ...South Park dialogue!

### Download the csv

Here, we'll download a file directly to our remote instance using the Terminal. This cuts out the intermediate step of downloading to our laptops.

```
curl -JLO https://raw.githubusercontent.com/mblstamps/stamps2023/main/intro-unix/season1.csv
```
> curl is a unix command to download files. We are using the following options
> - -J Use the header-provided filename
> - -L Follow file redirects
> - -O Write output to a file named as the remote file

## View the Spreadsheet

Use `ls` to view the file.

In the files pane on the right, you should now see a file, `season1.csv`. Click on this file and select 'View File' to view. It should open in a tab in the main pane.

Here we have four columns: `Season`,`Episode`,`Character`,`Line` showing us which character said each line of dialogue, and in which season and episode.

![](https://hackmd.io/_uploads/By4MV4852.png)



### Let's look at this file on the command line 

Let's start with the `cat` command so we can see what's in the file.
```
cat season1.csv
```

A lot of text printed to the screen. Is there a better way to see a large file like this? _(yes)_

We can start by just looking at the top of the file:

```
head season1.csv
```

We can also look at the end of the file:

```
tail season1.csv
```

Now try the command `less`, which is a page-viewer. Now you can scroll up and down in the file.
```
less season1.csv
```
> Press `q` to exit the `less` viewer.


## Digging into the file
You may have some burning questions you need answers for, like:

### How many lines of dialogue were said in season 1 of south park?

The command `wc` ('word count') can be used to count lines.
```
wc -l season1.csv
```
> `-l` specifies that we only want the number of lines in the output.


### How many times does the term "genetic engineering" show up in season 1? 

Let's use the unix command `grep` to sort through the file and ask questions.

`grep` (global regular expression) is a search tool. It looks through text files for strings (sequences of characters). In its default usage, grep will look for whatever string of characters you give it (1st positional argument), in whichever file you specify (2nd positional argument), and then print out the lines that contain what you searched for.

Let’s try it:

```
grep "genetic engineering" season1.csv
```


We can chain these two commands together, to select lines with "genetic engineering" and then count lines:

```
grep "genetic engineering" season1.csv | wc -l
```

It was said seven times!

Alternatively, we can use the `-c` option to have grep count the number of lines for us. You'll notice there's no line output here - grep counts internally and only reports the number found.
```
grep -c "genetic engineering" season1.csv
```
> Use `grep --help`  to see all `grep` options


### How many times did a character say 'Kenny'?

Here, we can grep for the word 'Kenny', as above, but since Kenny is a character, this will return all the lines where Kenny is speaking. We can use another command, `cut`, to select just the column of interest:

```
cut -f 4 -d ',' season1.csv
```
> - `-f 4` specifies the fourth column
> - `-d ','` specifies that the file is comma-delimited (default is tab)

We can combine this command, as before:
```
cut -f 4 -d ',' season1.csv | grep Kenny
```
If we count with `grep -c`, we see that Kenny's name was said 26 times. If you just use `grep -c Kenny` on the whole file, you should get 136 lines, so Kenny himself had 110 lines of dialog!

### Outputting to a file
If you'd like to save your results to a file, you can  use the '>' character 
```
cut -f 4 -d ',' season1.csv | grep Kenny > someone_said_kenny.txt
```
> This creates a new file called `someone_said_kenny.txt`, which you can view with `cat`, `head`, `tail`, or `less`, as above.


There are many more helpful unix tools which we won't touch on today. Mike Lee has a tutorial of [six glorious commands](https://astrobiomike.github.io/unix/six-glorious-commands), which starts with `cut` and `grep` and adds `paste`, `set`, `awk`, and `tr`.


## Run an R script to summarize and plot

When we want to do more data summarization or visualization, we often want to run other programs or scripts.

For this analysis, let's download an R script that plots the number of times a character says the phrase 'killed Kenny' (as in "Oh No! They've killed Kenny!").

Download the script from this link:
```
curl -JLO https://raw.githubusercontent.com/mblstamps/stamps2023/main/intro-unix/plot-kenny.R
```

This should download a file called `plot-kenny.R`. Use `ls` to verify that the file downloaded.

Since R is already installed on our instances, we can run this script with:

```
Rscript plot-kenny.R season1.csv
```
This script is set up to use the file passed after the script (here: `season1.csv`) as input.

As it's running, you should see some output go by and then get your terminal prompt (`$`) back. At this point, you can use `ls` to see that we have a new file named `killed_kenny.png`.

You can also see this new file in the 'Files' pane of your RstudioServer. Click on the file: A plot should open in your browser with a new plot, showing which characters said the words 'killed Kenny'! 

![](https://hackmd.io/_uploads/rJLSLr8qh.png)


## Challenge: Re-do the analysis with 18 seasons of data

Download a file with 18 seasons of dialogue. Via the Terminal, use the following code to download the file.
```
# download file with dialogue from 18 seasons
curl -JLO https://github.com/ngs-docs/2021-remote-computing-binder/raw/latest/SouthParkData/All-seasons.csv.gz
# unzip from gzip compression
gunzip All-seasons.csv.gz
```
> '.gz' is an extension used to signify that the file is compressed using 'gzip'. We unzip this file with `gunzip`.

- Try opening this file in RStudioServer. Are there any differences compared with the `season1.csv` file?

:::info
The `All-seasons.csv` is too large to view in the RStudioServer. This can often happen if trying to open large bioinformatic files with graphical spreadsheet programs. This is one reason to use command-line methods for processing and vizualizing data.
:::


- Now try running the Rscript to produce a plot from the `All-seasons.csv` dialogue file.


:::spoiler
![](https://hackmd.io/_uploads/S1hv3xvc3.png)
:::

-----

## Resources
The materials in this lesson are adapted from the following resources:

- [Data Carpentries: Introduction to the Command Line for Genomics](https://datacarpentry.org/shell-genomics/)
- [DIB Lab: Advanced Beginner Shell](https://dib-training.readthedocs.io/en/pub/2016-01-13-adv-beg-shell.html)
- [ggg298 lab2: UNIX_for_file_manipulation](https://github.com/ngs-docs/2021-GGG298/tree/latest/Week2-UNIX_for_file_manipulation)
- [Unix via Hannahs Unix Cafe](https://github.com/hehouts/lab14_binder/blob/main/lab14.md)

Mike Lee also has some excellent unix materials:
- https://astrobiomike.github.io/unix/
- https://astrobiomike.github.io/unix/six-glorious-commands 





