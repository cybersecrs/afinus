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
#      Version: [1.5]   -   https://www.github.com/cybersecrs/afinus             #
#  ============================================================================  #
#                                                                                #
#       Author: Linuxander                                                       #
#                                                                                #
#  Description: Take first argument as start folder, loop inside to overwrite    #
#               each file multiple times, truncate to zero and delete.           #
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

*AFINUS* then collect all files and count directories, it will skip files if no write permission.
It will overwrite file 6 times, with 50 and 100 random bytes and truncating all to 0 between it, then remove it.
Filenames for new files are random INT, and file extension is *.fillfile*.
This make it easy to fill empty space and remove only those files created by self.

```ruby
 def clean!(option)

   collect(option).each { |file|
    unless File.directory?(file)
      begin
        rewrite(file) if File.writable?(file)
      rescue
        puts " >> FOLDER DO NOT EXIST OR PERMISSION DENIED <<\n".red.bold
      end 
    else
      @c_dir += 1
      printer("#{@c_dir}".yellow.bold, "#{file}", "Directory Found!\n".white)
      Dir.rmdir(file) if Dir.empty?(file)
      @dirs << "#{file}"
    end  }

   print "\n [#{@c_dir}] directories counted".white

  end
```

You must have permission for *start-folder*, or Afinus will exit.
Method 'execute!' is outside of other definitions, edit for your own use case if you use it as a gem.
Default use case is as follows:

 1. Enter start-folder *(working-dir)*  
 2. Fill empty space with random bytes (512000)  
 3. Overwrite with 50 rand bytes, then 0, then 100, again 0, 50 rand bytes, 0, remove file.  
 4. Countinue recursive if started with *--rec*
 5. Delete all directories at the end

```ruby

# 'AFI.execute!' - define start-folder and reursive option 


  def execute!(directory, opt)

  def execute!(directory, opt)

  @start_time = Time.now

    ARGV[1] = "--rec" if opt == "--rec"

    if ARGV.empty? or ARGV[0] == "--rec"
      directory = Dir.pwd
    else
      directory = ARGV[0]
    end

    if ARGV[0] == "--rec" || ARGV[1] == "--rec"
      enter(directory)
      fill_empty_space!(512000)       # Fill empty space before recursive clean!
      clean!("recursive")
      remove_directories!("recursive")
    else
      enter(directory)
      fill_empty_space!(512000)
      clean!("")
      remove_directories!("")
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
`  AFI.new.enter("/root")  `              -  Enter directory (start-folder)
`  AFI.new.fill_empty_space!(512000)  `   -  Fill empty partition space with 512K random-byte-files
`  AFI.new.clean!("fill_empty")  `        -  Clean newly created random-byte-files
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
[1] - fill empty and overwrite folder files with 3 more circles

   afinus = AFI.new
   afinus.enter("/home/linuxander")
   afinus.fill_empty_space!(512000)
   3.times do afinus.clean!("") end


[2] - 3 circles with 6 fill empty and overwrite files, do all recursively

   afinus = AFI.new
   3.times do
     afinus.execute!("/home/linuxander", "recursive")
   end


[3] - Edit rewrite for more paranoid clean

   def rewrite(file)
    ......
      File.write("#{file}", "#{Random.new.bytes(20)}")
      File.write("#{file}", "#{Random.new.bytes(30)}")
      File.truncate("#{file}", 0)
    ......
   end

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
www.github.com/cybersecrs/afinus  

---

## Read the License

*To use AFINUS in Albania you must pay for the license key*  
Otherwise, *AFINUS* can be used, edited and/or sold as long as you keep it Open-Source & give credits!  
Author is NOT responsible for any damage caused by this script!  
For more info, read the LICENSE file.  
