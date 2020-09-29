```
#================================================================================#
#                  Anti-Forensic-Investigation Null Script                       #
#--------------------------------------------------------------------------------#
#                                                                                #
#   ***********************                                                      #
#   *                     *                                                      #
#   *  [AFI] Null Script  *  by Cybersec-RS                                      #
#   *                     *                                                      #
#   ***********************                                                      #
#                                                                                #
#  ============================================================================  #
#      Version: [1.5]   -   https://www.cybersecrs.github.io/afinus              #
#  ============================================================================  #
#                                                                                #
#       Author: Linuxander                                                       #
#                                                                                #
#  Description: Take first argument as start folder, loop inside to overwrite    #
#               each file with 50 random bytes, then truncate all to zero.       #
#               If no arguments are given, default is working dir.               #
#                                                                                #
#               + added option to fill empty space with random-byte files        #   
#               + added option for recursive loop with --rec as argument         #
#               + added color output                                             #
#               + added option to remove remove file after clean                 #
#               + added 'remove_directories' after clean                         #
#                                                                                #
#         Note: Author is NOT responsible for any damage caused by AFINUS!       #
#               Always backup your files before use! Test in Virtual Machine!    #
#                                                                                #
#      ====================================================================      #
#                      HAPPY HACKING & DON'T KEEP LOGS !!!                       #
#      ====================================================================      #
#                                                                                #
##################################################################################
```


## Introduction to AFINUS

*AFINUS* is ruby script to destroy data on device. This is useful if you want
to sell your computer, but you want to be sure that buyer wouldn't be able to find your data.
This simple script can make all your files non-recoverable even for experts, but if you
work with high-sensitive data, you can also fill HD with random bytes (default 512kb).
Code is designed as typical Ruby code, in small blocks, DRY.

---

## How it work?

If you start script without arguments, working directory will be *start-folder*.
You can also add '--rec' argument for recursive clean, it will clean all *sub-folders.*
If you use *recursive* and *start-folder* args, '--rec' go second.

```ruby
ruby afinus.rb /home/username --rec
```

*AFINUS* then collect all files and count directories. It will skip files
with 0 byte, if no write permission, or if file is a symlink. Otherwise, it will
overwrite file multiple times with 50 and 100 random bytes, truncate all to 0, then remove it.
Filenames for new files are random INT, and file extension is *.fillfile*.
This make it easy to fill empty space and remove only those files created by self.

```ruby
  unless File.directory?(file) || File.symlink?(file)

  begin

    if File.zero?(file)
      puts " #{file} is Null-Byte ... skipped!".red
    else
      rewrite("#{file}") if File.writable?("#{file}")
    end

  rescue
      puts " >> FOLDER DO NOT EXIST OR PERMISSION DENIED <<\n".red.bold
  end

  else
     @c_dir += 1
     print_lines("#{@c_dir}".yellow.bold, "#{file}", "Directory Found!\n".white)
     @dirs << "#{file}"
  end

```

You must have permission for *start-folder*, other errors are handled.
Method 'execute!' is outside of other definitions, edit for your own use case.
Default use case is as follows:

 1. Enter start-folder *(working-dir)*  
 2. Fill empty space with random bytes (512000)  
 3. Clean all files in directory  
 4. Countinue recursive if started with *--rec*  

```ruby

# 'AFI.execute!' - define start-folder and reursive option 


  def execute!(directory, opt)

   @start_time = Time.now

    ARGV[1] = "--rec" if opt == "--rec"

    if (ARGV.empty? or ARGV[0] == "--rec")
      directory = Dir.pwd
    else
      directory = ARGV[0]
    end

    if ARGV[0] == "--rec" || ARGV[1] == "--rec"
      enter(directory)
      fill_empty_space!(512000)       # Remove this line to not clean empty space before recursive clean
      clean!("recursive")
      # add methods to repeat cleaning files (paranoid)
    else
      enter(directory)
      fill_empty_space!(512000)           # Remove this line to not clean empty space before clean
      clean!("")
      # add methods to repeat cleaning files (paranoid)
    end

   @end_time = Time.now

    print_info
    print_thank_you
  end

```

