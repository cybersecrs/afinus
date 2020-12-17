Afinus is updated to 1.6, after I finally found some time for myself, I was too busy in last month. I'll continue on developing this gem to add log-parser and sftp/scp backup. Thank's all who (and who will be) contribute to this project. 

## How it work?

Afinus can take multiple options as arguments, like `-d` and `-r`. First one define start directory, or will use *working-dir* as start folder if not defined. Second one is for recursive mode, and it will clean all folders inside working-dir if defined. For full-clean you can specify `-e | --empty` option, and empty space on your drive will be filled with random-byte files. Each file will be overwritten with max 100 random bytes, truncated to 0. Process will repeat 6 times, including files created to fill empty space. After that, all folders will be removed. You can specify `--files` argument to skip cleaning files, and `--dirs` to skip removing directories. Personally, I use **AFINUS** as kill-switch to perform wipe if intrusion detected.

## How to install?

Make sure you have installed GIT and Ruby language. After that execute this:

```bash
git clone https://www.github.com/cybersecrs/afinus
cd afinus && bundle install
```

## How to use?

Execute from afinus root directory:

```ruby
  ruby afinus  -  Wipe data in working directory

#  OPTIONS:

  --recursive,  -r  -  Clean directories recursively
  --empty,      -e  -  Fill empty space
  --dir=<DIR>,  -d  -  Working directory (default: working dir)
  --files           -  Don't wipe files
  --dirs            -  Don't remove folders
  --help,       -h  -  Show help message
```

To use as a Gem in your projects:

```ruby
  afinus = AFINUS::Wipe.new

  afinus.enter("/root")                      -  Enter directory
  afinus.fill_empty_space! bytes             -  Fill empty partition space with random-byte-files, (default: 512K )
  afinus.clean(recursive:false)              -  Clean all files, recursively or not
  afinus.remove_directories(recursive:false) -  Remove all directories, recursively or not

```
