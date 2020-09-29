#!/usr/bin/env ruby

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


require 'colorize'


class AFI


#  Start counters

  def initialize
    @c_file = 0
    @c_dir  = 0
    @c_err  = 0
    @c_byte = 0
    @dirs   = []
  end


#  Print file counter and time info

  def print_info
    print "\n [#{@c_file}] files cleaned in [#{(@end_time - @start_time).round(3)}] seconds".white
    print "\n==========================================================================\n".white
  end


#  Print "thank you" note

  def print_thank_you
    print "\n Thank's for using AFI Null Script! Stay with TAILS to protect your privacy!\n".yellow.bold
  end


#  Enter start directory or exit

  def enter(dir)
    begin
      Dir.chdir(dir)
      working_dir
    rescue
      puts ""
      puts " >> FOLDER DO NOT EXIST OR PERMISSION DENIED <<".red.bold
      puts ""
      exit(1)
    end
  end   # end of enter(dir)


#  Print working directory

  def working_dir
    puts ""
    print "============================================================\n".yellow
    print " You are in".green
    print " #{Dir.pwd}\n".white.bold
    print "============================================================\n".yellow
    puts ""
  end


#  Define printer for processed files

  def printer(counter, name, note)
    print "[#{counter}] - "
    print "#{name}"
    print " - #{note}"
  end


#  Create random-byte file

  def random_bytes(bytes)
    while true do
      random = Random.new(192853718475125)
      a_rand = "#{rand(99999999999999999)}.fillfile"
      @c_byte += 1
      File.write("#{a_rand}", "#{Random.new.bytes(bytes)}")
      printer("#{@c_byte}".yellow.bold, "Created #{a_rand}".white, "#{bytes} bytes\n".white)
    end
  end       # end of create_random_bytes


#  Fill empty space on partition

  def fill_empty_space!(bytes)
    begin
      @start_time = Time.now
      random_bytes(bytes)
    rescue
      @end_time = Time.now
      print "\n [#{@c_byte}] files created in [#{(@end_time - @start_time).round(3)}] seconds".white
      print "\n==========================================================================\n\n".white
    end
  end       # end of fill_empty_space!


#  Collect files to clean

  def collect(option)
    if option == "recursive"
      Dir.glob(File.join("**", "*"))
    elsif option == "fill_empty"
      Dir.glob("*.fillfile")
    else
      Dir.glob("*")
    end
  end     # end of collect


#  Overwrite and Null file

  def rewrite(file)
   begin
    File.write("#{file}", "#{Random.new.bytes(50)}")
    File.truncate("#{file}", 0)
    File.write("#{file}", "#{Random.new.bytes(100)}")
    File.truncate("#{file}", 0)
    File.write("#{file}", "#{Random.new.bytes(50)}")
    File.truncate("#{file}", 0)
    File.delete(file)
    @c_file += 1
    printer("#{@c_file}".yellow, "#{file}".white, "Overwritten, Nulled, Removed!\n".yellow)
   rescue
    @c_err += 1
    printer("#{@c_err}".red, "#{file}".white.bold, "NOT PROCESSED => PERMISSION PROBLEM?\n".red.bold)
   end
  end     # end of rewrite


#  Remove Directories

  def remove_directories!(option)
    unless option == "recursive"
      collect("").each { |dir| Dir.rmdir(dir) if File.direcory?(dir) }
    else
      collect("recursive").each { |dir| Dir.rmdir(dir) if File.direcory?(dir) }
  end


#  Clean all files!

  def clean!(option)

   collect(option).each { |file|
    unless File.directory?(file)
      if File.zero?(file)
        File.delete(file)
      else    
      begin
        (rewrite(file); File.delete(file)) if File.writable?(file)
      rescue
        puts " >> FOLDER DO NOT EXIST OR PERMISSION DENIED <<\n".red.bold
      end end 
    else
      @c_dir += 1
      printer("#{@c_dir}".yellow.bold, "#{file}", "Directory Found!\n".white)
      Dir.rmdir(file) if Dir.empty?(file)
      @dirs << "#{file}"
    end  }

   print "\n [#{@c_dir}] directories counted".white

  end       # end of clean!


#  Enter "start-folder" as first argumet. If no arg is given, "start-folder" is working dir
#  Add "--rec" argument for recursive clean. In use with "start-folder", "--rec" must be second argument

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
      fill_empty_space!(512000)           # Fill empty space before folder clean!
      clean!("")
      remove_directories!("")
    end

  @end_time = Time.now

    print_info
    print_thank_you
  end

end # END OF CLASS

#                              END OF DEFINITIONS                                #
#================================================================================#


#  SCRIPT EXECUTION

  AFI.new.execute!("#{Dir.pwd}", "")
  