**File counters are initialized with new object**

```ruby
  def initialize

    @c_file     =     File counter
    @c_dir      =     Directory counter
    @c_err      =     Error counter
    @c_byte     =     New File counter
    @dirs       =     Array of counted directories

  end
```

---

## Usage

**Work with script**

```ruby
`  ruby afinus.rb  `                      -  Clean working directory
`  ruby afinus.rb --rec  `                -  Clean recursively from working dir
`  ruby afinus.rb /home/username  `       -  Clean files in /home/username directory
`  ruby afinus.rb /home/username --rec  ` -  Clean files recursively from /home/username directory
```

**Use it as a GEM**

```ruby
`  AFI.new.enter("/root")  `              -  Enter directory *(start-folder)*
`  AFI.new.fill_empty_space!(512000)  `   -  Fill empty partition space with 512K *random-byte-files*
`  AFI.new.clean!("fill_empty")  `        -  Clean newly created *random-byte-files*
`  AFI.new.clean!("")  `                  -  Clean all files in folder
`  AFI.new.clean!("recursive")  `         -  Clean working folder recursively
`  AFI.new.execute!("/root", "--rec")  `  -  Enter root, fill empty space, then clean recursively
```
---

## Example

**Clean partition empty space**

```ruby
 require 'afinus'

   afinus = AFI.new
   afinus.enter("/home/linuxander")
   afinus.fill_empty_space!(512000)
   afinus.clean!("fill_empty")
```

**Clean partition empty space and all files in folder**

```ruby
 require 'afinus'

   afinus = AFI.new
   afinus.enter("/home/linuxander")
   afinus.fill_empty!(512000)
   afinus.clean!("")

 [same as]:

   AFI.new.execute!("/home/linuxander", "")
```

**Combine methods for more paranoid clean, or edit 'rewrite(file)' as u need it**

```ruby
[1] - fill empty and overwrite folder files 3 times

   afinus = AFI.new
   afinus.enter("/home/linuxander")
   afinus.fill_empty_space!(512000)
   3.times do afinus.clean!("") end


[2] - 3 times fill empty and overwrite all recursively

   afinus = AFI.new
   3.times do
     afinus.execute!("/home/linuxander", "recursive")
   end


[3] - Edit rewrite for more paranoid clean

   def rewrite(file)
    begin
     File.write("#{file}", "#{Random.new.bytes(50)}")
     File.truncate("#{file}", 0)
 # ADD FOR PARANOID
     File.write("#{file}", "#{Random.new.bytes(20)}")
     File.write("#{file}", "#{Random.new.bytes(30)}")
     File.truncate("#{file}", 0)
 # END PARANOID ADD
     @c_file += 1
     print_lines("#{@c_file}".yellow, "#{file}".white, "Overwritten and Nulled!\n".yellow)
    rescue
     @c_err += 1
     print_lines("#{@c_err}".red, "#{file}".white.bold, "NOT PROCESSED => PERMISSION PROBLEM?\n".red.bold)
    end
   end     # end of rewrite

```

---

## TO-DO

 - Documentation                    -  (not only about Afinus, but also about file security)
 - More functions
 - 1-click-install-and-run script   -  (Bash and PowerShell scripts to install Ruby and Afinus)
 - Compile into EXE and APP
 - Create Android APK with Jruby    -  (kill-switch to erase android phones)

---

## Contribute

I will look forward to update this code with more functions, and to pack it as a GEM.
You are more then welcome to contribute, just do it right way. If you write new function,
make it in new small blocks, so it can be used in shell or GEM (don't forget comments).
At the end, write test and submit pull request.

Documentation is coming...

If you want to support the project, share the link:  
Instagram: @cybersecrs  
www.cybersecrs.github.io/afinus  

---

## Read the License

*AFINUS* can be used, edited and/or sold as long as you keep it Open-Source!  
Author is NOT responsible for any damage caused by this script!  
For more info, read the LICENSE file.  
